//
//  NetworkDataFetch.swift
//  GoodRecipes
//
//  Created by Тim Akhm on 07.02.2022.
//

import Foundation

class NetworkDataFetch {
    
    static let shared = NetworkDataFetch()
    private init() {}
    
    func fetchRecipe(responce: @escaping (RecipesModel?, Error?) -> Void) {
        NetworkRequest.shared.requestData() { result in
            switch result {
            case .success(let data):
                let decode =  self.decodeJSON(type: RecipesModel.self, from: data)
                responce(decode, nil)
            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
                responce(nil, error)
            }
        }
    }
    
    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonError {
            print("Failed to decode JSON", jsonError)
            return nil
        }
    }
}
