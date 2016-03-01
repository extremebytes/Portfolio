//
//  PositionCollectionViewHeader.swift
//  Portfolio
//
//  Created by John Woolsey on 2/23/16.
//  Copyright © 2016 ExtremeBytes Software. All rights reserved.
//


import UIKit


class PositionCollectionViewHeader: UIView /* UICollectionReusableView */ {
   
   override func awakeFromNib() {
      super.awakeFromNib()
      applyTheme()
   }
   
   
   // MARK: - Configuration
   
   /**
   Applies view specific theming.
   */
   func applyTheme() {
      let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
      self.backgroundColor = appDelegate.themeColor
   }
}

