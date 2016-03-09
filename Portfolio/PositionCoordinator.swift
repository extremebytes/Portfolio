//
//  PositionCoordinator.swift
//  Portfolio
//
//  Created by John Woolsey on 2/2/16.
//  Copyright © 2016 ExtremeBytes Software. All rights reserved.
//


import Foundation
import UIKit


// MARK: - Enums

enum PositionType: String {
   case Portfolio = "Portfolio"
   case WatchList = "Watch List"
   
   var title: String {
      return self.rawValue
   }
}


class PositionCoordinator {
   
   // MARK: - Properties
   
   static let sharedInstance = PositionCoordinator()  // singleton
   let spacerSize = CGSize(width: 8, height: 8)
   
   var portfolioCellSize: CGSize {
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
      return itemSize
   }
   var watchListCellSize: CGSize {
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
      return itemSize
   }
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

   private let minimumPortfolioCellSize = CGSize(width: 224, height: 128)
   private let minimumWatchListCellSize = CGSize(width: 224, height: 96)

   
   // MARK: - Lifecycle
   
   private init() {}  // prevents use of default initializer
}