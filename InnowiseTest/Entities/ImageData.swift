//
//  ImageData.swift
//  InnowiseTest
//
//  Created by Alex on 22.02.24.
//

import Foundation

struct ImageData {
    enum State {
        case loading
        case error (error: Error)
        case loaded (imageData: Data)
    }
    let url: URL
    var state: State
    
    var data: Data? {
        switch self.state {
        case .loaded(let imageData):
            return imageData
        default:
            return nil
        }
    }
}


