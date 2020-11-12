//
//  NetworkUtility.swift
//  WSJFeed
//
//  Created by Bhaskar Ghosh on 11/10/20.
//  Copyright © 2020 Bhaskar Ghosh. All rights reserved.
//

import Foundation

class NetworkUtility {
    static let shared = NetworkUtility()
    private init() {}
    
    func fetchRSSFeed(for urlString: String, completion: @escaping (Data?, Error?) -> Void) {
        if let url = URL(string: urlString) {
            let urlRequest = URLRequest(url: url)
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard let rssData = data, error == nil else {
                    completion(nil, error!)
                    return
                }
                
                completion(rssData, nil)
            }.resume()
        }
    }
}
