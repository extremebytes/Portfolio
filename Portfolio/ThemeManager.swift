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
      case dark, light
      
      var globalThemeColor: UIColor {
         switch self {
         case .dark:
            return UIColor.orange
         case .light:
            return UIColor.blue
         }
      }
      var mainBackgroundColor: UIColor {
         switch self {
         case .dark:
            return UIColor.black
         case .light:
            return UIColor.white
         }
      }
      var mainForgroundColor: UIColor {
         switch self {
         case .dark:
            return UIColor.white
         case .light:
            return UIColor.black
         }
      }
      var positionBackgroundColor: UIColor {
         switch self {
         case .dark:
            return UIColor.darkGray
         case .light:
            return veryLightGrayColor
         }
      }
      var positiveChangeColor: UIColor { return darkGreenColor }
      var negativeChangeColor: UIColor { return darkRedColor }
      var noChangeColor: UIColor { return mainForgroundColor }
      var positiveStatusColor: UIColor { return UIColor.gray }
      var negativeStatusColor: UIColor { return darkRedColor }
   }
   
   
   // MARK: - Properties
   
   /// Retrieves and returns the current application theme.
   static var currentTheme: Theme {
      if let storedTheme = UserDefaults.standard.value(forKey: SelectedThemeKey) as? Int,
         let theme = Theme(rawValue: storedTheme) {
         return theme
      } else {
         return .light
      }
   }
   
   static private let SelectedThemeKey = "PortfolioSelectedTheme"
   static private let darkGreenColor = UIColor(red: 35/255, green: 158/255, blue: 77/255, alpha: 1)
   static private let darkRedColor = UIColor(red: 231/255, green: 35/255, blue: 47/255, alpha: 1)
   static private let veryLightGrayColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
   
   
   // MARK: - Functions
   
   /**
    Applies the specified application theme.
    
    - parameter theme: The new theme to apply.
    */
   static func applyTheme(_ theme: Theme) {
      let defaults = UserDefaults.standard
      defaults.setValue(theme.rawValue, forKey: SelectedThemeKey)
      defaults.synchronize()
      
      let appDelegate = UIApplication.shared.delegate as? AppDelegate
      
      appDelegate?.window?.tintColor = currentTheme.globalThemeColor
      UICollectionView.appearance().backgroundColor = currentTheme.mainBackgroundColor
      UICollectionViewCell.appearance().backgroundColor = currentTheme.positionBackgroundColor
      // TODO: The following line does not work as expected; had to break out classes
//      UILabel.appearance(whenContainedInInstancesOf: [PositionCollectionViewCell.self, PositionViewController.self]).textColor = currentTheme.mainForgroundColor
      UILabel.appearance(whenContainedInInstancesOf: [PositionCollectionViewCell.self]).textColor =
         currentTheme.mainForgroundColor
      UILabel.appearance(whenContainedInInstancesOf: [PositionViewController.self]).textColor =
         currentTheme.mainForgroundColor
      UINavigationBar.appearance().barTintColor = currentTheme.mainBackgroundColor
      UINavigationBar.appearance().titleTextAttributes =
         [NSAttributedStringKey.foregroundColor.rawValue: currentTheme.mainForgroundColor]
      UITabBar.appearance().barTintColor = currentTheme.mainBackgroundColor
      
      NotificationCenter.default.post(name: Notification.Name(rawValue: PortfolioThemeDidUpdateNotificationKey),
                                      object: nil)
   }
}
