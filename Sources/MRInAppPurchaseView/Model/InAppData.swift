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
//  Copyright © 2021 Fast-Devs Project. All rights reserved.
//

import SwifterSwift
import UIKit

open class InAppData: NSObject, NSCoding {
    public final let icon: UIImage
    public final let title: String
    public final let info: String
    public final let purchaseButtonTitle: String
    public final let isPurchasedDisable: Bool

    public init(_ icon: UIImage, _ title: String, _ info: String, _ purchaseButtonTitle: String, _ isPurchasedDisable: Bool = false) {
        self.icon = icon
        self.title = title
        self.info = info
        self.purchaseButtonTitle = purchaseButtonTitle
        self.isPurchasedDisable = isPurchasedDisable
    }

    public required init?(coder aDecoder: NSCoder) {
        self.icon = UIImage(data: aDecoder.decodeObject(forKey: "icon") as! Data)!
        self.title = aDecoder.decodeObject(forKey: "title") as! String
        self.info = aDecoder.decodeObject(forKey: "info") as! String
        self.purchaseButtonTitle = aDecoder.decodeObject(forKey: "purchaseButtonTitle") as! String
        self.isPurchasedDisable = aDecoder.decodeObject(forKey: "isPurchasedDisable") as! Bool
    }

    public func encode(with encoder: NSCoder) {
        encoder.encode(self.icon.compressedData(), forKey: "icon")
        encoder.encode(self.title, forKey: "title")
        encoder.encode(self.info, forKey: "info")
        encoder.encode(self.purchaseButtonTitle, forKey: "purchaseButtonTitle")
        encoder.encode(self.isPurchasedDisable, forKey: "isPurchasedDisable")
    }
}
