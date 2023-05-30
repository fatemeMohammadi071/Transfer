//
//  UIViewController+Extension.swift
//  Github
//
//  Created by Fateme on 2022-11-11.
//

import UIKit

extension UIViewController {
    func presentMessege(title: String?, message: String?, additionalActions: UIAlertAction..., preferredStyle: UIAlertController.Style, retryHandler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: preferredStyle)
        if retryHandler != nil {
            alertController.addAction(.init(title: "Retry", style: .default, handler: retryHandler))
        }
        additionalActions.forEach(alertController.addAction)
        alertController.setStyle(style: self.preferredStatusBarStyle)
        alertController.modalPresentationStyle = .currentContext
        present(alertController, animated: true, completion: nil)
    }
}
