//
//  PositionModel.swift
//  Portfolio
//
//  Created by John Woolsey on 1/27/16.
//  Copyright © 2016 ExtremeBytes Software. All rights reserved.
//


import Foundation


// MARK: - Base Position Model

/**
 Base investment position model.
*/
struct Position {
   // JSON data
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
   
   // User data
   var shares: Double = 0
   var type: PositionType?
}


// MARK: - Position State Extension

/**
 Adds state properties to base investment position model.
*/
extension Position {
   var isEmpty: Bool {
      return status == nil && name == nil && symbol == nil && lastPrice == nil
         && change == nil && changePercent == nil && timeStamp == nil && marketCap == nil
         && volume == nil && changeYTD == nil && changePercentYTD == nil && high == nil
         && low == nil && open == nil && shares <= 0
   }
   var isComplete: Bool {
      return !(status == nil || name == nil || symbol == nil || lastPrice == nil
         || change == nil || changePercent == nil || timeStamp == nil || marketCap == nil
         || volume == nil || changeYTD == nil || changePercentYTD == nil || high == nil
         || low == nil || open == nil || type == nil
         || (type == PositionType.Portfolio && shares <= 0))
   }
}


// MARK: - Position Display Extension

/**
 Adds display properties to base investment position model.
*/
extension Position {
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
      if let timeStamp = timeStamp,
         inputDate = PositionCoordinator.sharedInstance.inputDateFormatter.dateFromString(timeStamp) {
            return PositionCoordinator.sharedInstance.outputDateFormatter.stringFromDate(inputDate)
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
   var sharesForDisplay: String {
      if shares > 0 {
         return String(format: "%.2f", shares)
      } else {
         return ""
      }
   }
   var valueForDisplay: String {
      if let lastPrice = lastPrice where shares > 0 {
         return String(format: "%.2f", lastPrice * shares)
      } else {
         return ""
      }
   }
}


// MARK: - Position Equatable Extension

extension Position: Equatable {}
/**
 Operator for determining if investment positions are equal.
 
 - parameter lhs: The left hand side position.
 - parameter rhs: The right hand side position.
 
 - returns: True if the positions are equal, otherwise false.
 */
func ==(lhs: Position, rhs: Position) -> Bool {
   return lhs.symbol == rhs.symbol && lhs.shares == rhs.shares
}


// MARK: - Position JSONParseable Extension

/**
 Adds JSON parsing functionality to base investment position model.
*/
extension Position: JSONParseable {
   static func forJSON(json: AnyObject) -> Position? {
      // Typically would do something like the following to ensure a valid object,
      // however in this case, we are generally okay with missing values.
//      guard let jsonDictionary = json["Data"] as? JSONDictionary,
//         status = jsonDictionary["Status"] as? String,
//         symbol = jsonDictionary["Symbol"] as? String,
//         name = jsonDictionary["Name"] as? String,
//         lastPrice = jsonDictionary["LastPrice"] as? Double
//          where status.lowercaseString.rangeOfString("success") != nil
//         else {
//            return nil
//      }
//      return Position(status: status, symbol: symbol, name: name, lastPrice: lastPrice)
      
      var position = Position()
      
      guard let jsonDictionary = json["Data"] as? JSONDictionary else {
         return position
      }
      
      position.status = jsonDictionary["Status"] as? String
      position.symbol = jsonDictionary["Symbol"] as? String
      position.name = jsonDictionary["Name"] as? String
      position.lastPrice = jsonDictionary["LastPrice"] as? Double
      position.change = jsonDictionary["Change"] as? Double
      position.changePercent = jsonDictionary["ChangePercent"] as? Double
      position.timeStamp = jsonDictionary["Timestamp"] as? String
      position.marketCap = jsonDictionary["MarketCap"] as? Double
      position.volume = jsonDictionary["Volume"] as? Double
      position.changeYTD = jsonDictionary["ChangeYTD"] as? Double
      position.changePercentYTD = jsonDictionary["ChangePercentYTD"] as? Double
      position.high = jsonDictionary["High"] as? Double
      position.low = jsonDictionary["Low"] as? Double
      position.open = jsonDictionary["Open"] as? Double
      
      return position
   }
}


// MARK: - Position CustomStringConvertible Extension

extension Position: CustomStringConvertible {
   var description: String {
      var printString = "Position:"
      printString += "\nSymbol = \(symbolForDisplay)"
      printString += "\nName = \(nameForDisplay)"
      printString += "\nLast Price = \(lastPriceForDisplay)"
      printString += "\nChange = \(changeForDisplay)"
      printString += "\nChange Percent = \(changePercentForDisplay)"
      printString += "\nTime Stamp = \(timeStampForDisplay)"
      printString += "\nMarket Cap = \(marketCapForDisplay)"
      printString += "\nVolume = \(volumeForDisplay)"
      printString += "\nChange YTD = \(changeYTDForDisplay)"
      printString += "\nChange Percent YTD = \(changePercentYTDForDisplay)"
      printString += "\nHigh = \(highForDisplay)"
      printString += "\nLow = \(lowForDisplay)"
      printString += "\nOpen = \(openForDisplay)"
      printString += "\nShares = \(sharesForDisplay)"
      printString += "\nTotal Value = \(valueForDisplay)"
      if let type = type {
         printString += "\nPosition Type = \(type)"
      } else {
         printString += "\nPosition Type = Unknown"
      }
      printString += "\nStatus = \(statusForDisplay)"
      printString += "\nEmpty = \(isEmpty)"
      printString += "\nComplete = \(isComplete)"
      return printString
   }
}


// MARK: - Position CustomDebugStringConvertible Extension

extension Position: CustomDebugStringConvertible {
   var debugDescription: String {
      return description
   }
}
