//
//  IngredientCell.swift
//  FetchRewardsCodingChallenge
//
//  Created by River McCaine on 10/19/21.
//

import UIKit

class IngredientCell: UITableViewCell {

    static let reuseID          = "IngredientCell"
    let ingredientLabel         = FRTitleLabel(textAlignment: .left, fontSize: 18)
    let measurementLabel        = FRBodyLabel(textAlignment: .left)

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(mealDetail: Ingredient) {
        ingredientLabel.text    = mealDetail.ingredient.localizedCapitalized
        measurementLabel.text   = mealDetail.measurement
    }
    
    
    
    private func configure() {
        addSubviews(ingredientLabel, measurementLabel)
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
      
            ingredientLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            ingredientLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 14),
            ingredientLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            ingredientLabel.heightAnchor.constraint(equalToConstant: 20),
            
            measurementLabel.topAnchor.constraint(equalTo: ingredientLabel.bottomAnchor, constant: padding),
            measurementLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 14),
            measurementLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            measurementLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding)
        ])
    }
} // END OF CLASS
