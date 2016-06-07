//
//  ThemeManager.swift
//  Portfolio
//
//  Created by John Woolsey on 3/3/16.
//  Copyright © 2016 ExtremeBytes Software. All rights reserved.
//


import Foundation
import UIKit


// MARK: - Global Variables

let PortfolioThemeDidUpdateNotificationKey = "PortfolioThemeDidUpdateNotification"


struct ThemeManager {
   
   // MARK: - Enumerations
   
   enum Theme: Int {
      case Dark, Light
      
      var globalThemeColor: UIColor {
         switch self {
         case Dark:
            return UIColor.orangeColor()
         case Light:
            return UIColor.blueColor()
         }
      }
      var mainBackgroundColor: UIColor {
         switch self {
         case Dark:
            return UIColor.blackColor()
         case Light:
            return UIColor.whiteColor()
         }
      }
      var mainForgroundColor: UIColor {
         switch self {
         case Dark:
            return UIColor.whiteColor()
         case Light:
            return UIColor.blackColor()
         }
      }
      var positionBackgroundColor: UIColor {
         switch self {
         case Dark:
            return UIColor.darkGrayColor()
         case Light:
            return veryLightGrayColor
         }
      }
      var positiveChangeColor: UIColor { return darkGreenColor }
      var negativeChangeColor: UIColor { return darkRedColor }
      var noChangeColor: UIColor { return mainForgroundColor }
      var positiveStatusColor: UIColor { return UIColor.grayColor() }
      var negativeStatusColor: UIColor { return darkRedColor }
   }
   
   
   // MARK: - Properties
   
   static private let SelectedThemeKey = "PortfolioSelectedTheme"
   
   static private let darkGreenColor = UIColor(red: 35/255, green: 158/255, blue: 77/255, alpha: 1)
   static private let darkRedColor = UIColor(red: 231/255, green: 35/255, blue: 47/255, alpha: 1)
   static private let veryLightGrayColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
   
   
   // MARK: - Functions

   /**
    Retrieves and returns the current application theme.
    
    - returns: The current application theme.
    */
   static func currentTheme() -> Theme {
      if let storedTheme = NSUserDefaults.standardUserDefaults().valueForKey(SelectedThemeKey)?.integerValue,
         theme = Theme(rawValue: storedTheme)
      {
         return theme
      } else {
         return .Light
      }
   }
   
   
   /**
    Applies the specified application theme.
    
    - parameter theme: The new theme to apply.
    */
   static func applyTheme(theme: Theme) {
      let defaults = NSUserDefaults.standardUserDefaults()
      defaults.setValue(theme.rawValue, forKey: SelectedThemeKey)
      defaults.synchronize()
      
      let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
      
      appDelegate?.window?.tintColor = currentTheme().globalThemeColor
      UICollectionView.appearance().backgroundColor = currentTheme().mainBackgroundColor
      UICollectionViewCell.appearance().backgroundColor = currentTheme().positionBackgroundColor
//      UILabel.appearanceWhenContainedInInstancesOfClasses([PositionViewController.self, PositionCollectionViewCell.self]).textColor = currentTheme().mainForgroundColor  // does not work properly with multiple classes
      UILabel.appearanceWhenContainedInInstancesOfClasses([PositionCollectionViewCell.self]).textColor = currentTheme().mainForgroundColor
      UILabel.appearanceWhenContainedInInstancesOfClasses([PositionViewController.self]).textColor = currentTheme().mainForgroundColor
      UINavigationBar.appearance().barTintColor = currentTheme().mainBackgroundColor
      UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: currentTheme().mainForgroundColor]
      UITabBar.appearance().barTintColor = currentTheme().mainBackgroundColor

      NSNotificationCenter.defaultCenter().postNotificationName(PortfolioThemeDidUpdateNotificationKey, object: nil)
   }
}
