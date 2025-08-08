//
//  Level4View.swift
//  PhobiaVision
//
//  Created by Interactive 3D Design on 6/8/25.
//

import SwiftUI
import RealityKit
import ARKit
import RealityKitContent

struct Level4View: View {
    @State private var session: SpatialTrackingSession?
    
    @Binding var options: OptionsStruct
        
        var body: some View {
            RealityView { content in
                
                //Begin a spatial tracking session to understand the location of the user's hands.

                let session = SpatialTrackingSession()
                let configuration = SpatialTrackingSession.Configuration(tracking: [.hand])
                _ = await session.run(configuration)
                self.session = session
                
                //Setup an anchor at the user's left palm.
                let handAnchor = AnchorEntity(.hand(.left, location: .palm), trackingMode: .continuous)

                //Add the Gauntlet scene that was set up in Reality Composer Pro.
                let animal = "\(options.animal)Scene"
                if let gauntletEntity = try? await Entity(named: animal, in: realityKitContentBundle) {
                   
                    for anim in gauntletEntity.availableAnimations {
                        gauntletEntity.playAnimation(anim.repeat(duration: .infinity),
                                                  transitionDuration: 1.25,
                                                  startsPaused: false)
                    }
                    
                    let scale = Float(options.scaling) / 100
                    gauntletEntity.scale = SIMD3<Float>(scale, scale, scale)
                    
                    //Child the gauntlet scene to the handAnchor.
                    handAnchor.addChild(gauntletEntity)
                    
                    // Add the handAnchor to the RealityView scene.
                    content.add(handAnchor)
                   
                    print("Success")
                }
            }
            .upperLimbVisibility(.hidden)
        }
    
}
