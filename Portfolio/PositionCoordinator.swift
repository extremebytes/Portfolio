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
   
   /**
   Creates an investment position from JSON retrieved from the server.
   
   The status property of the resulting Position contains the conversion status.
   
   - parameter json: A JSON dictionary.
   
   - returns: A Position object.
   */
   func positionForJSON(json: [String:AnyObject]) -> Position {
      var position = Position()
      
      position.status = json["Data"]?["Status"] as? String
      position.name = json["Data"]?["Name"] as? String
      position.symbol = json["Data"]?["Symbol"] as? String
      position.lastPrice = json["Data"]?["LastPrice"] as? Double
      position.change = json["Data"]?["Change"] as? Double
      position.changePercent = json["Data"]?["ChangePercent"] as? Double
      position.timeStamp = json["Data"]?["Timestamp"] as? String
      position.marketCap = json["Data"]?["MarketCap"] as? Double
      position.volume = json["Data"]?["Volume"] as? Double
      position.changeYTD = json["Data"]?["ChangeYTD"] as? Double
      position.changePercentYTD = json["Data"]?["ChangePercentYTD"] as? Double
      position.high = json["Data"]?["High"] as? Double
      position.low = json["Data"]?["Low"] as? Double
      position.open = json["Data"]?["Open"] as? Double
      
      return position
   }
}