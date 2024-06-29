//
//  ListingViewModel.swift
//  ImageGallery
//
//  Created by Manish T on 29/06/24.
//

import Foundation

protocol ListingIntputViewModel {
    func fetchImages()
}

protocol ListingOutputViewModel {
    var reloadTableView : () -> Void { get set }
    func isListEmpty() -> Bool
    func getNumberOfImages() -> Int
    func getPhotoModel(for index: Int) -> PhotoModel?
}

protocol ListingViewModelType {
    var inputs: ListingIntputViewModel { get }
    var outputs: ListingOutputViewModel { get }
}

class ListingViewModel: ListingViewModelType {
    var inputs: ListingIntputViewModel { return self }
    var outputs: ListingOutputViewModel { return self }
    
    var photosData: [PhotoModel]?
    
    var reloadTableView: () -> Void = { }
}

extension ListingViewModel: ListingIntputViewModel {
    func fetchImages() {
        NetworkManager.shared.fetchPhotoListData { [weak self] photosModel in
            self?.photosData = photosModel
            self?.reloadTableView()
        }
    }
}

extension ListingViewModel: ListingOutputViewModel {
    func isListEmpty() -> Bool {
        photosData?.isEmpty ?? true
    }
    
    func getNumberOfImages() -> Int {
        photosData?.count ?? 0
    }
    
    func getPhotoModel(for index: Int) -> PhotoModel? {
        photosData?[index]
    }
    
    
}
