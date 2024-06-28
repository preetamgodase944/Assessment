//
//  PhotoModel.swift
//  ImageGallery
//
//  Created by Manish T on 28/06/24.
//

import Foundation

struct PhotoModel: Codable {
    let id: String
    let author: String
    let url: String
    let downloadUrl: String

    enum CodingKeys: String, CodingKey {
        case id
        case author
        case url
        case downloadUrl = "download_url"
    }
}
