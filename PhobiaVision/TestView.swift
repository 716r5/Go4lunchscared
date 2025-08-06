//
//  TestView.swift
//  PhobiaVision
//
//  Created by Wei Song on 6/8/25.
//

import SwiftUI

struct TestView: View {
    var body: some View {
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
}

#Preview {
    TestView()
}
