//
//  PhobiaVisionApp.swift
//  PhobiaVision
//
//  Created by Wei Song on 6/8/25.
//

import SwiftUI

@main
struct PhobiaVisionApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        
        WindowGroup(id: "Level1") {
                    Level1View()
                }
        
        ImmersiveSpace(id: "Level2") {
            Level2View()
        }
    }
}
