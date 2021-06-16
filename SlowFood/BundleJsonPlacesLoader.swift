//
//  JsonPlacesLoader.swift
//  SlowFood
//
//  Created by Luca Gramaglia on 09/06/21.
//

import Foundation

class BundleJsonPlacesLoader: PlacesLoader {
    enum CustomError: Error {
        case invalidData
        case noData
    }
    
    func getAll(completion: ((Result<[Place], Error>) -> Void)) {
        var allPlaces = [Place]()
        PlaceType.allCases.forEach { placeType in
            getPlace(for: placeType) { result in
                switch result {
                case .success(let places):
                    allPlaces.append(contentsOf: places)
                case .failure(let error):
                    print("error: \(error)")
                }
            }
        }
        if allPlaces.count > 0 {
            completion(.success(allPlaces))
        } else {
            completion(.failure(CustomError.noData))
        }
    }
    
    private func getPlace(for placeType: PlaceType, completion: ((Result<[Place], Error>) -> Void)) {
        let helper = BundleJsonPlacesHelper()
        
        guard let path = helper.getPath(for: placeType) else { return }
        
        do {
            let data = try Data(contentsOf: path)
            let placesJson = try JSONDecoder().decode([PlaceJson].self, from: data)
            completion(.success(placesJson.toModels()))
            
        } catch let error {
            print("json parsing error: \(error)")
            completion(.failure(CustomError.invalidData))
        }
    }
}

private extension Array where Element == PlaceJson {
    func toModels() -> [Place] {
        return map { data -> Place in
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
}
