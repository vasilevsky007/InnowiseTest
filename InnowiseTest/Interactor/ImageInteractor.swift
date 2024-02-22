//
//  ImageInteractor.swift
//  InnowiseTest
//
//  Created by Alex on 22.02.24.
//

import Foundation
import SwiftUI
import Combine

protocol ImageInteractor {
    func loadImageData(_ image: Binding<ImageData?>) async
    func clearImageCache()
}

struct RealImageInteractor: ImageInteractor {
    private var webRepository: ImageWebRepository
    private var coreDataRepository: ImageCoreDataRepository
    private var appState: AppState
    
    private var cancellables = Set<AnyCancellable>()
    
    init(webRepository: ImageWebRepository, coreDataRepositiry: ImageCoreDataRepository, appState: AppState) {
        self.webRepository = webRepository
        self.coreDataRepository = coreDataRepositiry
        self.appState = appState
        
        coreDataRepositiry.coreDataSize
            .sink { fileSize in
                Task{
                    await appState.changeImageCacheSize(fileSize)
                }
            }
            .store(in: &cancellables)
    }
    
    
    /// func for loading image data from its url. properly handles binded `ImageData` states, saves data to it
    /// - Parameter image: binding to `ImageData` struct
    func loadImageData(_ image: Binding<ImageData?>) async {
        guard image.wrappedValue !=  nil else { return }
        image.wrappedValue!.state = .loading
        do {
            guard let cachedData = try coreDataRepository.loadImage(withUrl: image.wrappedValue!.url) else { throw PersistenceErrors.noImageInContext }
            image.wrappedValue!.state = .loaded(imageData: cachedData)
        } catch {
            do {
                let fetchedData = try await webRepository.loadImageData(from: image.wrappedValue!.url)
                image.wrappedValue!.state = .loaded(imageData: fetchedData)
            } catch {
                image.wrappedValue!.state = .error(error: error)
            }
        }
    }
    /// clears persistant storage
    func clearImageCache() {
        do {
            try coreDataRepository.clearStorage()
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct FakeImageInteractor: ImageInteractor {
    func loadImageData(_ image: Binding<ImageData?>) async {
    }
    func clearImageCache() {
    }
}
