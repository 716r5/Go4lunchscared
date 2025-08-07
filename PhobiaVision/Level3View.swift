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
                let targetEntity = value.entity
                if initialPosition == nil {
                    initialPosition = targetEntity.position
                }

                let movement = value.convert(value.translation3D, from: .global, to: .scene)
                targetEntity.position = (initialPosition ?? .zero) + movement.grounded
                targetEntity.components[PhysicsBodyComponent.self]?.mode = .kinematic
            }
            .onEnded { value in
                initialPosition = nil
                value.entity.components[PhysicsBodyComponent.self]?.mode = .dynamic
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

                    let fileName = "source"
                    guard let animal = try? await ModelEntity(named: fileName) else {
                        assertionFailure("Failed to load model: \(fileName)")
                        return
                    }

                    let scale = 0.001 / 100 * Float(options.scaling)
                    animal.scale = SIMD3<Float>(scale, scale, scale)
                    animal.position = startPosition
                    animal.orientation = simd_quatf(angle: Float(i) * .pi / 4, axis: [0, 1, 0])
                    animal.name = "ball_\(i)"
                    animal.components.set(InputTargetComponent())

                    let collisionShape = ShapeResource.generateSphere(radius: scale * 50)
                    animal.collision = CollisionComponent(shapes: [collisionShape])

                    animal.components.set(GroundingShadowComponent(castsShadow: true, receivesShadow: false))
                    animal.components.set(PhysicsBodyComponent(
                        massProperties: .default,
                        material: .default,
                        mode: .kinematic // set to kinematic so we can control movement manually
                    ))

                    content.add(animal)

                    DispatchQueue.main.async {
                        ballEntities.append(animal)

                        var direction: Float = 1.0
                        let speed: Float = 0.5  // meters per second
                        let maxDistance: Float = 0.5
                        let originalX = startPosition.x

                        let timer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { _ in
                            let delta: Float = 0.016
                            var newX = animal.position.x + direction * speed * delta

                            let distanceFromOrigin = newX - originalX

                            if abs(distanceFromOrigin) >= maxDistance {
                                // Reverse direction
                                direction *= -1

                                // Rotate 180 degrees around Y axis
                                let turn = simd_quatf(angle: .pi, axis: [0, 1, 0])
                                animal.orientation = turn * animal.orientation

                                // Continue from current position, don't snap
                                newX = animal.position.x + direction * speed * delta
                            }

                            animal.position.x = newX
                        }

                        timers.append(timer)
                    }
                }
            }
            .gesture(translationGesture)

            // Uncomment for a reset button
//            Button(action: {
//                resetSceneAndDismiss()
//            }) {
//                Label("Close", systemImage: "xmark.circle.fill")
//                    .font(.title)
//                    .fontWeight(.bold)
//                    .padding(.horizontal, 24)
//                    .padding(.vertical, 12)
//                    .background(Color.red.opacity(0.9))
//                    .foregroundColor(.white)
//                    .clipShape(Capsule())
//                    .shadow(radius: 10)
//                    .padding()
//            }
        }
    }
}
