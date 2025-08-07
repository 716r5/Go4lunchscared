///
//  Level4View.swift
//  PhobiaVision
//
//  Created by Interactive 3D Design on 6/8/25.
//
//
//import SwiftUI
//import RealityKit
//import ARKit
//
//struct Level4View: View {
//    // Store anchor and sphere references for updates
//    @State private var handAnchorEntity: AnchorEntity?
//    @State private var handSphere: ModelEntity?
//
//    var body: some View {
//        RealityView { content in
//            let arSession = ARKitSession()
//            let handTracking = HandTrackingProvider()
//
//            Task {
//                do {
//                    // Start AR session with hand tracking
//                    try await arSession.run([handTracking])
//                } catch {
//                    print("Failed to start ARKit session: \(error)")
//                    return
//                }
//
//                // Continuously receive hand updates
//                for await handInput in handTracking.anchorUpdates{
//                    // Check for right hand only
//                    if let rightHand = handInput.right {
//                        // Get right thumb tip joint
//                        if let thumbTipJoint = rightHand.joint(.thumbTip) {
//                            let position = thumbTipJoint.position
//                            let orientation = thumbTipJoint.orientation
//
//                            // Update or create the sphere at the thumbnail
//                            await updateObjectPosition(position: position, orientation: orientation, content: content)
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    // Create the sphere if it doesn't exist and update position & orientation
//    func updateObjectPosition(position: SIMD3<Float>, orientation: simd_quatf, content: RealityViewContent) async {
//        if handSphere == nil {
//            // Create a small red sphere
//            let sphere = ModelEntity(
//                mesh: .generateSphere(radius: 0.02),
//                materials: [SimpleMaterial(color: .red, isMetallic: false)]
//            )
//
//            let anchor = AnchorEntity()
//            anchor.addChild(sphere)
//
//            // Add anchor with sphere to the scene
//            content.add(anchor)
//
//            handAnchorEntity = anchor
//            handSphere = sphere
//        }
//
//        // Update the sphere’s position and orientation to match the thumbnail
//        handSphere?.position = position
//        handSphere?.orientation = orientation
//    }
//}
//
//#Preview {
//    Level4View()
//}
