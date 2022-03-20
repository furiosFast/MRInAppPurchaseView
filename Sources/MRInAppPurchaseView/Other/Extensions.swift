//
//  Extensions.swift
//  Extensions
//
//  Created by Marco Ricca on 11/09/2021
//
//  Created for MRInAppPurchaseView in 11/09/2021
//  Using Swift 5.4
//  Running on macOS 11.5.2
//
//  Copyright © 2021-2022 Fast-Devs Project. All rights reserved.
//

import UIKit

extension UIView {
    func subviewsRecursive() -> [UIView] {
        return subviews + subviews.flatMap { $0.subviewsRecursive() }
    }
}
