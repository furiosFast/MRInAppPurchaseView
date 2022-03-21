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

import SwifterSwift
import UIKit

open class InAppPurchaseData: NSObject, NSCoding {
    public final let id: String
    public final let icon: UIImage
    public final let title: String
    public final let wiki: String?
    public final let purchaseButtonTitle: String
    public final let isPurchasedDisable: Bool
    public final var iconBorderColor: UIColor = .lightGray
    public final var wikiTextAlignment: NSTextAlignment = .center

    public init(_ id: String, _ icon: UIImage, _ title: String, _ wiki: String?, _ purchaseButtonTitle: String, _ isPurchasedDisable: Bool = false) {
        self.id = id
        self.icon = icon
        self.title = title
        self.wiki = wiki
        self.purchaseButtonTitle = purchaseButtonTitle
        self.isPurchasedDisable = isPurchasedDisable
    }

    public required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as! String
        self.icon = UIImage(data: aDecoder.decodeObject(forKey: "icon") as! Data)!
        self.title = aDecoder.decodeObject(forKey: "title") as! String
        self.wiki = aDecoder.decodeObject(forKey: "wiki") as? String
        self.purchaseButtonTitle = aDecoder.decodeObject(forKey: "purchaseButtonTitle") as! String
        self.isPurchasedDisable = aDecoder.decodeObject(forKey: "isPurchasedDisable") as! Bool
    }

    public func encode(with encoder: NSCoder) {
        encoder.encode(self.id, forKey: "id")
        encoder.encode(self.icon.compressedData(), forKey: "icon")
        encoder.encode(self.title, forKey: "title")
        encoder.encode(self.wiki, forKey: "wiki")
        encoder.encode(self.purchaseButtonTitle, forKey: "purchaseButtonTitle")
        encoder.encode(self.isPurchasedDisable, forKey: "isPurchasedDisable")
    }
}
