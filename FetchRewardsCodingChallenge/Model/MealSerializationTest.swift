//
//  Mealy.swift
//  FetchRewardsCodingChallenge
//
//  Created by River McCaine on 10/18/21.


import Foundation

struct Mealy {
    let id: String
    let name: String
    let instructions: String
//    let area: String
//    let thumbnail: String
//    let youtubeLink: String
//    let sourceLink: String
    let ingredients: [Ingredienty]
    
    static func decode(from data: [String : Any]) -> Mealy? {
        guard   let id            = data["strID"] as? String,
                let name          = data["strMeal"] as? String,
//
                let instructions  = data["strIntstrutions"] as? String
//              let area          = data["strArea"] as? String,
//              let thumbnail     = data["strMealThumb"] as? String,
//              let youTubeLink   = data["strYoutube"] as? String,
//              let sourceLink    = data["strSource"] as? String
        else { return nil }
        
        var ingredients: [Ingredienty] = []
        for i in 1...20 {
            if let ingredient = data["strIngredient\(i)"] as? String,
               let measurement = data ["strMeasurement\(i)"] as? String {
                if ingredient != "<null>" && !ingredient.isEmpty {
                    ingredients.append(Ingredienty(ingredient: ingredient, measurement: measurement))
                } else {
                    break
                }
            }
            }
        
        return Mealy(id: id, name: name, instructions: instructions, ingredients: ingredients)
    }
} // END OF STRUCT

struct Ingredienty {
    let ingredient: String
    let measurement: String
} // END OF STRUCT
