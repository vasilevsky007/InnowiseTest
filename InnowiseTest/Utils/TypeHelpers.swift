//
//  PokemonTypesVisulization.swift
//  InnowiseTest
//
//  Created by Alex on 20.02.24.
//

import SwiftUI

extension Pokemon.Details.Types {
    /// color representing this type. taken from bulbapedia
    var color: Color {
        Color(Strings.Sources.colorPath + self.rawValue)
    }
}
extension Pokemon.Details.Types {
    /// image representing this type. taken from bulbapedia
    var image: Image {
        Image(Strings.Sources.imagePath + self.rawValue)
    }
}

extension Pokemon.Details.PokemonWeight {
    //regretfully, this will be showing on any int...
    var kg: String {
        "\((Double(self) / 10))"
    }
}
extension Pokemon.Details.PokemonHeight {
    //regretfully, this will be showing on any int...
    var cm: String {
        "\(self * 10)"
    }
}

extension Int64 {
    /// textual representation of given number of bytes
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
    /// size of this class in memory
    ///  - Important: update this func if adding new properties to corresponding core data entity
    var size: Int64 {
        var size: Int64 = 0
        size += Int64(MemoryLayout.size(ofValue: self))
        size += Int64(MemoryLayout.size(ofValue: self.name))
        size += Int64(MemoryLayout.size(ofValue: self.url))
        size += Int64(self.details?.count ?? 0)
        return size
    }
}

extension ImageEntity {
    /// size of this class in memory
    ///  - Important: update this func if adding new properties to corresponding core data entity
    var size: Int64 {
        var size: Int64 = 0
        size += Int64(MemoryLayout.size(ofValue: self))
        size += Int64(MemoryLayout.size(ofValue: self.timestamp))
        size += Int64(MemoryLayout.size(ofValue: self.url))
        size += Int64(self.data?.count ?? 0)
        return size
    }
}
