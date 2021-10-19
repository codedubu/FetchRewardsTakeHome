//
//  CategoryCell.swift
//  FetchRewardsCodingChallenge
//
//  Created by River McCaine on 10/18/21.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    static let reuseID              = "CategoryCell"
    let categoryImageView           = FRMealImageView(frame: .zero)
    let categoryLabel               = FRTitleLabel(textAlignment: .left, fontSize: 24)
    let categoryDescriptionLabel    = FRBodyLabel(textAlignment: .left)
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(category: Category) {
        categoryLabel.text              = category.name
        categoryDescriptionLabel.text   = category.description
        categoryImageView.downloadImage(fromURL: category.thumbnail)
    }
    
    
    private func configure() {
        addSubviews(categoryImageView, categoryLabel, categoryDescriptionLabel)
        let padding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            categoryImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            categoryImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            categoryImageView.heightAnchor.constraint(equalToConstant: 112),
            categoryImageView.widthAnchor.constraint(equalToConstant: 112),
            
            categoryLabel.centerYAnchor.constraint(equalTo: categoryImageView.topAnchor, constant: padding),
            categoryLabel.leadingAnchor.constraint(equalTo: categoryImageView.trailingAnchor, constant: 14),
            categoryLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            categoryLabel.heightAnchor.constraint(equalToConstant: 40),
            
            categoryDescriptionLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor),
            categoryDescriptionLabel.leadingAnchor.constraint(equalTo: categoryImageView.trailingAnchor, constant: 12),
            categoryDescriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            categoryDescriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding)
        ])
    }
} // END OF CLASS
