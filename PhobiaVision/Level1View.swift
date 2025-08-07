//
//  Level1View.swift
//  PhobiaVision
//
//  Created by Wei Song on 6/8/25.
//
import SwiftUI

struct Level1View: View {
    @Environment(\.openWindow) private var openWindow
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Level 1 Exposure")
                .font(.largeTitle)
                .bold()
            
            Text("Your exposure begins. The cards will appear in front of you.\nYou can move them around freely.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button("Begin Exposure") {
                // This will open 5 separate windows using your SpiderCardView
                openWindow(id: "Spider1")
                openWindow(id: "Spider2")
                openWindow(id: "Spider3")
                openWindow(id: "Spider4")
                openWindow(id: "Spider5")
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(20)
        }
        .padding()
        // Initial window size
        .frame(width: 500, height: 400)
    }
}


#Preview {
    Level1View()
}
