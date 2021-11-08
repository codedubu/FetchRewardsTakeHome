//
//  Recipe.swift
//  RecipeBuddy
//
//  Created by River McCaine on 10/18/21.
//

import Foundation

struct CategorySearchResults: Decodable {

    let categories: [Category]
} // END OF STRUCT


struct Category: Decodable {
    
    let id: String
    let name: String
    let thumbnail: String
    let description: String
    
    
    private enum CodingKeys: String, CodingKey {
        case id             = "idCategory"
        case name           = "strCategory"
        case thumbnail      = "strCategoryThumb"
        case description    = "strCategoryDescription"
    }
} // END OF STRUCT
