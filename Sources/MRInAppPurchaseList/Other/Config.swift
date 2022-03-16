//
//  Config.swift
//  Device Monitor
//
//  Created by Marco Ricca on 08/04/2019
//
//  Created for Device Monitor in 08/04/2019
//  Using Swift 5.0
//  Running on macOS 10.14
//
//  Copyright © 2019 Marco. All rights reserved.
//

import UIKit

// MARK: - Shared functions

/// Public function for get localized string from this Bundle
/// - Parameter localizedKey: string key to localize
public func locFromBundle(_ localizedKey: String) -> String {
    return loc(localizedKey)
}

/// Short function for localize string
/// - Parameter localizedKey: string key to localize
func loc(_ localizedKey: String) -> String {
    return NSLocalizedString(localizedKey, bundle: .module, comment: "")
}

extension UIView {
    func subviewsRecursive() -> [UIView] {
        return subviews + subviews.flatMap { $0.subviewsRecursive() }
    }
}
