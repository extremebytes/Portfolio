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
//   let status: String
   let name: String
   let symbol: String
   let lastPrice: String
   let change: String
   let changePercent: String
   let timeStamp: String
//   let marketCap: String
//   let volume: String
//   let changeYTD: String
//   let changePercentYTD: String
//   let high: String
//   let low: String
//   let open: String
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
