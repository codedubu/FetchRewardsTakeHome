//
//  UIViewController + Ext.swift
//  FetchRewardsCodingChallenge
//
//  Created by River McCaine on 10/19/21.
//

import UIKit
import SafariServices

extension UIViewController {
    
    func presentFRAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = FRAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle  = .overFullScreen
            alertVC.modalTransitionStyle    = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
    
    func presentSafariVC(with stringURL: String) {
        if stringURL.isEmpty {
            presentFRAlertOnMainThread(title: Alert.uhOh, message: Alert.link, buttonTitle: Alert.ok)
        } else {
            guard let convertedToURL = URL(string: stringURL) else { return }

            let safariVC = SFSafariViewController(url: convertedToURL)
            safariVC.preferredControlTintColor = .systemBlue
            present(safariVC, animated: true)
        }
    }
    
    
    func popVCOnMainThread() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
} // END OF EXTENSION
