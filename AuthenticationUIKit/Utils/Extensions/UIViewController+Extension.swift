//
//  UIViewController+Extension.swift
//  AuthenticationUIKit
//
//  Created by Elif Parlak on 5.01.2025.
//

import UIKit

extension UIViewController {
    //MARK: Present Alert
    func presentAlert(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: buttonTitle, style: .default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
        }
    }
}
