//
//  PlaceDetailsViewController.swift
//  SlowFood
//
//  Created by Luca Gramaglia on 13/06/21.
//

import UIKit

class PlaceDetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    private var containerStackView = UIStackView()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.numberOfLines = 0
        return label
    }()
    private let addressTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.font = .preferredFont(forTextStyle: .body)
        textView.dataDetectorTypes = [.address]
        return textView
    }()
    private let phoneTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.font = .preferredFont(forTextStyle: .body)
        textView.dataDetectorTypes = [.phoneNumber]
        return textView
    }()
    private let ratingLabel = UILabel()
    private let webSiteTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.font = .preferredFont(forTextStyle: .body)
        textView.dataDetectorTypes = [.link]
        return textView
    }()
    private lazy var openOnGoogleButton: UIButton = {
        let button = UIButton()
        if let colorName = place.type?.colorName {
            button.backgroundColor = UIColor(named: colorName)
        }
        button.setTitle("Apri ricerca su Google", for: .normal)
        button.addTarget(self, action: #selector(openGoogleButtonSearchTouchUpInside), for: .touchUpInside)
        return button
    }()
    
    private let placeDetailsLoader: PlaceDetailsLoader
    private let place: Place
    private var viewModel: PlaceDetailsViewModel?
    
    // MARK: - Inits
    
    init(place: Place, placeDetailsLoader: PlaceDetailsLoader) {
        self.placeDetailsLoader = placeDetailsLoader
        self.place = place
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        buildView()
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    private func buildView() {
        self.title = NSLocalizedString("detail", comment: "")

        containerStackView = UIStackView(arrangedSubviews: [nameLabel,
                                                            addressTextView,
                                                            phoneTextView,
                                                            ratingLabel,
                                                            webSiteTextView,
                                                            openOnGoogleButton])
        containerStackView.axis = .vertical
        containerStackView.distribution = .fillEqually
        containerStackView.spacing = 5
        
        view.addSubview(containerStackView)
        
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor).isActive = true
        containerStackView.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor).isActive = true
        containerStackView.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor).isActive = true
    }
}

extension PlaceDetailsViewController {
    
    private func getData() {
        placeDetailsLoader.getDetails(of: place) { [weak self] result in
            switch result {
            case .success(let placeDetails):
                guard let place = self?.place else { return }
                self?.viewModel = PlaceDetailsViewModel(place: place, placeDetails: placeDetails)
                self?.populateView()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func populateView() {
        nameLabel.text = viewModel?.name
        addressTextView.text = viewModel?.address
        ratingLabel.text = viewModel?.rating
        phoneTextView.text = viewModel?.phone
        webSiteTextView.text = viewModel?.website
    }
    
    private func helper(text: String) -> String {
        return text.replacingOccurrences(of: " ", with: "+")
    }
}

extension PlaceDetailsViewController {
    
    @objc func openGoogleButtonSearchTouchUpInside() {
        let formattedSearchText = helper(text: "\(place.name) \(place.address)")
        UIApplication.shared.open(URL(string: "http://www.google.com/search?q=\(formattedSearchText)")!, options: [:], completionHandler: nil)
    }
}
