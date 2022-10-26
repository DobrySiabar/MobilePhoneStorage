//
//  Mobile.swift
//  MobilePhoneStorage
//
//  Created by Philip on 10/26/22.
//

import Foundation

struct Mobile: Hashable {
    let imei: String
    let model: String
}

extension Mobile: Codable {}
