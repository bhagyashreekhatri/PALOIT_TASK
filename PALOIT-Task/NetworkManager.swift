//
//  NetworkManager.swift
//  PALOIT-Task
//
//  Created by Bhagyashree Khatri on 20/07/24.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager() //Singelton (Shared resources)
    var urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
            self.urlSession = urlSession
        }
    
    func fetchImages(page: Int, pagelimit: Int = 10, url: String, completion: @escaping ([ImageModel]?, Error?) -> Void) {
        let urlString = "\(url)?page=\(page)&limit=\(pagelimit)"
        
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(nil, NSError(domain: "Invalid Response", code: 0, userInfo: nil))
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "No Data", code: 0, userInfo: nil))
                return
            }
            
            do {
                let images = try JSONDecoder().decode([ImageModel].self, from: data)
                completion(images, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
}
