# MRInAppPurchaseView

[![SPM ready](https://img.shields.io/badge/SPM-ready-orange.svg)](https://swift.org/package-manager/)
![Platform](https://img.shields.io/badge/platforms-iOS%2013.0-F28D00.svg)
[![Swift](https://img.shields.io/badge/Swift-5.5-orange.svg)](https://swift.org)
[![Xcode](https://img.shields.io/badge/Xcode-13.0-blue.svg)](https://developer.apple.com/xcode)
[![License](https://img.shields.io/cocoapods/l/Pastel.svg?style=flat)](https://github.com/furiosFast/MRInAppPurchaseView/blob/main/LICENSE)
[![Twitter](https://img.shields.io/badge/twitter-@FastDevsProject-blue.svg?style=flat)](https://twitter.com/FastDevsProject)

Simple tableView for display and interact with in-app purchases
    
<p align="center" width="100%">
    <img src="https://github.com/furiosFast/MRInAppPurchaseView/blob/main/Assets/screen.png">
</p>
    
## Requirements

- iOS 13.0+
- Xcode 13.0+
- Swift 5.5+

## Installation

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It is in early development, but MRInAppPurchaseView does support its use on supported platforms.

Once you have your Swift package set up, adding MRInAppPurchaseView as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/furiosFast/MRInAppPurchaseView.git", from: "1.0.0")
]
```

### Manually

If you prefer not to use any of the aforementioned dependency managers, you can integrate MRInAppPurchaseView into your project manually.

## Usage

### Example

```swift
import MRInAppPurchaseView
import SwifterSwift
import UIKit

class IAPViewController: MRInAppPurchaseView, MRInAppPurchaseViewDelegate {
    var IAPDataList: [InAppPurchaseData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inAppPurchaseView.delegate = self
        
        inAppPurchaseView.setCellTitleFont(UIFont.systemFont(ofSize: 20))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)                
        setupInAppPurchaseData()
        
        DispatchQueue.global().async {
            if IAPManager.shared.products.count < IAPManager.shared.productIDS.count {
                IAPManager.shared.getProductInfo {
                    self.setupInAppPurchaseData()
                    
                    DispatchQueue.main.async {
                        self.inAppPurchaseView.reloadData()
                    }
                }
            }
        }
    }

    // MARK: - MRInAppPurchaseViewDelegate
    
    func inAppPurchaseButtonTapped(inAppPurchase: InAppPurchaseData) {
        let manager = IAPManager.shared
        
        if inAppPurchase.id == inAppId_proKit {
            proKit(manager)
        } else {
            restorePurchases(manager)
        }
    }
    
    // MARK: - Private functions
    
    private func setupInAppPurchaseData() {
        IAPDataList.removeAll()
        inAppPurchaseView.setInAppPurchases([])
        let manager = IAPManager.shared //your in-app data manager
        
        // pro kit
        if !PurchasedInApp.proKit.isPurchased {
            let data = InAppPurchaseData(inAppId_proKit, manager.productIcons[inAppId_proKit]!, loc("settings_PROKIT"), loc("settings_PROKITWIKI"), loc("inapp_BUY").uppercased())
            data.wikiTextAlignment = .left
            IAPDataList.append(data)
        }
        
        // restore
        let data = InAppPurchaseData("restore", #imageLiteral(resourceName: "restore in-app"), loc("settings_RESTOREINAPP"), nil, loc("inapp_RESTORE").uppercased())
        data.iconBorderColor = .clear
        IAPDataList.append(data)
        
        inAppPurchaseView.setInAppPurchases(IAPDataList)
    }
    
    // in-app products actions
    private func proKit(_ manager: IAPManager) {
        if manager.products.count != 0 {
            manager.purchaseProduct(productId: inAppId_proKit, completed: { message in
                if message.isEmpty {
                    self.showAlert(title: "Success", message: "PRO Kit purchased", buttonTitles: ["OK"])
                
                    self.setupInAppPurchaseData()
                    self.inAppPurchaseView.reloadData()
                } else {
                    if message != loc("inapp_UNKNOWERROR") {
                        self.showAlert(title: "Warning"), message: message, buttonTitles: ["OK"])
                    }
                }
                self.inAppPurchaseView.setNomalStateToPurchaseButtonsFromProgress()
            })
        } else {
            inAppPurchaseView.setNomalStateToPurchaseButtonsFromProgress()
        }
    }
    
    private func restorePurchases(_ manager: IAPManager) {
        if manager.products.count != 0 {
            manager.restorePurchases(completed: { [self] restoreMessage, purchase in
                if restoreMessage.isEmpty {
                    purchase.restoredPurchases.forEach { purchase in
                        switch purchase.productId {
                            case inAppId_proKit: do {
                                //do somethings...
                            default: break
                        }
                    }
                    
                    
                    self.setupInAppPurchaseData()
                    self.inAppPurchaseView.reloadData()
                    self.showAlert(title: "Success", message: loc("inapp_RESTORESUCCESS"), buttonTitles: ["OK"])
                } else {
                    self.showAlert(title: "Warning", message: restoreMessage, buttonTitles: ["OK"])
                }
                self.inAppPurchaseView.setNomalStateToPurchaseButtonsFromProgress()
            })
        } else {
            inAppPurchaseView.setNomalStateToPurchaseButtonsFromProgress()
        }
    }
```

And now open show 'inAppPurchaseView' from your ViewController

```swift
class ViewController: UIViewController {
    
    //MARK: - IBActions
    @IBAction func showIAPViewController(_ sender: Any) {
        let iapVC = IAPViewController()
        iapVC.navigationItem.title = loc("settings_INAPPHEADERTEXT")
        
        let navC = UINavigationController(rootViewController: iapVC)
        present(navC, animated: true)
    }

}
```

## Requirements

MRInAppPurchaseView has different dependencies and therefore needs the following libraries (also available via SPM):
- [SwifterSwift](https://github.com/SwifterSwift/SwifterSwift.git) 5.1.0+

It isn't necessary to add the dependencies of MRInAppPurchaseView, becose with SPM all is do automatically!

## License

MRInAppPurchaseView is released under the MIT license. See [LICENSE](https://github.com/furiosFast/MRInAppPurchaseView/blob/main/LICENSE) for more information.
