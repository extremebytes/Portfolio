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
   
   private var position: Position?
   
   
   // MARK: - Lifecycle
   
   override func awakeFromNib() {
      super.awakeFromNib()
      applyTheme()
      NotificationCenter.default.addObserver(self, selector: #selector(applyTheme), name: NSNotification.Name(rawValue: PortfolioThemeDidUpdateNotificationKey), object: nil)
   }
   
   
   deinit {
      NotificationCenter.default.removeObserver(self)
   }
   
   
   // MARK: - Configuration
   
   /**
   Applies view specific theming.
   */
   @objc private func applyTheme() {  // @objc required for recognizing method selector signature
      // Update position change color
      let changePercentValue = position?.changePercent ?? 0
      switch changePercentValue {
      case _ where changePercentValue < 0:
         changeLabel?.textColor = ThemeManager.currentTheme().negativeChangeColor
      case _ where changePercentValue > 0:
         changeLabel?.textColor = ThemeManager.currentTheme().positiveChangeColor
      default:
         changeLabel?.textColor = ThemeManager.currentTheme().noChangeColor
      }

      // Update position status color
      if let position = position, position.isComplete,
         let status = position.status, status.lowercased().range(of: "success") != nil {
         statusLabel?.textColor = ThemeManager.currentTheme().positiveStatusColor
      } else {
         statusLabel?.textColor = ThemeManager.currentTheme().negativeStatusColor
      }
   }
   
   
   /**
    Configures the cell for display.
    
    - parameter position: The position used for display configuration.
    */
   func configure(with position: Position) {
      self.position = position
      symbolLabel?.text = position.symbolForDisplay
      nameLabel?.text = position.nameForDisplay
      quoteLabel?.text = position.lastPriceForDisplay
      changeLabel?.text = position.changePercentForDisplay
      let memberType = position.memberType ?? .WatchList
      switch memberType {
      case .Portfolio:
         valueLabel?.text = position.valueForDisplay
         valueLayoutConstraint?.constant = PositionCoordinator.spacerSize.height
      case .WatchList:
         valueLabel?.text = nil
         valueLayoutConstraint?.constant = 0
      }
      statusLabel?.text = position.statusForDisplay
      
      applyTheme()
   }
}
