//
//  PositionCollectionViewHeader.swift
//  Portfolio
//
//  Created by John Woolsey on 2/23/16.
//  Copyright © 2016 ExtremeBytes Software. All rights reserved.
//


import UIKit


class PositionCollectionViewHeader: UIView {
   
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
   @objc private func applyTheme() {
      backgroundColor = ThemeManager.currentTheme.globalThemeColor
   }
}

