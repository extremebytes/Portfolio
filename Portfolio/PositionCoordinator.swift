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
      formatter.dateFormat = "EEE MMM dd yyyy HH:mm:ss"
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
   
   /**
   Creates an investment position from JSON retrieved from the server.
   
   The status property of the resulting Position contains the conversion status.
   
   - parameter json: A JSON dictionary.
   
   - returns: A Position object.
   */
   func positionForJSON(json: [String:AnyObject]) -> Position {
      
      let name = json["Data"]?["Name"] as? String ?? ""
      
      let symbol = json["Data"]?["Symbol"] as? String ?? ""
      
      var lastPrice = ""
      if let jsonLastPrice = json["Data"]?["LastPrice"] as? Double {
         lastPrice = String(format: "%.2f", jsonLastPrice)
      }
      
      var change = ""
      if let jsonChange = json["Data"]?["Change"] as? Double {
         change = String(format: "%.2f", jsonChange)
      }
      
      var changePercent = ""
      if let jsonChangePercent = json["Data"]?["ChangePercent"] as? Double {
         changePercent = String(format: "%.2f%%", jsonChangePercent)
      }
      
      var timeStamp = ""
      if let jsonTimeStamp = json["Data"]?["Timestamp"] as? String,
         inputTimeStamp = inputDateFormatter.dateFromString(jsonTimeStamp) {
            timeStamp = outputDateFormatter.stringFromDate(inputTimeStamp)
      }
      
      var marketCap = ""
      if let jsonMarketCap = json["Data"]?["MarketCap"] as? Double {
         marketCap = String(format: "%.2fB", jsonMarketCap/1e9)
      }
      
      var volume = ""
      if let jsonVolume = json["Data"]?["Volume"] as? Double {
         volume = String(format: "%.2fM", jsonVolume/1e6)
      }
      
      var changeYTD = ""
      if let jsonChangeYTD = json["Data"]?["ChangeYTD"] as? Double {
         changeYTD = String(format: "%.2f", jsonChangeYTD)
      }
      
      var changePercentYTD = ""
      if let jsonChangePercentYTD = json["Data"]?["ChangePercentYTD"] as? Double {
         changePercentYTD = String(format: "%.2f%%", jsonChangePercentYTD)
      }
      
      var high = ""
      if let jsonHigh = json["Data"]?["High"] as? Double {
         high = String(format: "%.2f", jsonHigh)
      }
      
      var low = ""
      if let jsonLow = json["Data"]?["Low"] as? Double {
         low = String(format: "%.2f", jsonLow)
      }
      
      var open = ""
      if let jsonOpen = json["Data"]?["Open"] as? Double {
         open = String(format: "%.2f", jsonOpen)
      }

      var status = "Failed"
      if let jsonStatus = json["Data"]?["Status"] as? String {
         if jsonStatus.lowercaseString.rangeOfString("success") != nil {
            status = "Success"
            if name.isEmpty || symbol.isEmpty || lastPrice.isEmpty || change.isEmpty
               || changePercent.isEmpty || timeStamp.isEmpty || marketCap.isEmpty
               || volume.isEmpty || changeYTD.isEmpty || changePercentYTD.isEmpty
               || high.isEmpty || low.isEmpty || open.isEmpty {
                  status = "Incomplete"
            }
         }
      }
      
      return Position(status: status, name: name, symbol: symbol, lastPrice: lastPrice,
         change: change, changePercent: changePercent, timeStamp: timeStamp, marketCap: marketCap,
         volume: volume, changeYTD: changeYTD, changePercentYTD: changePercentYTD,
         high: high, low: low, open: open)
   }
}