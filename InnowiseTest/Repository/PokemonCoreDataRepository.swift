//
//  PokemonCoreDataRepository.swift
//  InnowiseTest
//
//  Created by Alex on 21.02.24.
//

import Foundation
import CoreData
import Combine

/// "facade" protocol for Core Data repository to ensure testability.
/// you can create your own struct conforming to this protocol suitable for your unit tests
protocol PokemonCoreDataRepository {
    var coreDataSize: AnyPublisher<Int64?, Never> { get }
    func loadPokemons(fromOffset offset: Int, limit: Int) throws -> (pokemons:[Pokemon], availibleCount: Int)
    func savePokemons(_ pokemons: [Pokemon], fromOffset offset: Int,  availibleCount: Int) throws
    func updatePokemon(_ pokemon: Pokemon, updatedDetails: Pokemon.Details) throws
    func clearStorage() throws
}

/// real core data repository, for storing pokemons. should be used inside the app
struct RealPokemonCoreDataRepository: PokemonCoreDataRepository {
    private let context: NSManagedObjectContext
    
    private let coreDataSizeSubject = CurrentValueSubject<Int64?, Never>(nil)
    
    var coreDataSize: AnyPublisher<Int64?, Never> {
        return coreDataSizeSubject.eraseToAnyPublisher()
    }
    
    /// main initializer
    /// - Parameter context: Core Data context to save pokemons
    init(context: NSManagedObjectContext) {
        self.context = context
        //FIXME: sadly not working. using defer on each changing CD function to ensure updateCoreDataFileSize() call
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSPersistentStoreCoordinatorStoresDidChange, object: context.persistentStoreCoordinator, queue: nil) {[updateCoreDataFileSize] _ in
            updateCoreDataFileSize()
        }
    }
    
    func loadPokemons(fromOffset offset: Int, limit: Int) throws -> (pokemons:[Pokemon], availibleCount: Int) {
        defer {
            updateCoreDataFileSize()
        }
        let countRequest: NSFetchRequest<AvailibleCount> = AvailibleCount.fetchRequest()
        
        let request: NSFetchRequest<PokemonEntity> = PokemonEntity.fetchRequest()
        let indexSortDescriptor = NSSortDescriptor(keyPath: \PokemonEntity.index, ascending: true)
        request.sortDescriptors = [indexSortDescriptor]
        request.fetchOffset = offset
        request.fetchLimit = limit
        
        let pokemonEntities = try context.fetch(request)
        let countEntities = try context.fetch(countRequest)
        
        let pokemons = pokemonEntities.map { pokemonEntity in
            var details: Pokemon.Details? = nil
            if let detailsData = pokemonEntity.details {
                details = try? JSONDecoder().decode(Pokemon.Details.self, from: detailsData)
            }
            return Pokemon(//FIXME: даже при том что я в модели указал эти поля как НЕ опциональные, все равно в коде они опцинальные
                name: pokemonEntity.name!,
                url: pokemonEntity.url!,
                details: details)
        }
        let count = Int(countEntities.first?.count ?? 0)
        return (pokemons, count)
    }
    
    func savePokemons(_ pokemons: [Pokemon], fromOffset offset: Int, availibleCount: Int) throws {
        defer {
            updateCoreDataFileSize()
        }
        
        let pokemonRequest: NSFetchRequest<PokemonEntity> = PokemonEntity.fetchRequest()
        let indexSortDescriptor = NSSortDescriptor(keyPath: \PokemonEntity.index, ascending: true)
        pokemonRequest.sortDescriptors = [indexSortDescriptor]
        pokemonRequest.fetchOffset = offset
        pokemonRequest.fetchLimit = pokemons.count
        
        let countRequest: NSFetchRequest<AvailibleCount> = AvailibleCount.fetchRequest()
        
        let countEntities = try? context.fetch(countRequest)
        let pokemonEntities = try? context.fetch(pokemonRequest)
        
        if pokemonEntities?.count ?? 0 < pokemons.count {
            if let count  = countEntities?.first {
                count.count = Int64(availibleCount)
            } else {
                let countEntity = AvailibleCount(context: context)
                countEntity.count = Int64(availibleCount)
            }
            
            pokemons.forEach { pokemon in
                let pokemonEntity = PokemonEntity(context: context)
                pokemonEntity.name = pokemon.name
                pokemonEntity.url = pokemon.url
                pokemonEntity.index = Int32(pokemon.url.lastPathComponent) ?? 0
                if let details = pokemon.details {
                    let detailsEncoded = try? JSONEncoder().encode(details)
                    pokemonEntity.details = detailsEncoded
                } else {
                    pokemonEntity.details = nil
                }
            }
            try context.save()
        }
    }
    
    func updatePokemon(_ pokemon: Pokemon, updatedDetails: Pokemon.Details) throws {
        defer {
            updateCoreDataFileSize()
        }
        
        let request: NSFetchRequest<PokemonEntity> = PokemonEntity.fetchRequest()
        request.predicate = NSPredicate(format: "url == %@", pokemon.url as CVarArg)
        
        let fetchedPokemons = try context.fetch(request)
        guard let pokemonEntity = fetchedPokemons.first else {
            throw PersistenceErrors.NoUpdatingPokemonInContext
        }
        
        let detailsEncoded = try? JSONEncoder().encode(updatedDetails)
        pokemonEntity.details = detailsEncoded
        
        try context.save()
    }
    
    func clearStorage() throws {
        defer {
            updateCoreDataFileSize()
        }
        
        let pokemonRequest: NSFetchRequest<PokemonEntity> = PokemonEntity.fetchRequest()
        let countRequest: NSFetchRequest<AvailibleCount> = AvailibleCount.fetchRequest()
        //dont know why its not automatically downcasting here
        let pokemonDeleteRequest = NSBatchDeleteRequest(fetchRequest: pokemonRequest as! NSFetchRequest<any NSFetchRequestResult>)
        let countDeleteRequest = NSBatchDeleteRequest(fetchRequest: countRequest as! NSFetchRequest<any NSFetchRequestResult>)
        
        try context.execute(pokemonDeleteRequest)
        try context.execute(countDeleteRequest)
        try context.save()
    }
    
    private func updateCoreDataFileSize() {
        var size: Int64 = 0
        let request: NSFetchRequest<PokemonEntity> = PokemonEntity.fetchRequest()
        do {
            let pokemonEntities = try context.fetch(request)
            for entity in pokemonEntities {
                size += entity.size
            }
        } catch {
            coreDataSizeSubject.send(nil)
        }
        coreDataSizeSubject.send(size)
    }
}

struct FakePokemonCoreDataRepository: PokemonCoreDataRepository {
    var coreDataSize: AnyPublisher<Int64?, Never> = Empty().eraseToAnyPublisher()
    
    func loadPokemons(fromOffset offset: Int, limit: Int) throws -> (pokemons:[Pokemon], availibleCount: Int) {
        return ([], 1)
    }
    func savePokemons(_ pokemons: [Pokemon], fromOffset offset: Int,  availibleCount: Int) throws {
        
    }
    func updatePokemon(_ pokemon: Pokemon, updatedDetails: Pokemon.Details) throws {
        
    }
    func clearStorage() throws {
        
    }
}
