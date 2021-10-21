//
//  Constants.swift
//  FetchRewardsCodingChallenge
//
//  Created by River McCaine on 10/20/21.
//

import Foundation

enum Networking {
    
    static let mealDBURL        = "https://www.themealdb.com/api/json/"
    static let version          = "v1"
    static let key              = "1"
    static let category         = "categories.php"
    static let filter           = "filter.php"
    static let lookup           = "lookup.php"
    static let mealID           = "i"
    static let search           = "c"
    
    static let meal             = "strMeal"
    static let mealinstructions = "strInstructions"
    static let ingredients      = "strIngredient"
    static let measurement      = "strMeasure"
    static let youtube          = "strYoutube"
    static let source           = "strSource"
    static let nullValue        = "<null>"
} // END OF ENUM


enum Alert {
    
    static let wrong            = "Something went wrong"
    static let ok               = "Ok"
    static let request          = "Unable to complete request"
    static let uhOh             = "Uh oh!"
    static let link             = "It seems that there is no link provided for this recipe."
} // END OF ENUM


enum Title {
    
    static let categories       = "Categories"
    static let instructions     = "Instructions"
    static let ytlink           = "YouTube Link"
    static let sourcelink       = "Source Link"
    static let mealPlaceholder  = "Search for some food!"
} // END OF ENUM


enum Cells {
    
    static let category         = "CategoryCell"
    static let meal             = "MealCell"
    static let ingredient       = "IngredientCell"
}// END OF ENUM


enum Images {
    
    static let placeHolder      = "fork.knife.circle"
}// END OF ENUM
