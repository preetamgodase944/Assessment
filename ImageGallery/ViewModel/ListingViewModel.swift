//
//  ListingViewModel.swift
//  ImageGallery
//
//  Created by Manish T on 29/06/24.
//

import Foundation

protocol ListingIntputViewModel {
    func fetchImages()
    func updateState(forRow atIndex: Int, to newValue: Bool)
}

protocol ListingOutputViewModel {
    var reloadTableView : () -> Void { get set }
    func isListEmpty() -> Bool
    func getNumberOfImages() -> Int
    func getPhotoModelWithState(for index: Int) -> (PhotoModel, Bool)?
}

protocol ListingViewModelType {
    var inputs: ListingIntputViewModel { get }
    var outputs: ListingOutputViewModel { get }
}

class ListingViewModel: ListingViewModelType {
    var inputs: ListingIntputViewModel { return self }
    var outputs: ListingOutputViewModel { return self }
    
    var photosData: [PhotoModel]?
    var rowStateData: [String: Bool] = [:]
    
    var reloadTableView: () -> Void = { }
}

extension ListingViewModel: ListingIntputViewModel {
    func fetchImages() {
        NetworkManager.shared.fetchPhotoListData { [weak self] photosModel in
            self?.photosData = photosModel
            self?.reloadTableView()
        }
    }
    
    func updateState(forRow atIndex: Int, to newValue: Bool) {
        guard let identifier = photosData?[atIndex].id else { return }
        rowStateData[identifier] = newValue
    }
}

extension ListingViewModel: ListingOutputViewModel {
    func isListEmpty() -> Bool {
        photosData?.isEmpty ?? true
    }
    
    func getNumberOfImages() -> Int {
        photosData?.count ?? 0
    }
    
    func getPhotoModelWithState(for index: Int) -> (PhotoModel, Bool)? {
        guard let model = photosData?[index] else { return nil }
        if let rowState = rowStateData[model.id] {
            return (model, rowState)
        } else {
            rowStateData[model.id] = false
            return (model, false)
        }
    }
    
    
}
