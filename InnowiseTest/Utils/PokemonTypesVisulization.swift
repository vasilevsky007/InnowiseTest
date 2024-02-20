//
//  PokemonTypesVisulization.swift
//  InnowiseTest
//
//  Created by Alex on 20.02.24.
//

import SwiftUI

extension Pokemon.Details.Types {
    var color: Color {
        Color("Colors/" + self.rawValue)
    }
}
extension Pokemon.Details.Types {
    var image: Image {
        Image("Images/" + self.rawValue)
    }
}
