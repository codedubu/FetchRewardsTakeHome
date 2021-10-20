//
//  Mealy.swift
//  FetchRewardsCodingChallenge
//
//  Created by River McCaine on 10/18/21.


import Foundation

struct MealDetail {

    let name: String
    let instructions: String
    let youtubeLink: String
    let sourceLink: String
    let ingredients: [Ingredient]?
    
    static func decode(from data: [String : Any]) -> MealDetail? {
        guard   let name          = data["strMeal"] as? String,
                let instructions  = data["strInstructions"] as? String,
                let youTubeLink   = data["strYoutube"] as? String,
                let sourceLink    = data["strSource"] as? String
        else { return nil }
        
        var ingredients: [Ingredient] = []
        for i in 1...20 {
            if let ingredient = data["strIngredient\(i)"] as? String,
               let measurement = data ["strMeasure\(i)"] as? String {
                if ingredient != "<null>" && !ingredient.isEmpty {
                    ingredients.append(Ingredient(ingredient: ingredient, measurement: measurement))
                } else {
                    break
                }
            }
        }
        
        return MealDetail(name: name, instructions: instructions, youtubeLink: youTubeLink, sourceLink: sourceLink, ingredients: ingredients)
    }
} // END OF STRUCT

struct Ingredient {
    let ingredient: String
    let measurement: String
} // END OF STRUCT
