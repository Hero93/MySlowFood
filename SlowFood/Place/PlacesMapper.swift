//
//  PlacesMapper.swift
//  SlowFood
//
//  Created by Luca Gramaglia on 09/06/21.
//

import Foundation

enum RemoteError {
    case invalidData
}

class BundleJsonPlacesMapper {
    static func map(_ data: PlaceJson) -> Place {
        return Place(id: data.id,
                     name: data.name,
                     address: data.address,
                     city: data.city,
                     latitude: data.latitude,
                     longitude: data.longitude,
                     type: PlaceType(rawValue: Int(data.type) ?? -1),
                     phone: data.phone)
    }
}
