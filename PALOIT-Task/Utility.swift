//
//  Utility.swift
//  PALOIT-Task
//
//  Created by Bhagyashree Khatri on 21/07/24.
//

import UIKit

class ErrorAlertUtility {
    
    static func showAlert(in viewController: UIViewController, title: String, message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    static func showError(in viewController: UIViewController, error: Error, completion: (() -> Void)? = nil) {
        showAlert(in: viewController, title: "Error", message: error.localizedDescription, completion: completion)
    }
}
