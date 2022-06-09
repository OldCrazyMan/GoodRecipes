//
//  RecipesModel.swift
//  GoodRecipes
//
//  Created by Тim Akhm on 01.06.2022.
//

import Foundation

    // MARK: - RecipesModel

struct RecipesModel: Codable {
    let recipes: [Recipe]
}

    // MARK: - Recipe

struct Recipe: Codable {
    let uuid, name: String
    let images: [String]
    let lastUpdated: Int
    let recipeDescription: String?
    let instructions: String
    let difficulty: Int
    
    enum CodingKeys: String, CodingKey {
        case name, images
        case recipeDescription = "description"
        case uuid = "uuid"
        case lastUpdated = "lastUpdated"
        case instructions, difficulty
    }
}

extension Recipe: Hashable {
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
