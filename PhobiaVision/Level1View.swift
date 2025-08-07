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
            
            Text("Welcome to your first challenge.\nYou’ll be surrounded by five static images of spiders — gentle, real-world photos.\n\nTake a deep breath.\nYou're safe here. You're in control.\n\nWhen you're ready, flip each card to reveal the spider underneath.\nYou don’t have to rush — go at your own pace.\n\nYou’ve already taken a brave step just by being here.\nFlip all five cards to move on to the next round.")
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
            .padding(16)
            .background(Color.pink)
            .foregroundColor(.white)
            .cornerRadius(20)
        }
        .padding()
        // Initial window size
        .frame(width: 800, height: 500)
    }
}


#Preview {
    Level1View()
}
