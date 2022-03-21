//
//  Config.swift
//  MRInAppPurchaseView
//
//  Created by Marco Ricca on 17/03/2022
//
//  Created for MRInAppPurchaseView in 17/03/2022
//  Using Swift 5.4
//  Running on macOS 11.5.2
//
//  Copyright © 2021-2022 Fast-Devs Project. All rights reserved.
//

import UIKit

class Utils {
    /// Public function for get localized string from this Bundle
    /// - Parameter localizedKey: string key to localize
    static func locFromBundle(_ localizedKey: String) -> String {
        return loc(localizedKey)
    }

    /// Public function for localize string
    /// - Parameter localizedKey: string key to localize
    static func loc(_ localizedKey: String) -> String {
        return NSLocalizedString(localizedKey, bundle: .module, comment: "")
    }

    /// Public function for show an alert with aligned body text
    /// - Parameters:
    ///   - text: alert title
    ///   - textAlign: aligned text
    ///   - alert: UIAlertController
    /// - Returns: alert with aligned text
    @discardableResult
    static func showAttributedAlert(text: String, textAlignment: NSTextAlignment = NSTextAlignment.left, alert: UIAlertController) -> UIAlertController {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment

        let attributedMessageText = NSMutableAttributedString(string: text, attributes: [
            .paragraphStyle: paragraphStyle,
            .font: UIFont.systemFont(ofSize: 13.0)
        ])

        alert.setValue(attributedMessageText, forKey: "attributedMessage")

        return alert
    }
}
