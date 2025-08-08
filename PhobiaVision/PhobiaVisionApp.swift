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
        
        ImmersiveSpace(id: "Level3") {
            Level3View(options: $options)
        }
        
        ImmersiveSpace(id: "Level4") {
            Level4View(options: $options)
        }
        
        ImmersiveSpace(id: "TestView") {
            TestView(options: $options)
        }
        WindowGroup(id: "Spider1") {
            SpiderCardView(imageName: "spider1", message: "Breathe. It's just an image.")
        }.windowResizability(.contentSize)

        WindowGroup(id: "Spider2") {
            SpiderCardView(imageName: "spider2", message: "You are being very brave right now.")
        }.windowResizability(.contentSize)

        WindowGroup(id: "Spider3") {
            SpiderCardView(imageName: "spider3", message: "It's OK — it's not real.")
        }.windowResizability(.contentSize)

        WindowGroup(id: "Spider4") {
            SpiderCardView(imageName: "spider4", message: "You're doing better than you think.")
        }.windowResizability(.contentSize)

        WindowGroup(id: "Spider5") {
            SpiderCardView(imageName: "spider5", message: "Stay calm, you're safe.")
        }.windowResizability(.contentSize)
        
    }
}
