//
//  PositionCoordinator.swift
//  Portfolio
//
//  Created by John Woolsey on 2/2/16.
//  Copyright © 2016 ExtremeBytes Software. All rights reserved.
//


import Foundation
import UIKit


// MARK: - Enumerations

enum PositionType: String, CustomStringConvertible, CustomDebugStringConvertible {
   case Portfolio = "Portfolio"
   case WatchList = "Watch List"
   
   var description: String { return rawValue }
   var debugDescription: String { return description }
   var title: String { return description }
}


struct PositionCoordinator {
   
   // MARK: - Properties
   
   static let spacerSize = CGSize(width: 8, height: 8)
   
   static var portfolioCellSize: CGSize {
      let screenWidth = UIScreen.mainScreen().bounds.width
      var itemSize: CGSize
      if screenWidth < minimumPortfolioCellSize.width * 2 + spacerSize.width * 1 {  // 1 item per row
         itemSize = CGSize(width: screenWidth, height: minimumPortfolioCellSize.height)
      } else if screenWidth < minimumPortfolioCellSize.width * 3 + spacerSize.width * 2 {  // 2 items per row
         itemSize = CGSize(width: (screenWidth - spacerSize.width) / 2, height: minimumPortfolioCellSize.height)
      } else if screenWidth < minimumPortfolioCellSize.width * 4 + spacerSize.width * 3 {  // 3 items per row
         itemSize = CGSize(width: (screenWidth - spacerSize.width * 2) / 3, height: minimumPortfolioCellSize.height)
      } else {  // 4 items per row (maximum)
         itemSize = CGSize(width: (screenWidth - spacerSize.width * 3) / 4, height: minimumPortfolioCellSize.height)
      }
      return CGSize(width: floor(itemSize.width), height: floor(itemSize.height))
   }
   static var watchListCellSize: CGSize {
      let screenWidth = UIScreen.mainScreen().bounds.width
      var itemSize: CGSize
      if screenWidth < minimumWatchListCellSize.width * 2 + spacerSize.width * 1 {  // 1 item per row
         itemSize = CGSize(width: screenWidth, height: minimumWatchListCellSize.height)
      } else if screenWidth < minimumWatchListCellSize.width * 3 + spacerSize.width * 2 {  // 2 items per row
         itemSize = CGSize(width: (screenWidth - spacerSize.width) / 2, height: minimumWatchListCellSize.height)
      } else if screenWidth < minimumWatchListCellSize.width * 4 + spacerSize.width * 3 {  // 3 items per row
         itemSize = CGSize(width: (screenWidth - spacerSize.width * 2) / 3, height: minimumWatchListCellSize.height)
      } else {  // 4 items per row (maximum)
         itemSize = CGSize(width: (screenWidth - spacerSize.width * 3) / 4, height: minimumWatchListCellSize.height)
      }
      return CGSize(width: floor(itemSize.width), height: floor(itemSize.height))
   }
   static var inputDateFormatter: NSDateFormatter {
      let formatter = NSDateFormatter()
      formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
      return formatter
   }
   static var outputDateFormatter: NSDateFormatter {
      let formatter = NSDateFormatter()
      formatter.dateFormat = "MMM dd yyyy HH:mm"
      return formatter
   }
   static var dollarNumberFormatter: NSNumberFormatter {
      let formatter = NSNumberFormatter()
      formatter.numberStyle = .CurrencyStyle
      formatter.currencySymbol = "$"
      formatter.minimumFractionDigits = 2
      formatter.maximumFractionDigits = 2
      return formatter
   }

   static private let minimumPortfolioCellSize = CGSize(width: 232, height: 128)
   static private let minimumWatchListCellSize = CGSize(width: 232, height: 96)
}