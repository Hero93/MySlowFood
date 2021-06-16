//
//  BundleJsonPlaces+Helpers.swift
//  SlowFood
//
//  Created by Luca Gramaglia on 11/06/21.
//

import Foundation

class BundleJsonPlacesHelper {
    
    func getPath(for placeType: PlaceType) -> URL? {
        let bundle = Bundle(for: type(of: self))
        
        switch placeType {
        case .shopping:
            return bundle.url(forResource: "shops", withExtension: "json")!
        case .oil:
            return bundle.url(forResource: "oil", withExtension: "json")!
        case .food:
            return bundle.url(forResource: "osterie", withExtension: "json")!
        case .wine:
            return bundle.url(forResource: "wine", withExtension: "json")!
        }
    }
}
