//
//  Level1View.swift
//  PhobiaVision
//
//  Created by Wei Song on 6/8/25.
//

import SwiftUI
import RealityKit

struct Level1View: View {
    var body: some View {
        RealityView { content in
            let anchor = AnchorEntity(world: [0, 0, -1.5])  // Spider floats 1.5m in front of user

            // Placeholder spider (pinkkkk sphere)
            let spider = ModelEntity(
                mesh: .generateSphere(radius: 0.1),
                materials: [SimpleMaterial(color: .systemPink, isMetallic: false)]
            )

            spider.name = "spider"
            spider.position = [0, 0, 0]

            anchor.addChild(spider)
            content.add(anchor)
        }
    }
}
#Preview {
    Level1View()
}
