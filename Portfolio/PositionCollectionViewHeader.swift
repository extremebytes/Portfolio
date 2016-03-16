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
   }
   
   
   // MARK: - Configuration
   
   /**
   Applies view specific theming.
   */
   private func applyTheme() {
      backgroundColor = ThemeManager.globalThemeColor
   }
}

