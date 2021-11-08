//
//  Meal.swift
//  RecipeBuddy
//
//  Created by River McCaine on 10/18/21.
//

import Foundation

struct MealSearchResults: Decodable {
    
    let meals: [Meal]
} // END OF STRUCT


struct Meal: Decodable {
    
    let name: String
    let thumbnail: String
    let id: String
    
    private enum CodingKeys: String, CodingKey {
        case name               = "strMeal"
        case thumbnail          = "strMealThumb"
        case id                 = "idMeal"
    }
} // END OF STRUCT
