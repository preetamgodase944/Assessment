//
//  ListRowCell.swift
//  ImageGallery
//
//  Created by Manish T on 28/06/24.
//

import UIKit

class ListRowCell: UITableViewCell {
    
    static let reusedentifier = "ListRowCell"
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var imageContent: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func prepareForReuse() {
        authorLabel.text = ""
        imageContent.image = nil
        descriptionLabel.text = nil
    }
    
    func configureCell(for model: PhotoModel) {
        authorLabel.text = model.author
        descriptionLabel.text = model.url 
        NetworkManager.shared.getImage(for: model, completion: { [ weak self ] image in
            self?.imageContent.image = image
        })
    }
}
