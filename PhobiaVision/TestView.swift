//
//  TestView.swift
//  PhobiaVision
//
//  Created by Wei Song on 6/8/25.
//

//
//  Level3View.swift
//  PhobiaVision
//
//  Created by Wei Song on 6/8/25.
//

import SwiftUI
import RealityKit
import ARKit
import RealityKitContent

struct TestView: View {
    @State var initialPosition: SIMD3<Float>? = nil
    
    @Binding var options: OptionsStruct
    
    /// Used to dismiss the RealityView/Sheet
    @Environment(\.dismiss) var dismiss

    var translationGesture: some Gesture {
        DragGesture()
            .targetedToAnyEntity()
            .onChanged { value in
                let entity = value.entity

                if initialPosition == nil {
                    initialPosition = entity.position
                }
                
                // Set to static or kinematic to disable physics during drag
                entity.components.set(PhysicsBodyComponent(
                    massProperties: .default,
                    material: .default,
                    mode: .static
                ))
                
                let movement = value.convert(value.translation3D, from: .global, to: .scene)
                entity.position = (initialPosition ?? .zero) + movement
                print("dragged")
            }
            .onEnded { value in
                let entity = value.entity

                entity.components.set(PhysicsBodyComponent(
                    massProperties: .default,
                    material: .default,
                    mode: .dynamic
                ))
                
                initialPosition = nil
                print("released")
            }
    }

    func runSession(_ meshAnchors: Entity) {
        let arSession = ARKitSession()
        let sceneReconstruction = SceneReconstructionProvider()

        Task {
            let generator = MeshAnchorGenerator(root: meshAnchors)

            guard SceneReconstructionProvider.isSupported else {
                print("SceneReconstructionProvider is not supported on this device.")
                return
            }

            do {
                try await arSession.run([sceneReconstruction])
            } catch let error as ARKitSession.Error {
                print("ARKit session error: \(error.localizedDescription)")
            } catch {
                print("Unexpected error: \(error.localizedDescription)")
            }

            await generator.run(sceneReconstruction)
        }
    }

    var body: some View {
        let anchor = AnchorEntity(.plane(.horizontal,
                             classification: .any,
                              minimumBounds: [0.2, 0.2]),
                               trackingMode: .predicted,
                          physicsSimulation: .none)

        
        ZStack(alignment: .topTrailing) {
            RealityView { content in
                let meshAnchors = Entity()
                runSession(meshAnchors)
                content.add(meshAnchors)
                
                let floor = ModelEntity(mesh: .generatePlane(width: 9, depth: 9))
                            floor.model?.materials = [OcclusionMaterial()]
                            floor.generateCollisionShapes(recursive: false)
                            floor.physicsBody = .init()
                            floor.physicsBody?.mode = .static
                            anchor.addChild(floor)

                content.add(anchor)
                
                let ballCount = Int(options.amountOfSpiders)

                for i in 0..<ballCount {
                    let x = Float.random(in: -3.0...3.0)
                    let z = Float.random(in: -3.0...3.0)
                    let y = Float.random(in: 1.0...5.0)
                    let position = SIMD3<Float>(x, y, z)
                    
                    let fileName: String = options.animal
                    guard let animal = try? await ModelEntity(named: fileName) else {
                        assertionFailure("Failed to load model: \(fileName)")
                        return
                    }
                    
                    var scale: Float

                    if options.animal == "Lizard" {
                        scale = 0.1 / 100 * Float(options.scaling)
                    } else {
                        scale = 0.001 / 100 * Float(options.scaling)
                    }

                    animal.scale = SIMD3<Float>(scale, scale, scale)
                    animal.position = position
                    animal.components.set(InputTargetComponent())
                    animal.generateCollisionShapes(recursive: true)
                    animal.physicsBody = .init()
                    animal.physicsBody?.mode = .dynamic
                    

                    content.add(animal)
                }
                
                let radius: Float = 0.2
                let sphereMesh = MeshResource.generateSphere(radius: radius)
                let sphereMaterial = SimpleMaterial(color: .red, isMetallic: true)

                let loadedBall = ModelEntity(mesh: sphereMesh, materials: [sphereMaterial])
                loadedBall.position = [0, 1, 0]
                loadedBall.name = "ball"
                loadedBall.components.set(InputTargetComponent())
                loadedBall.generateCollisionShapes(recursive: true)
                loadedBall.physicsBody = PhysicsBodyComponent(
                    massProperties: .default,
                    material: .default,
                    mode: .dynamic
                )

                content.add(loadedBall)
            }
            .gesture(translationGesture)
        }
    }
}
