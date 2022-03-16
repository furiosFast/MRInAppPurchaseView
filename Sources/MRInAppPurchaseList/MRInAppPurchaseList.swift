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
        return loc("INAPP_HEADER")
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
        cell.selectionStyle = .none
        
        //info button
        let inAppInfoButton = UIButton(type: .infoLight)
        inAppInfoButton.tintColor = .link
        inAppInfoButton.addTarget(self, action: #selector(inAppInfoButtonTapped), for: .touchUpInside)
        inAppInfoButton.tag = indexPath.row
        
        //purchase button
        let inAppPurchase = PurchaseButton(frame: .zero)
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
        inAppPurchase.sizeToFit()
        inAppPurchase.width = 95
        
        //accessoryView
        let stackView = UIStackView()
        stackView.spacing = 16
        stackView.distribution = .equalCentering
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.isUserInteractionEnabled = true
        stackView.addArrangedSubview(inAppInfoButton)
        stackView.addArrangedSubview(inAppPurchase)
        cell.accessoryView = stackView
        
        return cell
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
    
    // MARK: - IBActions
    
    @IBAction func inAppInfoButtonTapped(_ button: UIButton) {
        let data = inAppPurchases[button.tag]
        showAlert(title: data.title, message: data.info, buttonTitles: [loc("alert_OKBUTTON")], highlightedButtonIndex: 0)
        delegate?.accessoryButtonTappedForRowWith?(inAppPurchase: data)
    }
    
    @IBAction func inAppPurchaseButtonTapped(_ button: PurchaseButton) {
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
