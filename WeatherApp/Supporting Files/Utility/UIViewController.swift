//
//  UIViewController.swift
//  Revolutic
//
//  Created by Muhammad Asher Azeem on 5/20/25.
//  Copyright © 2025 Revolutic. All rights reserved.
//

import Foundation
import UIKit

var activityIndicator: UIActivityIndicatorView?

extension UIViewController {
    
    func showLoadingIndicator() {
        if activityIndicator == nil {
            activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator?.center = view.center
            activityIndicator?.color = .white
            view.addSubview(activityIndicator!)
        }
        activityIndicator?.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator?.stopAnimating()
    }
    
    func showAlert(
        title: String = "Search",
        message: String = "Enter a city name",
        placeholder: String = "City",
        onSearch: @escaping (String) -> Void
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = placeholder
        }
        let searchAction = UIAlertAction(title: title, style: .default) { _ in
            if let text = alertController.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines),
               !text.isEmpty {
                onSearch(text)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(searchAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}

