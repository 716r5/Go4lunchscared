//
//  SpiderCardView.swift
//  PhobiaVision
//
//  Created by Saumil Anand on 7/8/25.
//


import SwiftUI

struct SpiderCardView: View {
    let imageName: String //eg spider1
    let message: String //encoruagign msg

    @State private var flipped = false

    var body: some View {
//        ZStack {
//            if flipped {
                // Front: spider image + msg
                VStack(spacing: 20) {
                    Text("Exposure")
                        .font(.title)

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
                .frame(width: 400, height: 500)
//                .background(Color.white)
                .cornerRadius(30)
                .rotation3DEffect(.degrees(0), axis: (x: 0, y: 1, z: 0))
//            } else {
//                // Back: generic card initial view
//                VStack {
//                    Text("Flip when you're ready")
//                        .font(.headline)
//                        .padding()
//                }
//                .frame(width: 400, height: 500)
//                .background(Color.gray.opacity(0.2))
//                .cornerRadius(30)
//                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
//            }
//        }
        
        // flip animation (rotation3DEffect(_:axis:anchor:anchorZ:perspective:) -> render content view
//        .rotation3DEffect(.degrees(flipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
//        .onTapGesture {
//            withAnimation(.easeInOut(duration: 0.6)) {
//                flipped.toggle()
//            }
//        }
    }
}
