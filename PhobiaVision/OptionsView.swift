//
//  OptionsView.swift
//  PhobiaVision
//
//  Created by Wei Song on 6/8/25.
//

import SwiftUI

struct OptionsView: View {
    @State var amountOfSpiders: Double = 30
    @State var scaling: Double = 50
    @State var animal = "Spider"
    
    var body: some View {
        VStack {
            Slider(
                value: $amountOfSpiders,
                in: 1...100,
                step: 1
            )
            .frame(width: 200)
            
            Text("Number of \(animal): \(Int(amountOfSpiders))")

            Text("")
                .padding()
            
            Slider(
                value: $scaling,
                in: 1...100,
                step: 1
            )
            .frame(width: 200)
            
            Text("Size of \(animal): \(Int(scaling))%")
            
            Text("")
                .padding()
            
            Text("Choose Animal")
            HStack {
                Button(action: {
                    animal = "Spider"
                }) {
                    Text("Spider")
                }
                .frame(width: 100, height: 100)
                .background(.red)
                .cornerRadius(20)
                .buttonStyle(PlainButtonStyle())
                
                
                Button(action: {
                    animal = "Cockroach"
                }) {
                    Text("Cockroach")
                }
                .frame(width: 100, height: 100)
                .background(.blue)
                .cornerRadius(20)
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    animal = "Lizard"
                }) {
                    Text("Lizard")
                }
                .frame(width: 100, height: 100)
                .background(.mint)
                .cornerRadius(20)
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    animal = "Snake"
                }) {
                    Text("Snake")
                }
                .frame(width: 100, height: 100)
                .background(.orange)
                .cornerRadius(20)
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    OptionsView()
}
