//
//  NetworkImageFetch.swift
//  GoodRecipes
//
//  Created by Тim Akhm on 07.02.2022.
//

import Foundation

class NetworkImageFetch {
    
    static let shared = NetworkImageFetch()
    private init() {}
          
    func fetchImage(from urlStrings: [String], completion: @escaping (Result<Data, Error>) -> Void) {
       
        for urlString in urlStrings {
            let session = URLSession.shared
            let url = URL(string: urlString)
            
            let task = session.dataTask(with: url!) { (data, response, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    guard let data = data else { return }
                    completion(.success(data))
                }
            }
            task.resume()
        }
    }
}
