//
//  Level1View.swift
//  PhobiaVision
//
//  Created by Wei Song on 6/8/25.
//

import SwiftUI

struct Level1View: View {
    @State private var flipped = false

    let imageName = "spider1"
    let message = "Breathe. It's just an image."

    var body: some View {
        ZStack {
            if flipped {
                // Front: spider image + message
                VStack(spacing: 20) {
                    Text("Level 1 Exposure")
                        .font(.title2)

                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .cornerRadius(20)
                        .shadow(radius: 10)

                    Text(message)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(width: 400, height: 500)
                .background(Color.white)
                .cornerRadius(30)
                .rotation3DEffect(.degrees(0), axis: (x: 0, y: 1, z: 0))
            } else {
                // Back: calm message only
                VStack {
                    Text("Flip when you're ready")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .frame(width: 400, height: 500)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(30)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            }
        }
        .rotation3DEffect(.degrees(flipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.6)) {
                flipped.toggle()
            }
        }
    }
}

#Preview {
    Level1View()
}
