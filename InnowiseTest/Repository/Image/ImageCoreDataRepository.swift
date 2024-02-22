//
//  ImageCoreDataRepository.swift
//  InnowiseTest
//
//  Created by Alex on 22.02.24.
//

import Foundation
import CoreData
import Combine

/// "facade" protocol for Core Data repository to ensure testability.
/// you can create your own struct conforming to this protocol suitable for your unit tests
protocol ImageCoreDataRepository {
    var coreDataSize: AnyPublisher<Int64?, Never> { get }
    func loadImage(withUrl url: URL) throws -> Data?
    func saveImage(_ image: ImageData) throws
    func clearStorage() throws
}

/// real core data repository, for storing Images. should be used inside the app
struct RealImageCoreDataRepository: ImageCoreDataRepository {
    private let context: NSManagedObjectContext
    
    private let coreDataSizeSubject = CurrentValueSubject<Int64?, Never>(nil)
    
    var coreDataSize: AnyPublisher<Int64?, Never> {
        return coreDataSizeSubject.eraseToAnyPublisher()
    }
    
    /// main initializer
    /// - Parameter context: Core Data context to save Images
    init(context: NSManagedObjectContext) {
        self.context = context
        //FIXME: sadly not working. using defer on each changing CD function to ensure updateCoreDataFileSize() call
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSPersistentStoreCoordinatorStoresDidChange, object: context.persistentStoreCoordinator, queue: nil) {[updateCoreDataSize] _ in
            updateCoreDataSize()
        }
    }
    
    func loadImage(withUrl url: URL) throws -> Data? {
        defer {
            updateCoreDataSize()
        }
        let request: NSFetchRequest<ImageEntity> = ImageEntity.fetchRequest()
        request.predicate = NSPredicate(format: "url == %@", url as CVarArg)
        
        let imageEntities = try context.fetch(request)
        
        let data = imageEntities.first?.data
        return data
    }
    
    func saveImage(_ image: ImageData) throws {
        defer {
            updateCoreDataSize()
        }
        let imageEntity = ImageEntity(context: context)
        imageEntity.timestamp = Date.now
        imageEntity.url = image.url
        imageEntity.data = image.data
        try context.save()
    }
    
    func clearStorage() throws {
        defer {
            updateCoreDataSize()
        }
        
        let imageRequest: NSFetchRequest<ImageEntity> = ImageEntity.fetchRequest()
        //dont know why its not automatically downcasting here
        let imageDeleteRequest = NSBatchDeleteRequest(fetchRequest: imageRequest as! NSFetchRequest<any NSFetchRequestResult>)
        try context.execute(imageDeleteRequest)
        try context.save()
    }
    
    private func updateCoreDataSize() {
        var size: Int64 = 0
        let request: NSFetchRequest<ImageEntity> = ImageEntity.fetchRequest()
        do {
            let imageEntities = try context.fetch(request)
            for entity in imageEntities {
                size += entity.size
            }
        } catch {
            coreDataSizeSubject.send(nil)
        }
        coreDataSizeSubject.send(size)
    }
}

struct FakeImageCoreDataRepository: ImageCoreDataRepository {
    var coreDataSize: AnyPublisher<Int64?, Never> = Empty().eraseToAnyPublisher()
    func loadImage(withUrl url: URL) throws -> Data?{
        Data()
    }
    func saveImage(_: ImageData) throws {
    }
    func clearStorage() throws {
    }
}
