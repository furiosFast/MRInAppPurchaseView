//
//  MRFilteredLocations.swift
//  MRFilteredLocations
//
//  Created by Marco Ricca on 11/09/2021
//
//  Created for MRFilteredLocations in 11/09/2021
//  Using Swift 5.4
//  Running on macOS 11.5.2
//
//  Copyright © 2021 Fast-Devs Project. All rights reserved.
//

import MRPurchaseButton
import SwifterSwift
import UIKit

@objc public protocol MRInAppPurchaseListDelegate: NSObjectProtocol {
    @objc func inAppPurchaseButtonTapped(inAppPurchase: InAppData)
    
    @objc optional func accessoryButtonTappedForRowWith(inAppPurchase: InAppData)
}

open class MRInAppPurchaseList: UIViewController, UITableViewDelegate, UITableViewDataSource {
    open var inAppListView: MRInAppPurchaseList!
    open weak var delegate: MRInAppPurchaseListDelegate?
    
    private var tableView = UITableView()
    private var inAppPurchases: [InAppData] = []
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        inAppListView = self
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.size.width, height: view.size.height), style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false 
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "id_table_cell_in_app_list")
        view = tableView
//        tableView.backgroundColor = UIColor(named: "Table View Backgound Custom Color")
    }
    
//    open override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//    }
    
//    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        tableView.backgroundColor = .systemGray6
//    }
    
    open func setInAppPurchases(_ inAppPurchases: [InAppData]) {
        self.inAppPurchases = inAppPurchases
    }
    
    deinit {
        debugPrint("MRInAppPurchaseList DEINITIALIZATED!!!!")
    }
    
    // MARK: - UITableView
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return loc("INAPP_HEADER")
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inAppPurchases.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id_table_cell_in_app_list", for: indexPath)
        let data = inAppPurchases[indexPath.row]
        
        cell.imageView?.image = data.icon
        cell.imageView?.contentMode = .scaleAspectFit
        cell.textLabel?.text = data.title
        cell.selectionStyle = .none
        
        // info button
        let inAppInfoButton = UIButton(type: .infoLight)
        inAppInfoButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        inAppInfoButton.tintColor = .link
        inAppInfoButton.addTarget(self, action: #selector(inAppInfoButtonTapped), for: .touchUpInside)
        inAppInfoButton.tag = indexPath.row
        
        // purchase button
        let inAppPurchase = PurchaseButton(frame: CGRect(x: 0, y: 0, width: 95, height: 24))
        inAppPurchase.addTarget(self, action: #selector(inAppPurchaseButtonTapped), for: .touchUpInside)
        inAppPurchase.tag = indexPath.row
        if !data.isPurchased {
            inAppPurchase.normalColor = .link
            inAppPurchase.isEnabled = true
        } else {
            inAppPurchase.normalColor = .systemGray
            inAppPurchase.isEnabled = false
        }
        inAppPurchase.confirmationColor = .systemGreen
        inAppPurchase.normalTitle = data.purchaseButtonTitle.uppercased()
        inAppPurchase.confirmationTitle = data.confirmationPurchaseButtonTitle.uppercased()
        
        // accessoryView
        let stackView = UIStackView(arrangedSubviews: [inAppInfoButton, inAppPurchase], axis: .horizontal, spacing: 16, alignment: .center, distribution: .equalSpacing)
        stackView.frame = CGRect(x: 0, y: 0, width: 24 + 16 + 95, height: cell.height)
        cell.accessoryView = stackView
        
        return cell
    }
    
    // MARK: - UIScrollView

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for view in tableView.subviewsRecursive() {
            if view is PurchaseButton {
                let inAppButton = view as! PurchaseButton
                if inAppButton.buttonState == .confirmation {
                    inAppButton.setButtonState(PurchaseButtonState.normal, animated: true)
                }
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction private func inAppInfoButtonTapped(_ button: UIButton) {
        let data = inAppPurchases[button.tag]
        showAlert(title: data.title, message: data.info, buttonTitles: [loc("alert_OKBUTTON")], highlightedButtonIndex: 0)
        delegate?.accessoryButtonTappedForRowWith?(inAppPurchase: data)
    }
    
    @IBAction private func inAppPurchaseButtonTapped(_ button: PurchaseButton) {
        switch button.buttonState {
            case .normal:
                button.setButtonState(.confirmation, animated: true)
            case .confirmation:
                button.setButtonState(.progress, animated: true)
                delegate?.inAppPurchaseButtonTapped(inAppPurchase: inAppPurchases[button.tag])
            case .progress:
                break
            @unknown default:
                break
        }
    }
}
