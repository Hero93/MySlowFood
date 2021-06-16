//
//  GoogleMapsPlaceDetails.swift
//  SlowFood
//
//  Created by Luca Gramaglia on 11/06/21.
//

import Foundation
import GooglePlaces

struct GoogleFindPlaceResponse: Codable {
    let candidates: [Candidate]?
    let status: String
}

// MARK: - Candidate
struct Candidate: Codable {
    let placeID: String

    enum CodingKeys: String, CodingKey {
        case placeID = "place_id"
    }
}

// MARK: - Geometry
struct Geometry: Codable {
    let location: Location
}

// MARK: - Location
struct Location: Codable {
    let lat, lng: Double
}

// MARK: - Photo
struct Photo: Codable {
    let height: Int
    let htmlAttributions: [String]
    let photoReference: String
    let width: Int

    enum CodingKeys: String, CodingKey {
        case height
        case htmlAttributions = "html_attributions"
        case photoReference = "photo_reference"
        case width
    }
}

enum CustomError: Error {
    case generic
}


class GoogleMapsPlaceDetailsLoader: PlaceDetailsLoader {
    
    private var placesClient: GMSPlacesClient!
    
    init() {
        placesClient = GMSPlacesClient.shared()
    }
    
    func getDetails(of place: Place, completion: @escaping ((Result<PlaceDetails, Error>) -> Void)) {
        guard let urlRequest = createUrlRequest(for: place) else { return }
        
        URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, urlResponse, error) in
            guard let data = data else { return }
            let response = try? JSONDecoder().decode(GoogleFindPlaceResponse.self, from: data)
            guard let placeID = response?.candidates?.map({ $0.placeID }).first else { return }
            
            self?.placesClient.fetchPlace(fromPlaceID: placeID,
                                          placeFields: [.name, .openingHours, .phoneNumber, .rating, .website, .formattedAddress],
                                          sessionToken: nil) { (gmPlace, error) in
                if let gmPlace = gmPlace {
                    let placeDetails = PlaceDetails(fullName: gmPlace.name,
                                                    fullAddress: gmPlace.formattedAddress,
                                                    phoneNumer: gmPlace.phoneNumber,
                                                    rating: gmPlace.rating,
                                                    hours: nil, website:
                                                        gmPlace.website)
                    completion(.success(placeDetails))
                } else if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(CustomError.generic))
                }
            }
        }.resume()
    }
    
}

// MARK: - Helpers

extension GoogleMapsPlaceDetailsLoader {
    
    private func createUrlRequest(for place: Place) -> URLRequest? {
        var urlComponents = URLComponents(string: "https://maps.googleapis.com/maps/api/place/findplacefromtext/json")!
        urlComponents.queryItems = [
            URLQueryItem(name: "input", value: "\(place.name) \(place.address)"),
            URLQueryItem(name: "inputtype", value: "textquery"),
            URLQueryItem(name: "fields", value: "name,rating,user_ratings_total,opening_hours,place_id"),
            URLQueryItem(name: "key", value: "AIzaSyDCBdVBbX_5Ldt-CJZ5QAKIiRNyd84yGmA")
        ]
        
        guard let url = urlComponents.url else { return nil }
        return URLRequest(url: url)
    }
}
