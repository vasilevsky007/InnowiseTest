//
//  PokemonTypeBadge.swift
//  InnowiseTest
//
//  Created by Alex on 20.02.24.
//

import SwiftUI

/// subview for visual representation of specific pokemon type
struct PokemonTypeBadge: View {
    /// a type to display
    let type: Pokemon.Details.Types
    
    var body: some View {
        HStack(alignment: .center) {
            type.image
                .padding(.all, DrawingConstants.smallSpacing)
                .background(type.color, in: .rect)
            Spacer(minLength: 0)
            Text(type.rawValue.localizedCapitalized)
                .fixedSize(horizontal: true, vertical: false)
            Spacer(minLength: 0)
        }
        .padding(.trailing, DrawingConstants.smallSpacing)
        .frame(maxWidth: .infinity)
        .clipShape(.rect(
            cornerRadius: DrawingConstants.smallCorners,
            style: .continuous
        ))
        .overlay(
            type.color,
            in: .rect(
                cornerRadius: DrawingConstants.smallCorners,
                style: .continuous)
            .stroke()
        )
    }
}

#Preview {
    PokemonTypeBadge(type: .electric)
        .frame(width: 100)
}
