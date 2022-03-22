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
//  Copyright © 2021-2022 Fast-Devs Project. All rights reserved.
//

import MRInAppPurchaseButton
import SwifterSwift
import UIKit

@objc public protocol MRInAppPurchaseViewDelegate: NSObjectProtocol {
    @objc func inAppPurchaseButtonTapped(inAppPurchase: InAppPurchaseData)
    @objc optional func accessoryButtonTappedForRowWith(inAppPurchase: InAppPurchaseData)
}

open class MRInAppPurchaseView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    open var inAppPurchaseView: MRInAppPurchaseView!
    open weak var delegate: MRInAppPurchaseViewDelegate?
    
    private var tableView = UITableView()
    private var inAppPurchases: [InAppPurchaseData] = []
    private var cellTitleFont: UIFont?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        inAppPurchaseView = self
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.size.width, height: view.size.height), style: .insetGrouped)
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
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
        let accessoryView = UIStackView()

        // icon
        cell.imageView?.image = data.icon
        cell.imageView?.contentMode = .scaleAspectFit
        cell.imageView?.borderWidth = 1
        cell.imageView?.cornerRadius = 6
        cell.imageView?.borderColor = data.iconBorderColor
        cell.imageView?.width = 27
        cell.imageView?.height = 27

        // text
        cell.textLabel?.text = data.title
        cell.textLabel?.font = cellTitleFont
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.minimumScaleFactor = 0.6
        
        // info button
        if data.wiki != nil {
            let inAppInfoButton = UIButton(type: .infoLight)
            inAppInfoButton.frame = CGRect(x: 0, y: 0, width: 24, height: cell.height)
            inAppInfoButton.tintColor = .link
            inAppInfoButton.addTarget(self, action: #selector(inAppInfoButtonTapped), for: .touchUpInside)
            inAppInfoButton.tag = indexPath.row
            inAppInfoButton.showsTouchWhenHighlighted = true
            accessoryView.addArrangedSubview(inAppInfoButton)
        }
        
        // purchase button
        let inAppPurchase = PurchaseButton(frame: CGRect(x: 0, y: 0, width: 95, height: cell.height))
        inAppPurchase.addTarget(self, action: #selector(inAppPurchaseButtonTapped), for: .touchUpInside)
        inAppPurchase.tag = indexPath.row
        inAppPurchase.accessibilityIdentifier = data.id
        if !data.isPurchasedDisable {
            inAppPurchase.normalColor = .link
            inAppPurchase.isEnabled = true
        } else {
            inAppPurchase.normalColor = .systemGray
            inAppPurchase.isEnabled = false
        }
        inAppPurchase.confirmationColor = .systemGreen
        inAppPurchase.normalTitle = data.purchaseButtonTitle.uppercased()
        inAppPurchase.confirmationTitle = Utils.locFromBundle("CONFIRM").uppercased()
        accessoryView.addArrangedSubview(inAppPurchase)

        // accessoryView
        var accessoryViewWidth: CGFloat = -16
        for view in accessoryView.arrangedSubviews {
            accessoryViewWidth += view.width
            accessoryViewWidth += 16
        }
        accessoryView.frame = CGRect(x: 0, y: 0, width: accessoryViewWidth, height: cell.height)
        accessoryView.axis = .horizontal
        accessoryView.spacing = 16
        accessoryView.alignment = .center
        accessoryView.distribution = .fill
        cell.accessoryView = accessoryView
        
        cell.selectionStyle = .none
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

    open func setInAppPurchases(_ inAppPurchases: [InAppPurchaseData]) {
        self.inAppPurchases = inAppPurchases
    }
    
    open func setConfirmationStateToPurchase(_ inAppPurchase: InAppPurchaseData) {
        for view in tableView.subviewsRecursive() {
            if view is PurchaseButton {
                let inAppButton = view as! PurchaseButton
                if view.accessibilityIdentifier == inAppPurchase.id {
                    inAppButton.setButtonState(PurchaseButtonState.confirmation, animated: true)
                    break
                }
            }
        }
    }

    open func setProgressStateToPurchase(_ inAppPurchase: InAppPurchaseData) {
        for view in tableView.subviewsRecursive() {
            if view is PurchaseButton {
                let inAppButton = view as! PurchaseButton
                if view.accessibilityIdentifier == inAppPurchase.id {
                    inAppButton.setButtonState(PurchaseButtonState.progress, animated: true)
                    break
                }
            }
        }
    }
    
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
    
    open func setTitleFont(_ font: UIFont) {
        cellTitleFont = font
    }
    
    open func reloadData() {
        tableView.reloadData()
    }
    
    /// To use only when you want embeed this table inside another table
    open func hideTableViewMargins() {
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))

        tableView.layoutMargins = .init(top: 0.0, left: 0.1, bottom: 0.0, right: 0.1)
        tableView.separatorInset = tableView.layoutMargins
        
        tableView.layoutIfNeeded()
    }

    // MARK: - IBActions
    
    @IBAction private func inAppInfoButtonTapped(_ button: UIButton) {
        setNomalStateToPurchaseButtonsFromConfirmation()
        
        let data = inAppPurchases[button.tag]
        if let wiki = data.wiki {
            Utils.showAttributedAlert(text: wiki,
                                      textAlignment: data.wikiTextAlignment,
                                      alert: showAlert(title: data.title, message: nil, buttonTitles: [Utils.loc("OKBUTTON")], highlightedButtonIndex: 0))
        }
        
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
