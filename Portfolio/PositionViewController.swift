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
   
   @IBOutlet weak var scrollView: UIScrollView!
   @IBOutlet weak var contentView: UIView!
   @IBOutlet weak var symbolLabel: UILabel!
   @IBOutlet weak var nameLabel: UILabel!
   @IBOutlet weak var shareCountTitleLabel: UILabel!
   @IBOutlet weak var sharesLabel: UILabel!
   @IBOutlet weak var totalValueTitleLabel: UILabel!
   @IBOutlet weak var valueLabel: UILabel!
   @IBOutlet weak var priceLabel: UILabel!
   @IBOutlet weak var changeLastLabel: UILabel!
   @IBOutlet weak var changeYTDLabel: UILabel!
   @IBOutlet weak var openLabel: UILabel!
   @IBOutlet weak var lowLabel: UILabel!
   @IBOutlet weak var highLabel: UILabel!
   @IBOutlet weak var marketCapLabel: UILabel!
   @IBOutlet weak var volumeLabel: UILabel!
   @IBOutlet weak var statusLabel: UILabel!
   @IBOutlet weak var shareCountLayoutConstraint: NSLayoutConstraint!
   @IBOutlet weak var totalValueLayoutConstraint: NSLayoutConstraint!
   
   var position: Position?
   
   
   // MARK: - Lifecycle
   
   override func viewDidLoad() {
      super.viewDidLoad()
      configure()
      applyTheme()
   }
   
   
   override func viewWillAppear(animated: Bool) {
      super.viewWillAppear(animated)
      
      // Set content width based on platform type
      switch AppCoordinator.sharedInstance.deviceType {
      case .Pad:
         preferredContentSize = contentView.frame.size
      default:
         view.addConstraint(NSLayoutConstraint(item: contentView, attribute: .Width,
            relatedBy: .Equal,
            toItem: view, attribute: .Width,
            multiplier: 1, constant: 0))
      }
   }

   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
   }
   
   
   // MARK: - Configuration
   
   /**
   Configures the view controller.
   */
   private func configure() {
      var displayPosition: Position
      if let localPosition = position {
         displayPosition = localPosition
      } else {
         displayPosition = Position()
      }
      
      if let type = displayPosition.type where type == .WatchList {
         shareCountTitleLabel.text = nil
         totalValueTitleLabel.text = nil
         shareCountLayoutConstraint.constant = 0
         totalValueLayoutConstraint.constant = 0
      }
      
      let changePercentValue = displayPosition.changePercent ?? 0
      switch changePercentValue {
      case _ where changePercentValue < 0:
         changeLastLabel.textColor = ThemeManager.negativeChangeColor
      case _ where changePercentValue > 0:
         changeLastLabel.textColor = ThemeManager.positiveChangeColor
      default:
         changeLastLabel.textColor = ThemeManager.noChangeColor
      }
      let changePercentYTDValue = displayPosition.changePercentYTD ?? 0
      switch changePercentYTDValue {
      case _ where changePercentYTDValue < 0:
         changeYTDLabel.textColor = ThemeManager.negativeChangeColor
      case _ where changePercentYTDValue > 0:
         changeYTDLabel.textColor = ThemeManager.positiveChangeColor
      default:
         changeYTDLabel.textColor = ThemeManager.noChangeColor
      }
      if let status = displayPosition.status where displayPosition.isComplete
         && status.lowercaseString.rangeOfString("success") != nil {
            statusLabel?.textColor = ThemeManager.positiveStatusColor
      } else {
         statusLabel?.textColor = ThemeManager.negativeStatusColor
      }
      
      symbolLabel.text = displayPosition.symbolForDisplay
      nameLabel.text = displayPosition.nameForDisplay
      sharesLabel.text = displayPosition.sharesForDisplay
      valueLabel.text = displayPosition.valueForDisplay
      priceLabel.text = displayPosition.lastPriceForDisplay
      changeLastLabel.text = "\(displayPosition.changeForDisplay) (\(displayPosition.changePercentForDisplay))"
      changeYTDLabel.text = "\(displayPosition.changeYTDForDisplay) (\(displayPosition.changePercentYTDForDisplay))"
      openLabel.text = displayPosition.openForDisplay
      lowLabel.text = displayPosition.lowForDisplay
      highLabel.text = displayPosition.highForDisplay
      marketCapLabel.text = displayPosition.marketCapForDisplay
      volumeLabel.text = displayPosition.volumeForDisplay
      statusLabel.text = displayPosition.statusForDisplay
   }
   
   
   /**
   Applies view controller specific theming.
   */
   private func applyTheme() {
   }
}
