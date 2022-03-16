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

import SwifterSwift
import UIKit
import MRPurchaseButton

@objc public protocol MRInAppPurchaseListDelegate: NSObjectProtocol {
    @objc func inAppPurchaseButtonTapped(inAppPurchase: InAppData)
    
    @objc optional func accessoryButtonTappedForRowWith(inAppPurchase: InAppData)
    @objc optional func swipeDownDismiss(controller: MRInAppPurchaseList)
}

open class MRInAppPurchaseList: UITableViewController {
    open weak var delegate: MRInAppPurchaseListDelegate?
    
    private var inAppPurchases: [InAppData] = []
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "id_table_cell_in_app_list")
//        tableView.backgroundColor = UIColor(named: "Table View Backgound Custom Color")
    }
    
//    open override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//    }
    
//    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        tableView.backgroundColor = .systemGray6
//    }
    
    public init(inAppPurchases: [InAppData]) {
        self.inAppPurchases = inAppPurchases
        super.init(style: .insetGrouped)
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint("MRInAppPurchaseList DEINITIALIZATED!!!!")
    }
    
    // MARK: - UITableView
    
    override open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return loc("settings_INAPPHEADERTEXT")
    }
    
    override open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    override open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inAppPurchases.count
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id_table_cell_in_app_list", for: indexPath)
        let data = inAppPurchases[indexPath.row]
        
        cell.imageView?.image = data.icon
        cell.imageView?.contentMode = .scaleAspectFit
        cell.textLabel?.text = data.title
        cell.accessoryType = .detailDisclosureButton
        cell.selectionStyle = UITableViewCell.SelectionStyle.none

        let inAppButton = PurchaseButton(frame: .zero)
        inAppButton.addTarget(self, action: #selector(inAppPurchaseButtonTapped), for: UIControl.Event.touchUpInside)
        inAppButton.tag = indexPath.row
        if !data.isPurchased {
            inAppButton.normalColor = UIColor.link
            inAppButton.isEnabled = true
        } else {
            inAppButton.normalColor = UIColor.systemGray
            inAppButton.isEnabled = false
        }
        inAppButton.confirmationColor = UIColor.systemGreen
        inAppButton.normalTitle = data.purchaseButtonTitle.uppercased()
        inAppButton.confirmationTitle = data.confirmationPurchaseButtonTitle.uppercased()
        inAppButton.sizeToFit()
        inAppButton.width = 95
        cell.accessoryView = inAppButton
        
        return cell
    }
    
//    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        delegate?.didSelectRowAt(tableView: tableView, indexPath: indexPath, filteredLocation: filteredLocation)
//        delegate?.swipeDownDismiss?(controller: self)
//    }
    
    override open func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let data = inAppPurchases[indexPath.row]
        showAlert(title: data.title, message: data.info, buttonTitles: [loc("alert_OKBUTTON")], highlightedButtonIndex: 0)
        delegate?.accessoryButtonTappedForRowWith?(inAppPurchase: data)
    }
    
    // MARK: - UIScrollView

    override open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for view in tableView.subviewsRecursive() {
            if view is PurchaseButton {
                let inAppButton = view as! PurchaseButton
                if inAppButton.buttonState == .confirmation {
                    inAppButton.setButtonState(PurchaseButtonState.normal, animated: true)
                }
            }
        }
    }
    
    // MARK: - Private functions
    
//    private func swipeDownDismiss(completion: (() -> Void)? = nil){
//        delegate?.swipeDownDismiss?(controller: self)
//    }
    
    @IBAction func inAppPurchaseButtonTapped(_ sender: PurchaseButton) {
        delegate?.inAppPurchaseButtonTapped(inAppPurchase: inAppPurchases[sender.tag])
    }
}
