//
//  ListingViewModel.swift
//  ImageGallery
//
//  Created by Manish T on 29/06/24.
//

import Foundation

protocol ListingIntputViewModel {
    func fetchImages(isRefereshOperation: Bool)
    func updateState(forRow atIndex: Int, to newValue: Bool)
}

protocol ListingOutputViewModel {
    var hideLoadingIndicator: () -> Void { get set }
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
    var currentPageNumber: Int = 1
    
    var reloadTableView: () -> Void = { }
    var hideLoadingIndicator: () -> Void = { }
}

extension ListingViewModel: ListingIntputViewModel {
    func fetchImages(isRefereshOperation: Bool) {
        let pageNumber = isRefereshOperation ? currentPageNumber : getPageNumber()
        NetworkManager.shared.fetchPhotoListData(for: pageNumber) { [weak self] photosModel in
            guard let self else { return }
            
            if self.photosData == nil {
                self.photosData = []
            }
            
            if let photosModel = photosModel {
                self.photosData?.append(contentsOf: photosModel)
            }
            
            self.reloadTableView()
            self.hideLoadingIndicator()
        }
        currentPageNumber = pageNumber
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
            rowStateData[model.id] = true
            return (model, true)
        }
    }
}

private extension ListingViewModel {
    func getPageNumber() -> Int {
        guard let numberOfItems = photosData?.count else { return 1 }
        let pageNumber = (numberOfItems + 9) / 10
        return max(pageNumber, 1)
    }
}
