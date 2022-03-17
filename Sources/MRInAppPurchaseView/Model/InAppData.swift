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

open class InAppData: NSObject {
    public final let icon: UIImage
    public final let title: String
    public final let info: String
    public final let purchaseButtonTitle: String
    public final let confirmationPurchaseButtonTitle: String
    public final let isPurchased: Bool

    public init(_ icon: UIImage, _ title: String, _ info: String, _ purchaseButtonTitle: String, _ confirmationPurchaseButtonTitle: String, _ isPurchased: Bool) {
        self.icon = icon
        self.title = title
        self.info = info
        self.purchaseButtonTitle = purchaseButtonTitle
        self.confirmationPurchaseButtonTitle = confirmationPurchaseButtonTitle
        self.isPurchased = isPurchased
    }

    public required init?(coder aDecoder: NSCoder) {
        self.icon = UIImage(data: aDecoder.decodeObject(forKey: "icon") as! Data)!
        self.title = aDecoder.decodeObject(forKey: "title") as! String
        self.info = aDecoder.decodeObject(forKey: "info") as! String
        self.purchaseButtonTitle = aDecoder.decodeObject(forKey: "purchaseButtonTitle") as! String
        self.confirmationPurchaseButtonTitle = aDecoder.decodeObject(forKey: "confirmationPurchaseButtonTitle") as! String
        self.isPurchased = aDecoder.decodeObject(forKey: "isPurchased") as! Bool
    }

    func encode(with encoder: NSCoder) {
        encoder.encode(self.icon.compressedData(), forKey: "icon")
        encoder.encode(self.title, forKey: "title")
        encoder.encode(self.info, forKey: "info")
        encoder.encode(self.purchaseButtonTitle, forKey: "purchaseButtonTitle")
        encoder.encode(self.confirmationPurchaseButtonTitle, forKey: "confirmationPurchaseButtonTitle")
        encoder.encode(self.isPurchased, forKey: "isPurchased")
    }
}
