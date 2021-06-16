//
//  PlaceDetailsViewModel.swift
//  SlowFood
//
//  Created by Luca Gramaglia on 13/06/21.
//

import UIKit

class PlaceDetailsViewModel {

    private let place: Place
    private let placeDetails: PlaceDetails
    
    init(place: Place, placeDetails: PlaceDetails) {
        self.place = place
        self.placeDetails = placeDetails
    }
}

extension PlaceDetailsViewModel {
 
    var title: String {
        return place.name
    }
    
    var name: String? {
        return placeDetails.fullName
    }
    
    var address: String? {
        return placeDetails.fullAddress
    }
    
    var rating: String? {
        guard let rating = placeDetails.rating else { return nil }
        return "Rating: \(rating)"
    }
    
    var phone: String? {
        return place.phone
    }
    
    var website: String? {
        guard let webSite = placeDetails.website else { return nil }
        return "\(webSite)"
    }
}
