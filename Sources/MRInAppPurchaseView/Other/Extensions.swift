//
//  File.swift
//
//
//  Created by Marco Ricca on 20/03/22.
//

import UIKit

extension UIView {
    func subviewsRecursive() -> [UIView] {
        return subviews + subviews.flatMap { $0.subviewsRecursive() }
    }
}
