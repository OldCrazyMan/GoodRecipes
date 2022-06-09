//
//  NetworkRequest.swift
//  GoodRecipes
//
//  Created by Тim Akhm on 07.02.2022.
//
//

import Foundation

class NetworkRequest {
    
    static let shared = NetworkRequest()
    private init() {}
    func requestData(completion: @escaping (Result<Data, Error>) -> Void) {
        
        let urlString = "https://test.kode-t.ru/recipes.json"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, responce, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else { return }
                completion(.success(data))
            }
        }
        .resume()
    }
}
