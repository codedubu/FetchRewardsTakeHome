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
        guard   let name          = data[Networking.meal] as? String,
                let instructions  = data[Networking.mealinstructions] as? String,
                let youTubeLink   = data[Networking.youtube] as? String,
                let sourceLink    = data[Networking.source] as? String
        else { return nil }
        
        var ingredients: [Ingredient] = []
        
        for i in 1...20 {
            if let ingredient = data["\(Networking.ingredients)\(i)"] as? String,
               let measurement = data ["\(Networking.measurement)\(i)"] as? String {
                if ingredient != "\(Networking.nullValue)" && !ingredient.isEmpty {
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
