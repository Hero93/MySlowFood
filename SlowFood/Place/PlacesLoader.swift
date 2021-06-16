//
//  PlaceLoader.swift
//  SlowFood
//
//  Created by Luca Gramaglia on 09/06/21.
//

import Foundation

protocol PlacesLoader {
    func getAll(completion: ((_ places: Result<[Place], Error>) -> Void))
}
