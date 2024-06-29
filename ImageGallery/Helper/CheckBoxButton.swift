//
//  CheckBoxButton.swift
//  ImageGallery
//
//  Created by Manish T on 29/06/24.
//

import UIKit

class CheckBoxButton: UIButton {
    
    func updateButtonState() {
        let imageName: Constants.ButtonImageName = isSelected ? .selected : .unselected
        setImage(UIImage(systemName: imageName.rawValue), for: .normal)
    }
}
