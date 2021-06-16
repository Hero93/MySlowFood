//
//  MapViewModel.swift
//  SlowFood
//
//  Created by Luca Gramaglia on 12/06/21.
//

import Foundation

class PlacesMapViewModel {
    
    // MARK: - Properties
    
    private let places: [Place]
    private var placesTypeToDisplay = PlaceType.allCases
    
    var placesToDisplay = [Place]()
    
    // MARK: - Inits
    
    init(places: [Place]) {
        self.places = places
    }
}

// MARK: Markers Visibility

extension PlacesMapViewModel {
    
    func hidePlaces(of type: PlaceType) {
        guard let placeTypeToHideIndex = placesTypeToDisplay.firstIndex(of: type) else { return }
        placesTypeToDisplay.remove(at: placeTypeToHideIndex)
        updatePlaces()
    }
    
    func showPlaces(of type: PlaceType) {
        placesTypeToDisplay.append(type)
        updatePlaces()
    }
    
    private func updatePlaces() {
        placesToDisplay = places.compactMap { place -> Place? in
            guard let placeType = place.type else { return nil }
            return placesTypeToDisplay.contains(placeType) ? place : nil
        }
    }
}
