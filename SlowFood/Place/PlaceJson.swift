//
//  PlaceJson.swift
//  SlowFood
//
//  Created by Luca Gramaglia on 09/06/21.
//

import Foundation

struct PlaceJson: Decodable {
    let id: String
    let name: String
    let address: String
    let city: String
    let latitude: String?
    let longitude: String?
    let type: String
    let phone: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case address
        case city
        case latitude = "lat"
        case longitude = "lng"
        case type
        case phone
    }
}
