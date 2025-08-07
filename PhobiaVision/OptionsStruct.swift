//
//  OptionsStruct.swift
//  PhobiaVision
//
//  Created by Wei Song on 7/8/25.
//

struct OptionsStruct {
    var amountOfSpiders: Double
    var scaling: Double
    var animal: String
    
    init(amountOfSpiders: Double, scaling: Double, animal: String) {
        self.amountOfSpiders = amountOfSpiders
        self.scaling = scaling
        self.animal = animal
    }
    
    init() {
        self.amountOfSpiders = 30
        self.scaling = 50
        self.animal = "Cockroach"
    }
}
