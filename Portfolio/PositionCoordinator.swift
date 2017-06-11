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

enum PositionMemberType: String, CustomStringConvertible, CustomDebugStringConvertible {
   case portfolio = "Portfolio", watchList = "Watch List"
   
   var description: String { return rawValue }
   var debugDescription: String { return description }
   var title: String { return description }
}


struct PositionCoordinator {
   
   // MARK: - Properties
   
   static let spacerSize = CGSize(width: 8, height: 8)
   
   static var inputDateFormatter: DateFormatter {
      let formatter = DateFormatter()
      formatter.dateFormat = "EEE MMM dd HH:mm:ss zzzz yyyy"
      return formatter
   }
   static var outputDateFormatter: DateFormatter {
      let formatter = DateFormatter()
      formatter.dateStyle = .medium
      formatter.timeStyle = .medium
      return formatter
   }
   static var dollarNumberFormatter: NumberFormatter {
      let formatter = NumberFormatter()
      formatter.numberStyle = .currency
      formatter.currencySymbol = "$"  // force currency symbol to be dollar since server returns all values in US dollars
      formatter.minimumFractionDigits = 2
      formatter.maximumFractionDigits = 2
      return formatter
   }
   
   static private let minimumPortfolioCellSize = CGSize(width: 232, height: 128)
   static private let minimumWatchListCellSize = CGSize(width: 232, height: 96)
   
   
   // MARK: - Helper Functions
   
   /**
    Calculates and returns the collection view cell size.
    
    - parameter screenWidth:  The screen width of the device.
    - parameter positionType: The position member type.
    
    - returns: The size of the collection view cell.
    */
   static func cellSizeFor(screenWidth: CGFloat, positionType: PositionMemberType) -> CGSize {
      let minimumCellSize: CGSize
      switch positionType {
      case .portfolio:
         minimumCellSize = minimumPortfolioCellSize
      case .watchList:
         minimumCellSize = minimumWatchListCellSize
      }
      let maximumNumberOfCellsPerRow = floor((screenWidth + spacerSize.width) /
         (minimumCellSize.width + spacerSize.width))
      if maximumNumberOfCellsPerRow <= 1 {
         return CGSize(width: screenWidth, height: floor(minimumCellSize.height))
      } else {
         let maximumCellWidth = (screenWidth + spacerSize.width) / maximumNumberOfCellsPerRow - spacerSize.width
         return CGSize(width: floor(maximumCellWidth), height: floor(minimumCellSize.height))
      }
   }
   
   
   /**
    Calculates and returns the appropriate investment position insertion index for the given symbol.
    
    - parameter symbol:  The symbol to insert.
    - parameter saved:   The previously saved symbol collection.
    - parameter current: The current symbol collection being built.
    
    - returns: The index to place the new symbol in the partial list of current symbols.
    */
   static func insertionIndex(for symbol: String, from saved: [String], into current: [String]) -> Int? {
      guard !current.contains(symbol) else {
         return nil
      }
      var index = 0
      if let savedIndex = saved.index(of: symbol) {
         let savedPredecessorSymbols = saved[0..<savedIndex]
         let currentPredecessorSymbols = current.filter({ savedPredecessorSymbols.contains($0) == true })
         index = currentPredecessorSymbols.count
      }
      return index
   }
}
