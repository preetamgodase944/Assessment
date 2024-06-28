//
//  ListRowCell.swift
//  ImageGallery
//
//  Created by Manish T on 28/06/24.
//

import UIKit

class ListRowCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageContent: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func configureCell(for model: PhotoModel) {
        
    }
}
