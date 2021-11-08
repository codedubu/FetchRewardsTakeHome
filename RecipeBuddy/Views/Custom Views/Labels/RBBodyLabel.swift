//
//  RBBodyLabel.swift
//  RecipeBuddy
//
//  Created by River McCaine on 10/18/21.
//

import UIKit

class RBBodyLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    convenience init(textAlignment: NSTextAlignment) {
        self.init(frame: .zero)
        self.textAlignment  = textAlignment
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        textColor                           = .secondaryLabel
        font                                = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontSizeToFitWidth           = true
        adjustsFontForContentSizeCategory   = true
        minimumScaleFactor                  = 0.75
        lineBreakMode                       = .byTruncatingTail
        numberOfLines                       = 0
        translatesAutoresizingMaskIntoConstraints = false
    }
} // END OF CLASS
