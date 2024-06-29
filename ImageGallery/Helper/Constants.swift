//
//  Strings.swift
//  ImageGallery
//
//  Created by Manish T on 28/06/24.
//

import Foundation

enum Constants {
    
    enum ScreenName: String {
        case LaunchScreen
        case ListingVC
    }
    
    enum StoryBoard: String {
        case LaunchScreen
        case Main
    }
    
    enum ImageName: String {
        case selected = "checkmark.square.fill"
        case unselected = "square"
        case placeHolderImage = "photo"
    }
    
    enum TableViewEmptyState: String {
        case title = "Empty List"
        case description = "Couldn't load photos, try again later"
    }
    
    enum AlertStrings {
        enum RowDisabled: String {
            case title = "Row Disabled"
            case message = "Can't select row, Please enable it to perform this action"
        }
        
        enum ButtonTitle: String {
            case ok = "Ok"
        }
    }
    
}
