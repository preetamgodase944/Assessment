//
//  ListRowCell.swift
//  ImageGallery
//
//  Created by Manish T on 28/06/24.
//

import UIKit

protocol RowSelection {
    func didToggleRowSelection(_ newValue: Bool, at index: Int)
}

class ListRowCell: UITableViewCell {
    
    static let reusedentifier = "ListRowCell"
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var imageContent: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var checkBox: CheckBoxButton!
    
    var delegate: RowSelection?
    
    var isRowEnabled = false {
        didSet {
            checkBox.isSelected = isRowEnabled
            checkBox.updateButtonState()
        }
    }
    
    override func prepareForReuse() {
        authorLabel.text = ""
        imageContent.image = nil
        descriptionLabel.text = nil
    }
    
    @IBAction func checkBoxToggled(_ sender: CheckBoxButton) {
        isRowEnabled.toggle()
        delegate?.didToggleRowSelection(isRowEnabled, at: tag)
    }
    
    func configureCell(for model: PhotoModel, isEnabled: Bool, delegate: RowSelection) {
        self.delegate = delegate
        isRowEnabled = isEnabled
        authorLabel.text = model.author
        descriptionLabel.text = model.url 
        NetworkManager.shared.getImage(for: model, completion: { [ weak self ] image in
            self?.imageContent.image = image
        })
    }
}
