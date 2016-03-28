//
//  PositionViewController.swift
//  Portfolio
//
//  Created by John Woolsey on 3/15/16.
//  Copyright © 2016 ExtremeBytes Software. All rights reserved.
//


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
   
   
   override func viewWillAppear(animated: Bool) {
      super.viewWillAppear(animated)
      
      // Set content width based on platform type
      guard let contentView = contentView else { return }
      switch AppCoordinator.sharedInstance.deviceType {
      case .Pad:
         preferredContentSize = contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
      default:
         view.addConstraint(NSLayoutConstraint(item: contentView, attribute: .Width,
            relatedBy: .Equal,
            toItem: view, attribute: .Width,
            multiplier: 1, constant: 0))
      }
   }
   
   
   override func viewDidAppear(animated: Bool) {
      super.viewDidAppear(animated)
      isViewVisible = true
   }
   
   
   override func viewDidDisappear(animated: Bool) {
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
      if let memberType = position.memberType where memberType == .WatchList {
         shareCountTitleLabel?.text = nil
         totalValueTitleLabel?.text = nil
         shareCountLayoutConstraint?.constant = 0
         totalValueLayoutConstraint?.constant = 0
      }
      
      let changePercentValue = position.changePercent ?? 0
      switch changePercentValue {
      case _ where changePercentValue < 0:
         changeLastLabel?.textColor = ThemeManager.negativeChangeColor
      case _ where changePercentValue > 0:
         changeLastLabel?.textColor = ThemeManager.positiveChangeColor
      default:
         changeLastLabel?.textColor = ThemeManager.noChangeColor
      }
      let changePercentYTDValue = position.changePercentYTD ?? 0
      switch changePercentYTDValue {
      case _ where changePercentYTDValue < 0:
         changeYTDLabel?.textColor = ThemeManager.negativeChangeColor
      case _ where changePercentYTDValue > 0:
         changeYTDLabel?.textColor = ThemeManager.positiveChangeColor
      default:
         changeYTDLabel?.textColor = ThemeManager.noChangeColor
      }
      if let status = position.status where position.isComplete
         && status.lowercaseString.rangeOfString("success") != nil {
            statusLabel?.textColor = ThemeManager.positiveStatusColor
      } else {
         statusLabel?.textColor = ThemeManager.negativeStatusColor
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
   }
}
