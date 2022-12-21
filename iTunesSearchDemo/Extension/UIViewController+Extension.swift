//
//  UIViewController+Extension.swift
//  iTunesSearchDemo
//
//  Created by cm0678 on 2022/12/21.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String? = nil, okActionTitle: String = "OK", handler: ((UIAlertAction) -> Void)? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okActionTitle, style: .default, handler: handler)
        alertController.addAction(okAction)

        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
