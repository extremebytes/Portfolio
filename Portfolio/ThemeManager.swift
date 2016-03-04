//
//  ThemeManager.swift
//  Portfolio
//
//  Created by John Woolsey on 3/3/16.
//  Copyright © 2016 ExtremeBytes Software. All rights reserved.
//


import Foundation
import UIKit


class ThemeManager {
   
   // MARK: - Properties
   
   static let sharedInstance = ThemeManager()  // singleton
   
   let globalThemeColor = UIColor(red: 0.01, green: 0.41, blue: 0.22, alpha: 1.0)

   
   // MARK: - Lifecycle
   
   private init() {}  // prevents use of default initializer
   
}
