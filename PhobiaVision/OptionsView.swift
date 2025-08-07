//
//  OptionsView.swift
//  PhobiaVision
//
//  Created by Wei Song on 6/8/25.
//

import SwiftUI

struct OptionsView: View {
    @Binding var options: OptionsStruct
    
    var body: some View {
        VStack {
            Slider(
                value: $options.amountOfSpiders,
                in: 1...100,
                step: 1
            )
            .frame(width: 200)
            
            Text("Number of \(options.animal): \(Int(options.amountOfSpiders))")

            Text("")
                .padding()
            
            Slider(
                value: $options.scaling,
                in: 10...100,
                step: 1
            )
            .frame(width: 200)
            
            Text("Size of \(options.animal): \(Int(options.scaling))%")
            
            Text("")
                .padding()
            
            Text("Choose Animal")
            HStack {
                Button(action: {
                    options.animal = "Spider"
                }) {
                    Text("Spider")
                }
                .frame(width: 100, height: 100)
                .background(.red)
                .cornerRadius(20)
                .buttonStyle(PlainButtonStyle())
                
                
                Button(action: {
                    options.animal = "Cockroach"
                }) {
                    Text("Cockroach")
                }
                .frame(width: 100, height: 100)
                .background(.blue)
                .cornerRadius(20)
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    options.animal = "Lizard"
                }) {
                    Text("Lizard")
                }
                .frame(width: 100, height: 100)
                .background(.mint)
                .cornerRadius(20)
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    options.animal = "Snake"
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
    @Previewable @State var options: OptionsStruct = .init()
    OptionsView(options: $options)
}
