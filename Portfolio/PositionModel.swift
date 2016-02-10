//
//  PositionModel.swift
//  Portfolio
//
//  Created by John Woolsey on 1/27/16.
//  Copyright © 2016 ExtremeBytes Software. All rights reserved.
//


import Foundation


/**
Investment position model.
*/
struct Position {
   // Standard values
   var status: String?
   var symbol: String?
   var name: String?
   var lastPrice: Double?
   var change: Double?
   var changePercent: Double?
   var timeStamp: String?
   var marketCap: Double?
   var volume: Double?
   var changeYTD: Double?
   var changePercentYTD: Double?
   var high: Double?
   var low: Double?
   var open: Double?
   
   // Display values
   var statusForDisplay: String {
      if isEmpty {
         return "No Data"
      } else if !isComplete {
         return "Incomplete Data"
      } else if let status = status where status.lowercaseString.rangeOfString("success") != nil {
         return timeStampForDisplay
      } else {
         return "Unknown Status"
      }
   }
   var symbolForDisplay: String {
      if let symbol = symbol where !symbol.isEmpty {
         return symbol
      } else {
         return "Unknown"
      }
   }
   var nameForDisplay: String {
      return name ?? ""
   }
   var lastPriceForDisplay: String {
      if let lastPrice = lastPrice {
         return String(format: "%.2f", lastPrice)
      } else {
         return ""
      }
   }
   var changeForDisplay: String {
      if let change = change {
         return String(format: "%.2f", change)
      } else {
         return ""
      }
   }
   var changePercentForDisplay: String {
      if let changePercent = changePercent {
         return String(format: "%.2f%%", changePercent)
      } else {
         return ""
      }
   }
   var timeStampForDisplay: String {
      let inputDateFormatter = PositionCoordinator.sharedInstance.inputDateFormatter
      let outputDateFormatter = PositionCoordinator.sharedInstance.outputDateFormatter
      if let timeStamp = timeStamp,
         inputDate = inputDateFormatter.dateFromString(timeStamp) {
            return outputDateFormatter.stringFromDate(inputDate)
      } else {
         return "Unknown Status"
      }
   }
   var marketCapForDisplay: String {
      if let marketCap = marketCap {
         return String(format: "%.2fB", marketCap/1e9)
      } else {
         return ""
      }
   }
   var volumeForDisplay: String {
      if let volume = volume {
         return String(format: "%.2fM", volume/1e6)
      } else {
         return ""
      }
   }
   var changeYTDForDisplay: String {
      if let changeYTD = changeYTD {
         return String(format: "%.2f", changeYTD)
      } else {
         return ""
      }
   }
   var changePercentYTDForDisplay: String {
      if let changePercentYTD = changePercentYTD {
         return String(format: "%.2f%%", changePercentYTD)
      } else {
         return ""
      }
   }
   var highForDisplay: String {
      if let high = high {
         return String(format: "%.2f", high)
      } else {
         return ""
      }
   }
   var lowForDisplay: String {
      if let low = low {
         return String(format: "%.2f", low)
      } else {
         return ""
      }
   }
   var openForDisplay: String {
      if let open = open {
         return String(format: "%.2f", open)
      } else {
         return ""
      }
   }

   // Model state
   var isEmpty: Bool {
      return status == nil && name == nil && symbol == nil && lastPrice == nil && change == nil
      && changePercent == nil && timeStamp == nil && marketCap == nil && volume == nil
      && changeYTD == nil && changePercentYTD == nil && high == nil && low == nil && open == nil
   }
   var isComplete: Bool {
      return !(status == nil || name == nil || symbol == nil || lastPrice == nil || change == nil
         || changePercent == nil || timeStamp == nil || marketCap == nil || volume == nil
         || changeYTD == nil || changePercentYTD == nil || high == nil || low == nil || open == nil)
   }
}


extension Position: Equatable {}
/**
 Operator for determining if investment positions are equal.
 
 - parameter lhs: The left hand side position.
 - parameter rhs: The right hand side position.
 
 - returns: True if the positions are equal, otherwise false.
 */
func ==(lhs: Position, rhs: Position) -> Bool {
   return lhs.symbol == rhs.symbol
}
