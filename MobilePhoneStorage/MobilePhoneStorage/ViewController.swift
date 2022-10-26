//
//  ViewController.swift
//  MobilePhoneStorage
//
//  Created by Philip on 10/26/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Creating models
        let storage = Storage(fileURL: fileURL("mobiles.json"))
        let mobile1 = Mobile(imei: "12341234", model: "Apple iPhone X")
        let mobile2 = Mobile(imei: "43215678", model: "Samsung A52")
        
        // Print URL path to storage file
        print("PATH: \(storage)")
        
        // Test func save(_ mobile: Mobile) throws -> Mobile
        do {
            let returnedMobile1 = try storage.save(mobile1)
            let returnedMobile2 = try storage.save(mobile2)
            print("====\nfunc save output\n \(returnedMobile1)\n \(returnedMobile2)\n====\n")
        } catch {
            print("some error in save")
        }
        
        // Test func delete(_ product: Mobile) throws
        try? storage.delete(mobile1)
        
        // Test func exists(_ product: Mobile) -> Bool
        let exists = storage.exists(mobile1)
        print("mobile with id \(mobile1.imei) exists? \(exists)")
        
        // Test func getAll() -> Set<Mobile>
        let getAll = storage.getAll()
        print("All elements in storage \(getAll)")
        
        // Test func findByImei(_ imei: String) -> Mobile?
        if let byImei = storage.findByImei("43215678") {
            print("founded element \(byImei)")
        } else {
            print("element with id 43215678 does not exist")
        }
        
    }

    func fileURL(_ fileName: String) -> URL {
      return FileManager.default
        .urls(for: .cachesDirectory, in: .allDomainsMask)
        .first!
        .appendingPathComponent(fileName)
    }

}

