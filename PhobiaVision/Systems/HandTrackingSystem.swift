/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A system that updates entities that have hand-tracking components.
*/
import RealityKit
import ARKit
import UIKit

/// A system that provides hand-tracking capabilities.
struct HandTrackingSystem: System {
    /// The active ARKit session.
    static var arSession = ARKitSession()

    /// The provider instance for hand-tracking.
    static let handTracking = HandTrackingProvider()

    /// The most recent anchor that the provider detects on the left hand.
    static var latestLeftHand: HandAnchor?

    /// The most recent anchor that the provider detects on the right hand.
    static var latestRightHand: HandAnchor?

    init(scene: RealityKit.Scene) {
        Task { await Self.runSession() }
    }

    @MainActor
    static func runSession() async {
        do {
            // Attempt to run the ARKit session with the hand-tracking provider.
            try await arSession.run([handTracking])
        } catch let error as ARKitSession.Error {
            print("The app has encountered an error while running providers: \(error.localizedDescription)")
        } catch let error {
            print("The app has encountered an unexpected error: \(error.localizedDescription)")
        }

        // Start to collect each hand-tracking anchor.
        for await anchorUpdate in handTracking.anchorUpdates {
            // Check whether the anchor is on the left or right hand.
            switch anchorUpdate.anchor.chirality {
            case .left:
                self.latestLeftHand = anchorUpdate.anchor
            case .right:
                self.latestRightHand = anchorUpdate.anchor
            }
        }
    }
    
    /// The query this system uses to find all entities with the hand-tracking component.
    static let query = EntityQuery(where: .has(HandTrackingComponent.self))
    
    /// Performs any necessary updates to the entities with the hand-tracking component.
    /// - Parameter context: The context for the system to update.
//    func update(context: SceneUpdateContext) {
//        let handEntities = context.entities(matching: Self.query, updatingSystemWhen: .rendering)
//
//        for entity in handEntities {
//            guard var handComponent = entity.components[HandTrackingComponent.self] else { continue }
//
//            // Set up the finger joint entities if you haven't already.
//            if handComponent.fingers.isEmpty {
//                self.addJoints(to: entity, handComponent: &handComponent)
//            }
//
//            // Get the hand anchor for the component, depending on its chirality.
//            guard let handAnchor: HandAnchor = switch handComponent.chirality {
//                case .left: Self.latestLeftHand
//                case .right: Self.latestRightHand
//                default: nil
//            } else { continue }
//
//            // Iterate through all of the anchors on the hand skeleton.
//            if let handSkeleton = handAnchor.handSkeleton {
//                for (jointName, jointEntity) in handComponent.fingers {
//                    /// The current transform of the person's hand joint.
//                    let anchorFromJointTransform = handSkeleton.joint(jointName).anchorFromJointTransform
//
//                    // Update the joint entity to match the transform of the person's hand joint.
//                    jointEntity.setTransformMatrix(
//                        handAnchor.originFromAnchorTransform * anchorFromJointTransform,
//                        relativeTo: nil
//                    )
//                }
//            }
//        }
//    }
    
    func update(context: SceneUpdateContext) {
        let handEntities = context.entities(matching: Self.query, updatingSystemWhen: .rendering)

        for entity in handEntities {
            guard var handComponent = entity.components[HandTrackingComponent.self] else { continue }

            if handComponent.fingers.isEmpty {
                // Offload model loading and entity creation to a task
                Task {
                    let fingers = await self.addJoints(to: entity)
                    await MainActor.run {
                        guard var updatedComponent = entity.components[HandTrackingComponent.self] else { return }
                        updatedComponent.fingers = fingers
                        entity.components.set(updatedComponent)
                    }
                }
                continue
            }

            guard let handAnchor: HandAnchor = switch handComponent.chirality {
                case .left: Self.latestLeftHand
                case .right: Self.latestRightHand
                default: nil
            } else { continue }

            if let handSkeleton = handAnchor.handSkeleton {
                for (jointName, jointEntity) in handComponent.fingers {
                    let anchorFromJointTransform = handSkeleton.joint(jointName).anchorFromJointTransform
                    jointEntity.setTransformMatrix(
                        handAnchor.originFromAnchorTransform * anchorFromJointTransform,
                        relativeTo: nil
                    )
                }
            }
        }
    }
    
    /// Performs any necessary setup to the entities with the hand-tracking component.
    /// - Parameters:
    ///   - entity: The entity to perform setup on.
    ///   - handComponent: The hand-tracking component to update.
//    func addJoints(to handEntity: Entity, handComponent: inout HandTrackingComponent) {
//        /// The size of the sphere mesh.
//        let radius: Float = 0.01
//
//        /// The material to apply to the sphere entity.
//        let material = SimpleMaterial(color: .white, isMetallic: false)
//
//        /// The sphere entity that represents a joint in a hand.
//        let sphereEntity = ModelEntity(
//            mesh: .generateSphere(radius: radius),
//            materials: [material]
//        )
//
//        // For each joint, create a sphere and attach it to the fingers.
//        for bone in Hand.joints {
//            // Add a duplication of the sphere entity to the hand entity.
//            let newJoint = sphereEntity.clone(recursive: false)
//            handEntity.addChild(newJoint)
//
//            // Attach the sphere to the finger.
//            handComponent.fingers[bone.0] = newJoint
//        }
//
//        // Apply the updated hand component back to the hand entity.
//        handEntity.components.set(handComponent)
//    }
    
    func addJoints(to handEntity: Entity) async -> [HandSkeleton.JointName: Entity] {
        guard let modelEntity = try? await ModelEntity(named: "Cockroach") else {
            print("❌ Failed to load model: Cockroach")
            return [:]
        }

        modelEntity.scale = SIMD3<Float>(repeating: 0.01)

        var fingers: [HandSkeleton.JointName: Entity] = [:]

        for bone in Hand.joints {
            let jointModel = modelEntity.clone(recursive: true)
            handEntity.addChild(jointModel)
            fingers[bone.0] = jointModel
        }

        return fingers
    }
}
