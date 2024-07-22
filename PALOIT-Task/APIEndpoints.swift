//
//  APIEndpoints.swift
//  PALOIT-Task
//
//  Created by Bhagyashree Khatri on 20/07/24.
//

import Foundation

class APIEndpoints {
    
    static let shared = APIEndpoints()
    
    private let baseURL = "https://picsum.photos/v2"
    
    var imagesList: String {
        return "\(baseURL)/list"
    }
    // Add more endpoints as needed
    private init() {}
}
