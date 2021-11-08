//
//  RBActivityIndicatorVC.swift
//  RecipeBuddy
//
//  Created by River McCaine on 10/19/21.
//

import UIKit

class RBActivityIndicatorVC: UIViewController {
    
    var containerView: UIView!
    
    
    func showActivityIndicator() {
        containerView = UIView(frame: view.bounds)
        view.addSubviews(containerView)
        
        containerView.backgroundColor   = .systemBackground
        containerView.alpha             = 0
        
        UIView.animate(withDuration: 0.25) { self.containerView.alpha = 0.8 }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    
    func dismissActivityIndicator() {
        DispatchQueue.main.async {
            self.containerView.removeFromSuperview()
            self.containerView = nil
        }
    }
} // END OF CLASS
