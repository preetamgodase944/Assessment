//
//  NetworkManager.swift
//  ImageGallery
//
//  Created by Manish T on 28/06/24.
//

import Foundation
import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    
    var imageCache = NSCache<NSString, UIImage>()
    
    private init() { }
    
    func fetchPhotoListData(for page: Int = 1, completion: @escaping ([PhotoModel]?)-> Void) {
        guard let url = getAPIURL(for: page) else {
            completion(nil)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            do {
                let decoder = JSONDecoder()
                let imageDataArray = try decoder.decode([PhotoModel].self, from: data)
                completion(imageDataArray)
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
    
    func getImage(for model: PhotoModel, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: model.id as NSString) {
            completion(cachedImage)
        } else {
            downloadImage(from: model.downloadUrl, cache: imageCache) {
                completion($0)
            }
        }
    }
}

private extension NetworkManager {
    func getAPIURL(for page: Int) -> URL? {
        let apiURL = "https://picsum.photos/v2/list?page=\(page)&limit=20"
        return URL(string: apiURL)
    }
    
    func downloadImage(from urlString: String, cache: NSCache<NSString, UIImage>, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            completion(cachedImage)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    cache.setObject(image, forKey: urlString as NSString)
                    completion(image)
                }
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
}
