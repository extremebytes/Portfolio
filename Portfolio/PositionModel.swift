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
   var changeYTD: Double?  // December 31st closing price
   var changePercentYTD: Double?
   var high: Double?
   var low: Double?
   var open: Double?
   
   // User data
   var shares: Double?
   var memberType: PositionMemberType?
}


// MARK: - Position State Extension

/**
 Adds state properties to base investment position model.
 */
extension Position {
   var isEmpty: Bool {
      return status == nil && symbol == nil && name == nil && lastPrice == nil
         && change == nil && changePercent == nil && timeStamp == nil && marketCap == nil
         && volume == nil && changeYTD == nil && changePercentYTD == nil && high == nil
         && low == nil && open == nil && shares == nil && memberType == nil
   }
   var isComplete: Bool {
      if let status = status, !status.isEmpty,
         let symbol = symbol, !symbol.isEmpty,
         let name = name, !name.isEmpty,
         let lastPrice = lastPrice, lastPrice.isFinite,
         let change = change, change.isFinite,
         let changePercent = changePercent, changePercent.isFinite,
         let timeStamp = timeStamp, !timeStamp.isEmpty,
         let marketCap = marketCap, marketCap.isFinite,
         let volume = volume, volume.isFinite,
         let changeYTD = changeYTD, changeYTD.isFinite,
         let changePercentYTD = changePercentYTD, changePercentYTD.isFinite,
         let high = high, high.isFinite,
         let low = low, low.isFinite,
         let open = open, open.isFinite,
         let memberType = memberType,
         ((memberType == .portfolio && shares != nil && shares! >= 0.0) || memberType == .watchList) {
         return true
      } else {
         return false
      }
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
      } else if let status = status, status.lowercased().range(of: "success") != nil {
         return timeStampForDisplay
      } else {
         return "Unknown Status"
      }
   }
   var symbolForDisplay: String {
      if let symbol = symbol, !symbol.isEmpty {
         return symbol
      } else {
         return "Unknown"
      }
   }
   var nameForDisplay: String {
      return name ?? ""
   }
   var lastPriceForDisplay: String {
      if let lastPrice = lastPrice, lastPrice.isFinite,
         let lastPriceString = PositionCoordinator.dollarNumberFormatter.string(from:
            NSNumber(value: lastPrice as Double)),
         !lastPriceString.isEmpty {
         return lastPriceString
      } else {
         return ""
      }
   }
   var changeForDisplay: String {
      if let change = change, change.isFinite,
         let changeString = PositionCoordinator.dollarNumberFormatter.string(from: NSNumber(value: change as Double)),
         !changeString.isEmpty {
         return changeString
      } else {
         return ""
      }
   }
   var changePercentForDisplay: String {
      if let changePercent = changePercent, changePercent.isFinite {
         return String(format: "%.2f%%", changePercent)
      } else {
         return ""
      }
   }
   var timeStampForDisplay: String {
      if let timeStamp = timeStamp,
         let inputDate = PositionCoordinator.inputDateFormatter.date(from: timeStamp) {
         return PositionCoordinator.outputDateFormatter.string(from: inputDate)
      } else {
         return "Unknown Status"
      }
   }
   var marketCapForDisplay: String {
      if let marketCap = marketCap, marketCap.isFinite {
         return String(format: "%.2fB", marketCap/1e9)
      } else {
         return ""
      }
   }
   var volumeForDisplay: String {
      if let volume = volume, volume.isFinite {
         return String(format: "%.2fM", volume/1e6)
      } else {
         return ""
      }
   }
   var changeYTDForDisplay: String {
      if let changeYTD = changeYTD, changeYTD.isFinite,
         let lastPrice = lastPrice, lastPrice.isFinite,
         let changeYTDString = PositionCoordinator.dollarNumberFormatter.string(from:
            NSNumber(value: lastPrice - changeYTD as Double)),
         !changeYTDString.isEmpty {
         return changeYTDString
      } else {
         return ""
      }
   }
   var changePercentYTDForDisplay: String {
      if let changePercentYTD = changePercentYTD, changePercentYTD.isFinite {
         return String(format: "%.2f%%", changePercentYTD)
      } else {
         return ""
      }
   }
   var highForDisplay: String {
      if let high = high, high.isFinite,
         let highString = PositionCoordinator.dollarNumberFormatter.string(from: NSNumber(value: high as Double)),
         !highString.isEmpty {
         return highString
      } else {
         return ""
      }
   }
   var lowForDisplay: String {
      if let low = low, low.isFinite,
         let lowString = PositionCoordinator.dollarNumberFormatter.string(from: NSNumber(value: low as Double)),
         !lowString.isEmpty {
         return lowString
      } else {
         return ""
      }
   }
   var openForDisplay: String {
      if let open = open, open.isFinite,
         let openString = PositionCoordinator.dollarNumberFormatter.string(from: NSNumber(value: open as Double)),
         !openString.isEmpty {
         return openString
      } else {
         return ""
      }
   }
   var sharesForDisplay: String {
      if let shares = shares, shares.isFinite,
         let memberType = memberType, memberType == .portfolio {
         return String(format: "%g", shares)
      } else {
         return ""
      }
   }
   var valueForDisplay: String {
      if let lastPrice = lastPrice, lastPrice.isFinite,
         let shares = shares, shares.isFinite, shares > 0,
         let memberType = memberType, memberType == .portfolio,
         let valueString = PositionCoordinator.dollarNumberFormatter.string(from:
            NSNumber(value: lastPrice * shares as Double)),
         !valueString.isEmpty {
         return valueString
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
   return lhs.status == rhs.status
      && lhs.symbol == rhs.symbol
      && lhs.name == rhs.name
      && lhs.lastPrice == rhs.lastPrice
      && lhs.change == rhs.change
      && lhs.changePercent == rhs.changePercent
      && lhs.timeStamp == rhs.timeStamp
      && lhs.marketCap == rhs.marketCap
      && lhs.volume == rhs.volume
      && lhs.changeYTD == rhs.changeYTD
      && lhs.changePercentYTD == rhs.changePercentYTD
      && lhs.high == rhs.high
      && lhs.low == rhs.low
      && lhs.open == rhs.open
      && lhs.shares == rhs.shares
      && lhs.memberType == rhs.memberType
}


// MARK: - Position JSONParseable Extension

/**
 Adds JSON parsing functionality to base investment position model.
 */
extension Position: JSONParseable {
   /// Creates and returns a position created with the supplied JSON data.
   ///
   /// - Parameter json: The JSON data.
   /// - Returns: The position created from the JSON data.
   static func forJSON(_ json: JSONDictionary) -> Position? {
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
      
      guard let jsonDictionary = json["Data"] as? JSONDictionary else {
         return nil
      }
      
      var position = Position()
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
      
      guard !position.isEmpty else { return nil }
      
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
      if let memberType = memberType {
         printString += "\nPosition Member Type = \(memberType)"
      } else {
         printString += "\nPosition Member Type = Unknown"
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
