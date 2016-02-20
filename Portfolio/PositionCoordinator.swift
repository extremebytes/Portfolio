//
//  PositionCoordinator.swift
//  Portfolio
//
//  Created by John Woolsey on 2/2/16.
//  Copyright © 2016 ExtremeBytes Software. All rights reserved.
//


import Foundation


class PositionCoordinator {
   
   // MARK: - Properties
   
   static let sharedInstance = PositionCoordinator()  // singleton
   var inputDateFormatter: NSDateFormatter {
      let formatter = NSDateFormatter()
      formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
      return formatter
   }
   var outputDateFormatter: NSDateFormatter {
      let formatter = NSDateFormatter()
      formatter.dateFormat = "MMM dd yyyy HH:mm"
      return formatter
   }
//   var largeNumberFormatter: NSNumberFormatter {
//      let formatter = NSNumberFormatter()
//      formatter.numberStyle = .DecimalStyle
//      return formatter
//   }
   
   
   // MARK: - Lifecycle
   
   private init() {}  // prevents use of default initializer
   
   
   // MARK: - Position Helpers
}