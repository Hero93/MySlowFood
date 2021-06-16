//
//  PlaceDetailsLoader.swift
//  SlowFood
//
//  Created by Luca Gramaglia on 11/06/21.
//

import Foundation

protocol PlaceDetailsLoader {
    func getDetails(of: Place, completion: @escaping ((_ place: Result<PlaceDetails, Error>) -> Void))
}
