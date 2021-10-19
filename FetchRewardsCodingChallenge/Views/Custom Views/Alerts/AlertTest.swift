//
//  AlertTest.swift
//  FetchRewardsCodingChallenge
//
//  Created by River McCaine on 10/19/21.
//

import UIKit

extension UIViewController {
    
    func presentAlertOnMainThread(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Something went wrong.", message: message, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
} // END OF EXTENSION
