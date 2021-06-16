//
//  PlaceAnnotation.swift
//  SlowFood
//
//  Created by Luca Gramaglia on 12/06/21.
//

import MapKit

class PlaceAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var place: Place
    var subtitle: String?
    
    init(_ latitude: CLLocationDegrees, _ longitude:CLLocationDegrees, place: Place) {
        self.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        self.subtitle = place.name
        self.place = place
    }
}
