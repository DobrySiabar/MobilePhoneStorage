//
//  Storage.swift
//  MobilePhoneStorage
//
//  Created by Philip on 10/26/22.
//

import Foundation

protocol MobileStorage {
    func getAll() -> Set<Mobile>
    func findByImei(_ imei: String) -> Mobile?
    func save(_ mobile: Mobile) throws -> Mobile
    func delete(_ product: Mobile) throws
    func exists(_ product: Mobile) -> Bool
}

enum StorageErrors: Error {
    case EncodeError
    case SavingError
}

struct Storage: MobileStorage {
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let mobilesFileURL: URL
    
    init(fileURL: URL) {
        self.mobilesFileURL = fileURL
    }
    
    func getAll() -> Set<Mobile> {
        guard let mobilesData = try? Data(contentsOf: mobilesFileURL),
              let persistedMobiles = try? decoder.decode(Set<Mobile>.self, from: mobilesData)
        else { return Set<Mobile>() }
        return persistedMobiles
    }
    
    func findByImei(_ imei: String) -> Mobile? {
        getAll().first { $0.imei == imei }
    }
    
    func save(_ mobile: Mobile) throws -> Mobile {
        guard !exists(mobile) else { return mobile }
        
        var allMobiles = getAll()
        allMobiles.insert(mobile)
        guard let mobilesData = try? encoder.encode(allMobiles) else { throw StorageErrors.EncodeError }
        
        do {
            try mobilesData.write(to: mobilesFileURL, options: .atomicWrite)
            return mobile
        }
        catch {
            throw StorageErrors.SavingError
        }
    }
    
    func delete(_ product: Mobile) throws {
        var allMobiles = getAll()
        allMobiles.remove(product)
        guard let mobilesData = try? encoder.encode(allMobiles) else { throw StorageErrors.EncodeError }
        
        do {
            try mobilesData.write(to: mobilesFileURL, options: .atomicWrite)
        }
        catch {
            throw StorageErrors.SavingError
        }
    }
    
    func exists(_ product: Mobile) -> Bool {
        getAll().contains(product)
    }
    
}


