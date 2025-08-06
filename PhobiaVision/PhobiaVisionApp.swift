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
        }.windowResizability(.contentSize)
        
        WindowGroup(id: "Level1") {
            Level1View()
        }.windowResizability(.contentSize)
        
        ImmersiveSpace(id: "Level2") {
            Level2View()
        }
    }
}
