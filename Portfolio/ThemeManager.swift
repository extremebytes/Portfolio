//
//  ThemeManager.swift
//  Portfolio
//
//  Created by John Woolsey on 3/3/16.
//  Copyright © 2016 ExtremeBytes Software. All rights reserved.
//


import Foundation
import UIKit


struct ThemeManager {
   
   // MARK: - Theme Color Properties
   
   static let globalThemeColor = emeraldGreenColor
   
   static let portfolioBackgroundColor = UIColor.whiteColor()
   static let positionBackgroundColor = veryLightGrayColor
   
   static let positiveChangeColor = darkGreenColor
   static let negativeChangeColor = darkRedColor
   static let noChangeColor = UIColor.blackColor()
   
   static let positiveStatusColor = UIColor.darkGrayColor()
   static let negativeStatusColor = darkRedColor
   
   
   // MARK: - Base Color Properties

   static private let darkGreenColor = UIColor(red: 35/255, green: 158/255, blue: 77/255, alpha: 1)
   static private let darkRedColor = UIColor(red: 231/255, green: 35/255, blue: 47/255, alpha: 1)
   static private let veryLightGrayColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
   static private let emeraldGreenColor = UIColor(red: 3/255, green: 105/255, blue: 56/255, alpha: 1)
}
