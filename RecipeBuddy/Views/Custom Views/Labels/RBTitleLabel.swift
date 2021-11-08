//
//  RBTitleLabel.swift
//  RecipeBuddy
//
//  Created by River McCaine on 10/18/21.
//

import UIKit

class RBTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        self.init(frame: .zero)
        self.textAlignment  = textAlignment
        self.font           = UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        textColor                   = .label
        adjustsFontSizeToFitWidth   = true
        minimumScaleFactor          = 0.7
        lineBreakMode               = .byWordWrapping
        numberOfLines               = 0
        translatesAutoresizingMaskIntoConstraints = false
    }
} // END OF CLASS
