//
//  Place.swift
//  SlowFood
//
//  Created by Luca Gramaglia on 09/06/21.
//

import Foundation

struct Place: Identifiable {
    let id: String
    let name: String
    let address: String
    let city: String
    let latitude: String?
    let longitude: String?
    let type: PlaceType?
    let phone: String
    var details: PlaceDetails?
}

enum PlaceType: Int, CaseIterable {
    case oil = 672
    case food = 670
    case shopping = 95
    case wine = 671
    
    var title: String {
        switch self {
        case .oil:
            return NSLocalizedString("Oil", comment: "")
        case .food:
            return NSLocalizedString("Osterie", comment: "")
        case .shopping:
            return NSLocalizedString("Negozi", comment: "")
        case .wine:
            return NSLocalizedString("Vino", comment: "")
        }
    }
    
    var colorName: String {
        switch self {
        case .oil:
            return "Oil"
        case .food:
            return "Food"
        case .shopping:
            return "Shopping"
        case .wine:
            return "Wine"
        }
    }
}

struct PlaceDetails {
    let fullName: String?
    let fullAddress: String?
    let phoneNumer: String?
    let rating: Float?
    let hours: String?
    let website: URL?
}
