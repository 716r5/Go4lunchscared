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
    
    @Binding var options: OptionsStruct
    
    @State private var isInLevel1 = false
    @State private var isInLevel2 = false

    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
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

                if isInLevel1 {
                    // ================
                    // Screen for Level 1
                    // ================
                    VStack(spacing: 20) {
                        Text("Level 1")
                            .font(.title)
                        
                        Button(action: {
                            openWindow(id: "Level1")
                        }) {
                            Text("Add Spider Into View")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: 300)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.red)
                                        .shadow(radius: 5)
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button(action: {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                isInLevel1 = false
                                showLevels = true
                                dismissWindow(id: "Level1")
                            }
                        }) {
                            Text("Exit Level 1")
                                .font(.system(size: 18, weight: .medium, design: .rounded))
                                .foregroundColor(.primary)
                                .frame(width: 140, height: 40)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.white.opacity(0.2))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.primary.opacity(0.3), lineWidth: 1)
                                        )
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    
                    
                } else if isInLevel2 {
                    // ================
                    // Screen for Level 2
                    // ================
                    OptionsView(options: $options)
                    VStack(spacing: 20) {
                        Text("Level 2")
                            .font(.title)
                        
                        Button(action: {
                            if isInImmersiveSpace {
                                Task {
                                    await dismissImmersiveSpace()
                                    isInImmersiveSpace = false
                                }
                            } else {
                                Task {
                                    await openImmersiveSpace(id: "Level2")
                                    isInImmersiveSpace = true
                                }
                            }
                            
                        }) {
                            Text(isInImmersiveSpace ? "Stop" :"Start")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: 300)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.red)
                                        .shadow(radius: 5)
                                )
                        }
//                        .disabled(isInImmersiveSpace)
                        .buttonStyle(PlainButtonStyle())
                        
                        Button(action: {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                isInLevel2 = false
                                showLevels = true
                                
                                Task {
                                    await dismissImmersiveSpace()
                                    isInImmersiveSpace = false
                                }
                            }
                        }) {
                            Text("Exit Level 2")
                                .font(.system(size: 18, weight: .medium, design: .rounded))
                                .foregroundColor(.primary)
                                .frame(width: 140, height: 40)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.white.opacity(0.2))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.primary.opacity(0.3), lineWidth: 1)
                                        )
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    
                    
                } else if !showLevels {
                    
                    
                    
                    
                    // ================
                    // Starting Menu
                    // ================
                    Button(action: {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            showLevels = true
                        }
                    }) {
                        Text("START")
                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(width: 200, height: 60)
                            .bold()
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
                    .buttonStyle(PlainButtonStyle())
                } else {
                    
                    
                    
                    
                    
                    
                    // =======================
                    // Level Selection Menu
                    // =======================
                    VStack(spacing: 20) {
                        Text("Choose Your Level")
                            .font(.system(size: 28, weight: .semibold, design: .rounded))
                            .foregroundColor(.primary)
                            .opacity(showLevels ? 1 : 0)
                            .animation(.easeInOut(duration: 0.5).delay(0.2), value: showLevels)

                        LazyVGrid(columns: Array(repeating: GridItem(.fixed(120), spacing: 20), count: 2), spacing: 20) {
                            ForEach(1...4, id: \.self) { level in
                                Button(action: {
                                    selectedLevel = level
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
                                .buttonStyle(PlainButtonStyle())
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
                        .buttonStyle(PlainButtonStyle())
                        .animation(.easeInOut(duration: 0.5).delay(0.4), value: showLevels)
                    }
                }
            }
        }
        .frame(
            minWidth: 500, maxWidth: 750,
            minHeight: 500, maxHeight: 750
        )
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
        // Navigation logic based on selected level
        switch level {
        case 1:
            isInLevel1 = true
            showLevels = false
        case 2:
            isInLevel2 = true
            showLevels = false
        case 3:
            print("Navigating to Level 3")
            // Implement Level 3 navigation
        case 4:
            print("Navigating to Level 4")
            // Implement Level 4 navigation
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

#Preview {
    @Previewable @State var options: OptionsStruct = .init()
    ContentView(options: $options)
}
