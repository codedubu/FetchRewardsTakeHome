//
//  Meal.swift
//  FetchRewardsCodingChallenge
//
//  Created by River McCaine on 10/18/21.
//

import Foundation

struct Meal: Decodable {
    
    let meal: String
    let thumbnail: String
    let id: String
    let mealIngredients: [Ingredient]
    
    
    private enum CodingKeys: String, CodingKey {
        case meal               = "strMeal"
        case thumbnail          = "strMealThumb"
        case id                 = "idMeal"
        case mealIngredients    = "mealIngredients"
    }
} // END OF STRUCT
