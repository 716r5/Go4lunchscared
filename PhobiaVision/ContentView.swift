//
//  ContentView.swift
//  PhobiaVision
//
//  Created by Wei Song on 6/8/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @State private var showLevels = false
    @State private var selectedLevel: Int?
    @State private var isInImmersiveSpace = false
    
    @Environment(\.openWindow) private var openWindow
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // App Title
                Text("PhobiaVision")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                
                if !showLevels {
                    // Start Button
                    Button(action: {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            showLevels = true
                        }
                    }) {
                        Text("START")
                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(width: 200, height: 60)
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                            )
                    }
                    .scaleEffect(showLevels ? 0.8 : 1.0)
                    .opacity(showLevels ? 0 : 1)
                } else {
                    // Level Selection Buttons
                    VStack(spacing: 20) {
                        Text("Choose Your Level")
                            .font(.system(size: 28, weight: .semibold, design: .rounded))
                            .foregroundColor(.primary)
                            .opacity(showLevels ? 1 : 0)
                            .animation(.easeInOut(duration: 0.5).delay(0.2), value: showLevels)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 2), spacing: 20) {
                            ForEach(1...4, id: \.self) { level in
                                Button(action: {
                                    selectedLevel = level
                                    // Navigate to the selected level
                                    navigateToLevel(level)
                                }) {
                                    VStack {
                                        Text("\(level)")
                                            .font(.system(size: 36, weight: .bold, design: .rounded))
                                            .foregroundColor(.white)
                                        
                                        Text("Level \(level)")
                                            .font(.system(size: 14, weight: .medium, design: .rounded))
                                            .foregroundColor(.white.opacity(0.9))
                                    }
                                    .frame(width: 120, height: 120)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: levelColors(for: level)),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                                    )
                                }
                                .scaleEffect(showLevels ? 1.0 : 0.5)
                                .opacity(showLevels ? 1 : 0)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(level) * 0.1), value: showLevels)
                            }
                        }
                        .padding(.horizontal, 40)
                        
                        // Back Button
                        Button(action: {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                showLevels = false
                            }
                        }) {
                            Text("Back")
                                .font(.system(size: 18, weight: .medium, design: .rounded))
                                .foregroundColor(.primary)
                                .frame(width: 100, height: 40)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.white.opacity(0.2))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.primary.opacity(0.3), lineWidth: 1)
                                        )
                                )
                        }
                        .opacity(showLevels ? 1 : 0)
                        .animation(.easeInOut(duration: 0.5).delay(0.4), value: showLevels)
                    }
                }
            }
            .toolbar {
                if isInImmersiveSpace {
                    ToolbarItem(placement: placement) {
                        Button(action: {
                            Task {
                                await dismissImmersiveSpace()
                                isInImmersiveSpace = false
                            }
                        }) {
                            Label("Close", systemImage: "xmark.circle.fill")
                                .font(.title)
                                .padding()
                                .background(Color.red.opacity(0.8))
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                        }
                    }
                }
            }
        }
    }
    
    private func levelColors(for level: Int) -> [Color] {
        switch level {
        case 1:
            return [Color.green, Color.green.opacity(0.7)]
        case 2:
            return [Color.orange, Color.orange.opacity(0.7)]
        case 3:
            return [Color.red, Color.red.opacity(0.7)]
        case 4:
            return [Color.purple, Color.purple.opacity(0.7)]
        default:
            return [Color.blue, Color.blue.opacity(0.7)]
        }
    }
    
    private func navigateToLevel(_ level: Int) {
        // This function will handle navigation to the selected level
        // You can implement the navigation logic here based on your app structure
        print("Navigating to Level \(level)")
        
        // Example navigation (you'll need to implement this based on your app structure):
         switch level {
         case 1:
             openWindow(id: "Level1")

         case 2:
             Task {
                 await openImmersiveSpace(id: "Level2")
                 isInImmersiveSpace = true
             }
         case 3:
             print("3")
             // Navigate to Level3View
         case 4:
             print("4")
             // Navigate to Level4View
         default:
             break
         }
    }
    
    private var placement: ToolbarItemPlacement {
            #if os(visionOS)
            return .bottomOrnament
            #else
            return .primaryAction
            #endif
        }
}
