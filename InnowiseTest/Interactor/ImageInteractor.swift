//
//  ImageInteractor.swift
//  InnowiseTest
//
//  Created by Alex on 22.02.24.
//

import Foundation
import SwiftUI
import Combine

///Interactors should be “facaded” with a protocol so that the View could talk to a mocked Interactor in tests.
protocol ImageInteractor {
    
    /// func for loading image data from its url. properly handles binded `ImageData` states, saves data to it
    /// - Parameter image: binding to `ImageData` struct
    func loadImageData(_ image: Binding<ImageData?>) async
    
    /// clears persistant storage
    func clearImageCache()
}

///Interactors receive requests to perform work, such as obtaining data from an external source or making computations, but they never return data back directly, such as in a closure.
///Instead, they forward the result to the AppState or a Binding provided by the View.
///The Binding is used when the result of work (the data) is owned locally by one View and does not belong to the central AppState, that is, it doesn’t need to be persisted or shared with other screens of the app.
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
                try coreDataRepository.saveImage(image.wrappedValue!)
            } catch {
                image.wrappedValue!.state = .error(error: error)
            }
        }
    }
    
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
