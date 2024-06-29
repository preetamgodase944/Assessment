//
//  DialogView.swift
//  ImageGallery
//
//  Created by Manish T on 29/06/24.
//

import UIKit

protocol DialogDelegate {
    func didTapCloseButton()
}

class DialogView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var contentImage: UIImageView!
    
    var delegate: DialogDelegate?
    
    func configureUI(for model: PhotoModel) {
        titleLabel.text = model.author
        descriptionLabel.text = model.url
        contentImage.image = nil
        NetworkManager.shared.getImage(for: model, completion: { [weak self] image in
            self?.contentImage.image = image
        })
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        delegate?.didTapCloseButton()
    }
}
