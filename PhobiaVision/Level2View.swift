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
                    
                    let fileName: String = "source"
                    guard let animal = try? await ModelEntity(named: fileName) else {
                        assertionFailure("Failed to load model: \(fileName)")
                        return
                    }
                    
                    animal.position = position
                    animal.scale = SIMD3<Float>(0.0005, 0.0005, 0.0005)
                    animal.orientation = simd_quatf(angle: Float(i) * .pi / 4, axis: [0, 1, 0])
                    animal.name = "ball_\(i)"
                    animal.components.set(InputTargetComponent())
                    animal.generateCollisionShapes(recursive: false)
                
                    content.add(animal)

                    DispatchQueue.main.async {
                        ballEntities.append(animal)
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
            // If you want to drag and move the models
            
            
            // For Debugging Purpose
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
