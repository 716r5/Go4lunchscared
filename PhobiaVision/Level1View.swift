//
//  Level1View.swift
//  PhobiaVision
//
//  Created by Wei Song on 6/8/25.
//

import SwiftUI
struct Level1View: View {
    var body: some View {
        VStack {
            Text("Level 1 Exposure")
                .font(.title2)
                .padding(.bottom, 10)

            Image("spiderImage")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
                .padding()

            Text("Breathe. It's just an image.")
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(30)
        .shadow(radius: 10)
    }
}



#Preview {
    Level1View()
}
