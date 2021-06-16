//
//  MapViewController.swift
//  SlowFood
//
//  Created by Luca Gramaglia on 09/06/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK: - Properties
    
    private static let italy = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 41.763858, longitude: 12.878297),
                                                  span: MKCoordinateSpan(latitudeDelta: 16.5, longitudeDelta: 13.0))
    
    private let mapView: MKMapView = {
       let mapView = MKMapView()
        mapView.setRegion(italy, animated: true)
        return mapView
    }()
    private let searchBar = UISearchBar()
    private var filterButtonsStackView = UIStackView()
    
    private var viewModel: PlacesMapViewModel?
    
    private let placeLoader: PlacesLoader
        
    // MARK: - Inits
    
    init(placeLoader: PlacesLoader) {
        self.placeLoader = placeLoader
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getData()
        
        initMapView()
        initSearchBar()
        initFilterButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
}

// MARK: - View init

extension MapViewController {
    
    private func initMapView() {
        self.view.addSubview(mapView)
        mapView.delegate = self
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    private func initSearchBar() {
        self.view.addSubview(searchBar)
        
        searchBar.placeholder = "Inserisci la località"
        searchBar.delegate = self
        
        searchBar.backgroundColor = .clear
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor).isActive = true
    }
    
    private func initFilterButtons() {
        var filterButtons = [UIButton]()

        PlaceType.allCases.forEach { placeType in
            let filterButton = SelectedButton()
            filterButton.selectedBackgroundColor = UIColor(named: placeType.colorName) ?? .lightGray
            filterButton.tag = placeType.rawValue
            filterButton.setTitle(placeType.title, for: .normal)
            filterButton.setTitleColor(.black, for: .normal)
            filterButton.isSelected = true
            filterButtons.append(filterButton)
        }
        
        filterButtonsStackView = UIStackView(arrangedSubviews: filterButtons)
        filterButtonsStackView.distribution = .fillEqually
        filterButtonsStackView.axis = .horizontal
        filterButtonsStackView.backgroundColor = .brown
        
        filterButtons.forEach { filterButton in
            filterButton.addTarget(self, action: #selector(filterButtonTouchUpInside), for: .touchUpInside)
        }
        
        self.view.addSubview(filterButtonsStackView)
        
        filterButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        filterButtonsStackView.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor).isActive = true
        filterButtonsStackView.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor).isActive = true
        filterButtonsStackView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -32).isActive = true
    }
    
}

// MARK: - Data

extension MapViewController {
    
    private func getData() {
        placeLoader.getAll { result in
            switch result {
            case .success(let places):
                viewModel = PlacesMapViewModel(places: places)
                createAnnotations(of: places)
            case .failure(let error):
                print("error: \(error)")
            }
        }
    }
}

// MARK: - Map Annotations

extension MapViewController {
    
    private func createAnnotations(of places: [Place]) {
        places.forEach {
            createAnnotation(of: $0)
        }
    }

    private func createAnnotation(of place: Place) {
        guard let latitude = place.latitude,
              let latitudeDouble = Double(latitude),
              let longitude = place.longitude,
              let longitudeDouble = Double(longitude) else { return }
        let placeAnnotation = PlaceAnnotation(latitudeDouble, longitudeDouble, place: place)
        mapView.addAnnotation(placeAnnotation)
    }
    
    private func updateAnnotations() {
        guard let placesToDisplay = viewModel?.placesToDisplay else { return }
        self.mapView.removeAnnotations(self.mapView.annotations)
        createAnnotations(of: placesToDisplay)
    }
}


// MARK: - Action(s)

extension MapViewController {

    @objc private func filterButtonTouchUpInside(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        guard let placeType = PlaceType(rawValue: sender.tag) else {
            return
        }
        if sender.isSelected {
            viewModel?.showPlaces(of: placeType)
        } else {
            viewModel?.hidePlaces(of: placeType)
        }
        updateAnnotations()
    }
}

// MARK: - MKMapViewDelegate
 
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print(mapView.region)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        guard let annotation = annotation as? PlaceAnnotation else {return nil}
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        if let placeColorName = annotation.place.type?.colorName {
            annotationView?.markerTintColor = UIColor(named: placeColorName) ?? .lightGray
        }
//        annotationView?.glyphImage = UIImage(named: "pizza")
//        annotationView?.glyphTintColor = .yellow
//        annotationView?.clusteringIdentifier = identifier
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let placeAnnotation = (view.annotation as? PlaceAnnotation) else { return }
        openDetailsView(of: placeAnnotation.place)
    }
    
    private func openDetailsView(of place: Place) {
        // TODO: show details + open search result on Google Search
        let placeDetailsVC = PlaceDetailsViewController(place: place, placeDetailsLoader: GoogleMapsPlaceDetailsLoader())
        self.navigationController?.pushViewController(placeDetailsVC, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension MapViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let placeToSearch = searchBar.text else { return }
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(placeToSearch) { [weak self] (placemarks, error) in
            guard let placemark = placemarks?.first,
                  let placeCoordinates = placemark.location?.coordinate else { return }
            let region = MKCoordinateRegion(center: placeCoordinates,
                                            span: MKCoordinateSpan(latitudeDelta: 0.10, longitudeDelta: 0.10))
            self?.mapView.setRegion(region, animated: true)
        }
    }
}
