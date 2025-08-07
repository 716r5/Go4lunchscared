//
//  PhobiaVisionApp.swift
//  PhobiaVision
//
//  Created by Wei Song on 6/8/25.
//

import SwiftUI

@main
struct PhobiaVisionApp: App {
    @State private var options: OptionsStruct = .init()
    var body: some Scene {
        WindowGroup {
            ContentView(options: $options)
        }.windowResizability(.contentSize)
        
        WindowGroup(id: "Level1") {
            Level1View()
        }.windowResizability(.contentSize)
        
        ImmersiveSpace(id: "Level2") {
            Level2View(options: $options)
        }
    }
}
