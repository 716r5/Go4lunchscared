//
//  Level4View.swift
//  PhobiaVision
//
//  Created by Interactive 3D Design on 6/8/25.
//

import SwiftUI
import RealityKit
import ARKit

struct Level4View: View {
    var body: some View {
        RealityView { content in
            makeHandEntities(in: content)
        }
    }

    /// Creates the entity that contains all hand-tracking entities.
    @MainActor
    func makeHandEntities(in content: any RealityViewContentProtocol) {
        // Add the left hand.
        let leftHand = Entity()
        leftHand.components.set(HandTrackingComponent(chirality: .left))
        content.add(leftHand)

        // Add the right hand.
        let rightHand = Entity()
        rightHand.components.set(HandTrackingComponent(chirality: .right))
        content.add(rightHand)
    }
}
