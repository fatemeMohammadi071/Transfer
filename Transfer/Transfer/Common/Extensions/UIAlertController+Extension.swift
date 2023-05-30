//
//  UIAlertController+Extension.swift
//  Github
//
//  Created by Fateme on 2022-11-11.
//

import Foundation
import UIKit

extension UIAlertController {
    private static var style: UIStatusBarStyle = .default

    func setStyle(style: UIStatusBarStyle) {
        UIAlertController.style = style
        self.setNeedsStatusBarAppearanceUpdate()
    }

    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return UIAlertController.style
    }
}
