//
//  IngredientCell.swift
//  FetchRewardsCodingChallenge
//
//  Created by River McCaine on 10/19/21.
//

import UIKit

class IngredientCell: UITableViewCell {

    static let reuseID          = "IngredientCell"
    let ingredientLabel         = FRTitleLabel(textAlignment: .left, fontSize: 14)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(mealDetail: Ingredient) {
        ingredientLabel.text = mealDetail.ingredient
    }
    
    
    private func configure() {
        addSubview(ingredientLabel)
        let padding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            ingredientLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            ingredientLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 14),
            ingredientLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            ingredientLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
