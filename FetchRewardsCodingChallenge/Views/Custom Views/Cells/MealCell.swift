//
//  MealCell.swift
//  FetchRewardsCodingChallenge
//
//  Created by River McCaine on 10/18/21.
//

import UIKit

class MealCell: UITableViewCell {

    static let reuseID          = "MealCell"
    let mealImageView           = FRMealImageView(frame: .zero)
    let mealLabel               = FRTitleLabel(textAlignment: .left, fontSize: 22)
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func set(meal: Meal) {
        mealLabel.text = meal.name
        mealImageView.downloadImage(fromURL: meal.thumbnail)
    }
    
    
    private func configure() {
        addSubviews(mealImageView, mealLabel)
        let padding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            mealImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            mealImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            mealImageView.heightAnchor.constraint(equalToConstant: 112),
            mealImageView.widthAnchor.constraint(equalToConstant: 112),
            
            mealLabel.centerYAnchor.constraint(equalTo: mealImageView.centerYAnchor),
            mealLabel.leadingAnchor.constraint(equalTo: mealImageView.trailingAnchor, constant: 14),
            mealLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            mealLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
} // END OF CLASS
