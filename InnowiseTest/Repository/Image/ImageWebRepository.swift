//
//  ImageWebRepository.swift
//  InnowiseTest
//
//  Created by Alex on 22.02.24.
//

import Foundation

protocol ImageWebRepository {
    func loadImageData(from url: URL) async throws -> Data
}


/// real web repository, for getting images. should be used inside the app
struct RealImageWebRepository: ImageWebRepository {
    let session = URLSession(configuration: .ephemeral)
    
    /// func for loading imagedata from the given url
    /// - Parameter url: url of data to fetch
    /// - Returns: data getted
    func loadImageData(from url: URL) async throws -> Data {
        let (receivedData, response) = try await session.data(from: url)
        return receivedData
    }
}
