//
//  PositionViewController.swift
//  Portfolio
//
//  Created by John Woolsey on 3/15/16.
//  Copyright © 2016 ExtremeBytes Software. All rights reserved.
//


// Note: Does not need to listen for PortfolioThemeDidUpdateNotification since controller is never visible upon theme changes.


import UIKit


class PositionViewController: UIViewController {
   
   // MARK: - Properties
   
   var position = Position()
   var isViewVisible = false
   
   @IBOutlet private weak var scrollView: UIScrollView?
   @IBOutlet private weak var contentView: UIView?
   @IBOutlet private weak var symbolLabel: UILabel?
   @IBOutlet private weak var nameLabel: UILabel?
   @IBOutlet private weak var shareCountTitleLabel: UILabel?
   @IBOutlet private weak var sharesLabel: UILabel?
   @IBOutlet private weak var totalValueTitleLabel: UILabel?
   @IBOutlet private weak var valueLabel: UILabel?
   @IBOutlet private weak var priceLabel: UILabel?
   @IBOutlet private weak var changeLastLabel: UILabel?
   @IBOutlet private weak var changeYTDLabel: UILabel?
   @IBOutlet private weak var openLabel: UILabel?
   @IBOutlet private weak var lowLabel: UILabel?
   @IBOutlet private weak var highLabel: UILabel?
   @IBOutlet private weak var marketCapLabel: UILabel?
   @IBOutlet private weak var volumeLabel: UILabel?
   @IBOutlet private weak var statusLabel: UILabel?
   @IBOutlet private weak var shareCountLayoutConstraint: NSLayoutConstraint?
   @IBOutlet private weak var totalValueLayoutConstraint: NSLayoutConstraint?
   
   
   // MARK: - Lifecycle
   
   override func viewDidLoad() {
      super.viewDidLoad()
      configure()
      applyTheme()
   }
   
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      // Set content width based on platform type
      guard let contentView = contentView else { return }
      switch AppCoordinator.sharedInstance.deviceType {
      case .pad:
         preferredContentSize = contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
      default:
         view.addConstraint(NSLayoutConstraint(item: contentView, attribute: .width,
            relatedBy: .equal,
            toItem: view, attribute: .width,
            multiplier: 1, constant: 0))
      }
   }
   
   
   override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      isViewVisible = true
   }
   
   
   override func viewDidDisappear(_ animated: Bool) {
      super.viewDidDisappear(animated)
      isViewVisible = false
   }
   
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
   }
   
   
   // MARK: - Configuration
   
   /**
   Configures the view controller.
   */
   private func configure() {
      if let memberType = position.memberType, memberType == .WatchList {
         shareCountTitleLabel?.text = nil
         totalValueTitleLabel?.text = nil
         shareCountLayoutConstraint?.constant = 0
         totalValueLayoutConstraint?.constant = 0
      }
      
      symbolLabel?.text = position.symbolForDisplay
      nameLabel?.text = position.nameForDisplay
      sharesLabel?.text = position.sharesForDisplay
      valueLabel?.text = position.valueForDisplay
      priceLabel?.text = position.lastPriceForDisplay
      changeLastLabel?.text = "\(position.changeForDisplay) (\(position.changePercentForDisplay))"
      changeYTDLabel?.text = "\(position.changeYTDForDisplay) (\(position.changePercentYTDForDisplay))"
      openLabel?.text = position.openForDisplay
      lowLabel?.text = position.lowForDisplay
      highLabel?.text = position.highForDisplay
      marketCapLabel?.text = position.marketCapForDisplay
      volumeLabel?.text = position.volumeForDisplay
      statusLabel?.text = position.statusForDisplay
   }
   
   
   /**
   Applies view controller specific theming.
   */
   private func applyTheme() {
      view.backgroundColor = ThemeManager.currentTheme().mainBackgroundColor
      contentView?.backgroundColor = ThemeManager.currentTheme().mainBackgroundColor
      
      // Update position change color
      let changePercentValue = position.changePercent ?? 0
      switch changePercentValue {
      case _ where changePercentValue < 0:
         changeLastLabel?.textColor = ThemeManager.currentTheme().negativeChangeColor
      case _ where changePercentValue > 0:
         changeLastLabel?.textColor = ThemeManager.currentTheme().positiveChangeColor
      default:
         changeLastLabel?.textColor = ThemeManager.currentTheme().noChangeColor
      }
      let changePercentYTDValue = position.changePercentYTD ?? 0
      switch changePercentYTDValue {
      case _ where changePercentYTDValue < 0:
         changeYTDLabel?.textColor = ThemeManager.currentTheme().negativeChangeColor
      case _ where changePercentYTDValue > 0:
         changeYTDLabel?.textColor = ThemeManager.currentTheme().positiveChangeColor
      default:
         changeYTDLabel?.textColor = ThemeManager.currentTheme().noChangeColor
      }

      // Update position status color
      if position.isComplete,
         let status = position.status, status.lowercased().range(of: "success") != nil {
         statusLabel?.textColor = ThemeManager.currentTheme().positiveStatusColor
      } else {
         statusLabel?.textColor = ThemeManager.currentTheme().negativeStatusColor
      }
   }
}
