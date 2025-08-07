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

struct Level3View: View {
    @State var initialPosition: SIMD3<Float>? = nil
    @State private var ballEntities: [ModelEntity] = []
    @State private var timers: [Timer] = []

    @Binding var options: OptionsStruct

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
            } catch {
                print("ARKit session error: \(error.localizedDescription)")
            }

            await generator.run(sceneReconstruction)
        }
    }

    func resetSceneAndDismiss() {
        for ball in ballEntities {
            ball.removeFromParent()
        }
        ballEntities.removeAll()

        for timer in timers {
            timer.invalidate()
        }
        timers.removeAll()

        dismiss()
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            RealityView { content in
                let meshAnchors = Entity()
                runSession(meshAnchors)
                content.add(meshAnchors)

                let floorMesh = MeshResource.generatePlane(width: 0.0001, depth: 0.0001)
                let floorMaterial = SimpleMaterial(color: .white, isMetallic: false)

                let floorEntity = ModelEntity(mesh: floorMesh, materials: [floorMaterial])
                floorEntity.name = "InvisibleFloor"
                floorEntity.collision = CollisionComponent(shapes: [.generateBox(size: [20, 0.01, 20])])
                floorEntity.physicsBody = PhysicsBodyComponent(mode: .static)
                floorEntity.position = SIMD3<Float>(0, 0, 0)

                content.add(floorEntity)

                let ballCount = Int(options.amountOfSpiders)

                for i in 0..<ballCount {
                    let x = Float.random(in: -3.0...3.0)
                    let z = Float.random(in: -3.0...3.0)
                    let startPosition = SIMD3<Float>(x, 0.01, z)

                    let fileName = options.animal
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
                    animal.position = startPosition
                    animal.orientation = simd_quatf(angle: 90, axis: [0, 1, 0])
                    animal.name = "ball_\(i)"
                    animal.components.set(InputTargetComponent())

                    let collisionShape = ShapeResource.generateSphere(radius: scale * 50)
                    animal.collision = CollisionComponent(shapes: [collisionShape])

                    animal.components.set(GroundingShadowComponent(castsShadow: true, receivesShadow: false))
                    animal.components.set(PhysicsBodyComponent(
                        massProperties: .default,
                        material: .default,
                        mode: .static // set to kinematic so we can control movement manually
                    ))
                    
                    for anim in animal.availableAnimations {
                        animal.playAnimation(anim.repeat(duration: .infinity),
                                                  transitionDuration: 1.25,
                                                  startsPaused: false)
                    }

                    content.add(animal)

                    DispatchQueue.main.async {
                        ballEntities.append(animal)

                        var direction: Float = 1.0
                        let speed: Float = 1.0  // meters per second
                        
                        var maxDistance: Float
                        if options.animal == "Lizard" || options.animal == "Snake"{
                            maxDistance = 1
                        } else {
                            maxDistance = 0.2
                        }
                        
                        let originalX = startPosition.x

                        let timer2 = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                            var innerTimer: Timer?
                            
                            innerTimer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { _ in
                                if direction == 1.0 {
                                    animal.orientation = simd_quatf(angle: -80, axis: [0, 1, 0])
                                } else {
                                    animal.orientation = simd_quatf(angle: 80, axis: [0, 1, 0])
                                }
                                
                                let delta: Float = 0.016
                                var newX = animal.position.x + direction * speed * delta
                                
                                let distanceFromOrigin = newX - originalX
                                
                                if abs(distanceFromOrigin) >= maxDistance {
                                    direction *= -1
                                    newX = animal.position.x + direction * speed * delta
                                }
                                
                                animal.position.x = newX
                            }

                            if let innerTimer = innerTimer {
                                timers.append(innerTimer)

                                // Stop the inner timer after 0.4 seconds
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    innerTimer.invalidate()
                                }
                            }
                        }

                        timers.append(timer2)
                    }
                }
            }
            .gesture(translationGesture)
        }
    }
}
