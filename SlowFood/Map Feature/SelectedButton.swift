//
//  SelectedButton.swift
//  SlowFood
//
//  Created by Luca Gramaglia on 12/06/21.
//

import UIKit

class SelectedButton: UIButton {
    var selectedBackgroundColor: UIColor = .clear
    var notSelectedBackgroundColor: UIColor = .lightGray

    override open var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? selectedBackgroundColor : notSelectedBackgroundColor
        }
    }
}
