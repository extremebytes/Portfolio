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
   
   @IBOutlet weak var symbolLabel: UILabel!
   @IBOutlet weak var nameLabel: UILabel!
   @IBOutlet weak var sharesLabel: UILabel!
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
   
   var position: Position?
   
   
   // MARK: - Lifecycle
   
   override func viewDidLoad() {
      super.viewDidLoad()
      configure()
      applyTheme()
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
      
      let changePercentValue = displayPosition.changePercent
      switch changePercentValue {
      case _ where changePercentValue < 0:
         changeLastLabel.textColor = UIColor.redColor()
      case _ where changePercentValue > 0:
         changeLastLabel.textColor = UIColor.greenColor()
      default:
         changeLastLabel.textColor = UIColor.blackColor()
      }
      let changePercentYTDValue = displayPosition.changePercentYTD
      switch changePercentYTDValue {
      case _ where changePercentYTDValue < 0:
         changeYTDLabel.textColor = UIColor.redColor()
      case _ where changePercentYTDValue > 0:
         changeYTDLabel.textColor = UIColor.greenColor()
      default:
         changeYTDLabel.textColor = UIColor.blackColor()
      }
      if let status = displayPosition.status where status.lowercaseString.rangeOfString("success") != nil {
         statusLabel?.textColor = UIColor.darkGrayColor()
      } else {
         statusLabel?.textColor = UIColor.redColor()
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
