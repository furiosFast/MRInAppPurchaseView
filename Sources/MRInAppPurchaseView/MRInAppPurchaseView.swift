//
//  MRInAppPurchaseView.swift
//  MRInAppPurchaseView
//
//  Created by Marco Ricca on 11/09/2021
//
//  Created for MRInAppPurchaseView in 11/09/2021
//  Using Swift 5.4
//  Running on macOS 11.5.2
//
//  Copyright © 2021 Fast-Devs Project. All rights reserved.
//

import MRInAppPurchaseButton
import SwifterSwift
import UIKit

@objc public protocol MRInAppPurchaseViewDelegate: NSObjectProtocol {
    @objc func inAppPurchaseButtonTapped(inAppPurchase: InAppData)
    @objc optional func accessoryButtonTappedForRowWith(inAppPurchase: InAppData)
}

open class MRInAppPurchaseView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    open var inAppView: MRInAppPurchaseView!
    open weak var delegate: MRInAppPurchaseViewDelegate?
    
    private var tableView = UITableView()
    private var inAppPurchases: [InAppData] = []
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        inAppView = self
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.size.width, height: view.size.height), style: .insetGrouped)
        tableView.backgroundColor = UIColor(named: "Table View Backgound Custom Color")
        tableView.tintColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "id_table_cell_in_app_list")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        view = tableView
    }
    
    deinit {
        debugPrint("MRInAppPurchaseView DEINITIALIZATED!!!!")
    }
    
    // MARK: - UITableView
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 49
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
        
        // icon
        cell.imageView?.image = data.icon
        cell.imageView?.contentMode = .scaleAspectFit
        cell.imageView?.borderWidth = 1
        cell.imageView?.cornerRadius = 6
        cell.imageView?.borderColor = .lightGray
        cell.imageView?.width = 27
        cell.imageView?.height = 27

        // text
        cell.textLabel?.text = data.title
        
        // info button
        let inAppInfoButton = UIButton(type: .infoLight)
        inAppInfoButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        inAppInfoButton.tintColor = .link
        inAppInfoButton.addTarget(self, action: #selector(inAppInfoButtonTapped), for: .touchUpInside)
        inAppInfoButton.tag = indexPath.row
        if data.info.isEmpty {
            inAppInfoButton.alpha = 0.0
            inAppInfoButton.isUserInteractionEnabled = false
        }
        
        // purchase button
        let inAppPurchase = PurchaseButton(frame: CGRect(x: 0, y: 0, width: 95, height: 24))
        inAppPurchase.addTarget(self, action: #selector(inAppPurchaseButtonTapped), for: .touchUpInside)
        inAppPurchase.tag = indexPath.row
        if !data.isPurchasedDisable {
            inAppPurchase.normalColor = .link
            inAppPurchase.isEnabled = true
        } else {
            inAppPurchase.normalColor = .systemGray
            inAppPurchase.isEnabled = false
        }
        inAppPurchase.confirmationColor = .systemGreen
        inAppPurchase.normalTitle = data.purchaseButtonTitle.uppercased()
        inAppPurchase.confirmationTitle = locFromBundle("CONFIRM").uppercased()
        
        // accessoryView
        let stackView = UIStackView(arrangedSubviews: [inAppInfoButton, inAppPurchase], axis: .horizontal, spacing: 16, alignment: .center, distribution: .fill)
        stackView.frame = CGRect(x: 0, y: 0, width: 24 + 16 + 95, height: cell.height)
        cell.accessoryView = stackView
        
        cell.selectionStyle = .none
        cell.backgroundColor = colorFromBundle(named: "Table View Cell Backgound Custom Color")
        cell.tintColor = .white
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setNomalStateToPurchaseButtonsFromConfirmation()
    }
    
    // MARK: - UIScrollView

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setNomalStateToPurchaseButtonsFromConfirmation()
    }
    
    // MARK: - Public functions

    open func setNomalStateToPurchaseButtonsFromConfirmation() {
        for view in tableView.subviewsRecursive() {
            if view is PurchaseButton {
                let inAppButton = view as! PurchaseButton
                if inAppButton.buttonState == .confirmation {
                    inAppButton.setButtonState(PurchaseButtonState.normal, animated: true)
                }
            }
        }
    }
    
    open func setNomalStateToPurchaseButtonsFromProgress() {
        for view in tableView.subviewsRecursive() {
            if view is PurchaseButton {
                let inAppButton = view as! PurchaseButton
                if inAppButton.buttonState == .progress {
                    inAppButton.setButtonState(PurchaseButtonState.normal, animated: true)
                }
            }
        }
    }
    
    open func setInAppPurchases(_ inAppPurchases: [InAppData]) {
        self.inAppPurchases = inAppPurchases
    }
    
    open func reloadData() {
        tableView.reloadData()
    }
    
    /// Public function for remove all tableView margins
    /// To use when you want embeed this table inside another table
    open func hideTableViewMargins() {
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))

        tableView.layoutMargins = .init(top: 0.0, left: 4.0, bottom: 0.0, right: 4.0)
        tableView.separatorInset = tableView.layoutMargins
        
        tableView.layoutIfNeeded()
    }

    // MARK: - IBActions
    
    @IBAction private func inAppInfoButtonTapped(_ button: UIButton) {
        setNomalStateToPurchaseButtonsFromConfirmation()
        
        let data = inAppPurchases[button.tag]
        showAlert(title: data.title, message: data.info, buttonTitles: [locFromBundle("OKBUTTON")], highlightedButtonIndex: 0)
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
