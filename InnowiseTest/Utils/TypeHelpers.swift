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

extension Int64 {
    var formattedFileSize: String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useGB, .useMB, .useKB, .useBytes]
        formatter.countStyle = .file
        formatter.allowsNonnumericFormatting = true
        formatter.isAdaptive = false
        formatter.includesUnit = true
        return formatter.string(fromByteCount: self)
    }
}

extension PokemonEntity {
    var size: Int64 {
        var size: Int64 = 0
        size += Int64(MemoryLayout.size(ofValue: self))
        size += Int64(MemoryLayout.size(ofValue: self.name))
        size += Int64(MemoryLayout.size(ofValue: self.url))
        size += Int64(self.details?.count ?? 0)
        return size
    }
}
