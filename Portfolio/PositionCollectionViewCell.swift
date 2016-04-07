//
//  PositionCollectionViewCell.swift
//  Portfolio
//
//  Created by John Woolsey on 1/26/16.
//  Copyright © 2016 ExtremeBytes Software. All rights reserved.
//


import UIKit


class PositionCollectionViewCell: UICollectionViewCell {
   
   // MARK: - Properties
   
   var symbol: String? {
      return symbolLabel?.text
   }
   
   @IBOutlet private weak var symbolLabel: UILabel?
   @IBOutlet private weak var nameLabel: UILabel?
   @IBOutlet private weak var quoteLabel: UILabel?
   @IBOutlet private weak var changeLabel: UILabel?
   @IBOutlet private weak var valueLabel: UILabel?
   @IBOutlet private weak var statusLabel: UILabel?
   @IBOutlet private weak var valueLayoutConstraint: NSLayoutConstraint?
   
   
   // MARK: - Lifecycle
   
   override func awakeFromNib() {
      super.awakeFromNib()
      applyTheme()
   }
   
   
   // MARK: - Configuration
   
   /**
   Applies view specific theming.
   */
   private func applyTheme() {
      backgroundColor = ThemeManager.positionBackgroundColor
   }
   
   
   /**
    Configures the cell for display.
    
    - parameter position: The position used for display configuration.
    */
   func configure(with position: Position) {
      symbolLabel?.text = position.symbolForDisplay
      nameLabel?.text = position.nameForDisplay
      quoteLabel?.text = position.lastPriceForDisplay
      changeLabel?.text = position.changePercentForDisplay
      let changePercentValue = position.changePercent ?? 0
      switch changePercentValue {
      case _ where changePercentValue < 0:
         changeLabel?.textColor = ThemeManager.negativeChangeColor
      case _ where changePercentValue > 0:
         changeLabel?.textColor = ThemeManager.positiveChangeColor
      default:
         changeLabel?.textColor = ThemeManager.noChangeColor
      }
      let memberType = position.memberType ?? .WatchList
      switch memberType {
      case .Portfolio:
         valueLabel?.text = position.valueForDisplay
         valueLayoutConstraint?.constant = PositionCoordinator.spacerSize.height
      case .WatchList:
         valueLabel?.text = nil
         valueLayoutConstraint?.constant = 0
      }
      if let status = position.status where position.isComplete
         && status.lowercaseString.rangeOfString("success") != nil {
         statusLabel?.textColor = ThemeManager.positiveStatusColor
      } else {
         statusLabel?.textColor = ThemeManager.negativeStatusColor
      }
      statusLabel?.text = position.statusForDisplay
   }
}
