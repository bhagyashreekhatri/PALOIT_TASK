//
//  ImagesViewModel.swift
//  PALOIT-Task
//
//  Created by Bhagyashree Khatri on 20/07/24.
//

import Foundation
import UIKit

class ImagesViewModel {
    private var networkManager = NetworkManager.shared
    var images: [ImageModel] = []
    private var currentPage = 1
    private let itemsPerPage = 10 // Adjust based on the API requirements
    
    init(networkManager: NetworkManager = NetworkManager.shared) {
            self.networkManager = networkManager
        }

    var numberOfImages: Int {
        return images.count
    }
    
    func getImage(at index: Int) -> ImageModel {
        return images[index]
    }
    
    func fetchImages(completion: @escaping (Error?) -> Void) {
        networkManager.fetchImages(page: currentPage, pagelimit: itemsPerPage, url: APIEndpoints.shared.imagesList) { [weak self] fetchedImages, error in
            guard let self = self else { return }
            if let fetchedImages = fetchedImages {
                self.images.append(contentsOf: fetchedImages)
                self.currentPage += 1
                completion(nil)
            } else if let error = error {
                completion(error)
            }
        }
    }
}
