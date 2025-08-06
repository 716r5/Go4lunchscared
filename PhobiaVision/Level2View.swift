//
//  Level2View.swift
//  PhobiaVision
//
//  Created by Wei Song on 6/8/25.
//

import SwiftUI
import RealityKit
import ARKit
import RealityKitContent

struct Level2View: View {
    @State var initialPosition: SIMD3<Float>? = nil
    @State private var ballEntities: [ModelEntity] = []
    
    /// Used to dismiss the RealityView/Sheet
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
            }
            .onEnded { _ in
                initialPosition = nil
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

    func resetSceneAndDismiss() {
        for ball in ballEntities {
            ball.removeFromParent()
        }
        ballEntities.removeAll()
        dismiss()
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            RealityView { content in
                let meshAnchors = Entity()
                runSession(meshAnchors)
                content.add(meshAnchors)

                let ballCount = 30
                let radius: Float = 0.05

                for i in 0..<ballCount {
                    let x = Float.random(in: -3.0...3.0)
                    let z = Float.random(in: -3.0...3.0)
                    let position = SIMD3<Float>(x, radius, z)

//                    let sphere = MeshResource.generateSphere(radius: radius)
//                    let material = SimpleMaterial(color: .red, isMetallic: false)
//                    let ball = ModelEntity(mesh: sphere, materials: [material])
                    
                    let fileName: String = "source"
                    guard let chair = try? await ModelEntity(named: fileName) else {
                        assertionFailure("Failed to load model: \(fileName)")
                        return
                    }

                    // Generate collision shapes to the chair for proper occlusion.
//                    chair.generateCollisionShapes(recursive: true)
//                    
//                    // Enable inputs to detect the hand gestures.
//                    chair.components.set(InputTargetComponent())
                    
                    chair.position = position
                    chair.scale = SIMD3<Float>(0.0005, 0.0005, 0.0005)
                    chair.name = "ball_\(i)"
                    chair.components.set(InputTargetComponent())
                    chair.generateCollisionShapes(recursive: false)
                    

                    content.add(chair)

                    DispatchQueue.main.async {
                        ballEntities.append(chair)
                    }
                }
            }
            .gesture(
                TapGesture()
                    .targetedToAnyEntity()
                    .onEnded { value in
                        // Remove the tapped entity from the scene
                        value.entity.removeFromParent()
                        print("Tapped")
                    }
            )
//            .gesture(translationGesture)

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
