//
//  PositionModelTests.swift
//  Portfolio
//
//  Created by John Woolsey on 3/24/16.
//  Copyright © 2016 ExtremeBytes Software. All rights reserved.
//


import XCTest
@testable import Portfolio


enum PositionBaseProperty: Int {
   case Status = 0
   case Symbol
   case Name
   case LastPrice
   case Change
   case ChangePercent
   case TimeStamp
   case MarketCap
   case Volume
   case ChangeYTD
   case ChangePercentYTD
   case High
   case Low
   case Open
   case Shares
   case MemberType
   
   static var count: Int {
      return PositionBaseProperty.MemberType.rawValue + 1
   }
}


class PositionModelTests: XCTestCase {
   
   // MARK: - Properties
   
   var populatedPosition: Position {
      var position = Position()
      position.status = "SUCCESS"
      position.symbol = "AAPL"
      position.name = "Apple Inc"
      position.lastPrice = 105.65
      position.change = -0.47999999999999
      position.changePercent = -0.452275511165542
      position.timeStamp = "Thu Mar 24 15:59:59 UTC-04:00 2016"
      position.marketCap = 585785193950
      position.volume = 1870750
      position.changeYTD = 105.26
      position.changePercentYTD = 0.37051111533346
      position.high = 106.22
      position.low = 104.89
      position.open = 105.58
      return position
   }
   var portfolioPosition: Position {
      var position = populatedPosition
      position.shares = 100.4
      position.memberType = .Portfolio
      return position
   }
   var watchListPosition: Position {
      var position = populatedPosition
      position.memberType = .WatchList
      return position
   }
   var randomPositionMemberType: PositionMemberType {
      if Bool(Int(arc4random_uniform(2))) {
         return .Portfolio
      } else {
         return .WatchList
      }
   }
   
   
   // MARK: - Test Configuration
   
   override func setUp() {
      super.setUp()
      // Put setup code here. This method is called before the invocation of each test method in the class.
   }
   
   
   override func tearDown() {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
      super.tearDown()
   }
   
   
   // MARK: - Position Model Unit Tests
   
   /**
    Empty Position model structure unit tests.
    */
   func testEmptyPosition() {
      let position = Position()
      XCTAssertNotNil(position, "Could not create an empty position.")
      
      // Base Properties
      XCTAssertNil(position.status, "Empty Position 'status' property is not nil.")
      XCTAssertNil(position.symbol, "Empty Position 'symbol' property is not nil.")
      XCTAssertNil(position.name, "Empty Position 'name' property is not nil.")
      XCTAssertNil(position.lastPrice, "Empty Position 'lastPrice' property is not nil.")
      XCTAssertNil(position.change, "Empty Position 'change' property is not nil.")
      XCTAssertNil(position.changePercent, "Empty Position 'changePercent' property is not nil.")
      XCTAssertNil(position.timeStamp, "Empty Position 'timeStamp' property is not nil.")
      XCTAssertNil(position.marketCap, "Empty Position 'marketCap' property is not nil.")
      XCTAssertNil(position.volume, "Empty Position 'volume' property is not nil.")
      XCTAssertNil(position.changeYTD, "Empty Position 'changeYTD' property is not nil.")
      XCTAssertNil(position.changePercentYTD, "Empty Position 'changePercentYTD' property is not nil.")
      XCTAssertNil(position.high, "Empty Position 'high' property is not nil.")
      XCTAssertNil(position.low, "Empty Position 'low' property is not nil.")
      XCTAssertNil(position.open, "Empty Position 'open' property is not nil.")
      XCTAssertNil(position.shares, "Empty Position 'shares' property is not nil.")
      XCTAssertNil(position.memberType, "Empty Position 'memberType' property is not nil.")
      
      // State Properties
      XCTAssertTrue(position.isEmpty, "Empty Position 'isEmpty' property is false.")
      XCTAssertFalse(position.isComplete, "Empty Position 'isComplete' property is true.")
      
      // Display Properties
      XCTAssertEqual(position.statusForDisplay, "No Data", "Empty Position 'statusForDisplay' property is incorrect.")
      XCTAssertEqual(position.symbolForDisplay, "Unknown", "Empty Position 'symbolForDisplay' property is incorrect.")
      XCTAssertEqual(position.nameForDisplay, "", "Empty Position 'nameForDisplay' property is incorrect.")
      XCTAssertEqual(position.lastPriceForDisplay, "", "Empty Position 'lastPriceForDisplay' property is incorrect.")
      XCTAssertEqual(position.changeForDisplay, "", "Empty Position 'changeForDisplay' property is incorrect.")
      XCTAssertEqual(position.changePercentForDisplay, "", "Empty Position 'changePercentForDisplay' property is incorrect.")
      XCTAssertEqual(position.timeStampForDisplay, "Unknown Status", "Empty Position 'timeStampForDisplay' property is incorrect.")
      XCTAssertEqual(position.marketCapForDisplay, "", "Empty Position 'marketCapForDisplay' property is incorrect.")
      XCTAssertEqual(position.volumeForDisplay, "", "Empty Position 'volumeForDisplay' property is incorrect.")
      XCTAssertEqual(position.changeYTDForDisplay, "", "Empty Position 'changeYTDForDisplay' property is incorrect.")
      XCTAssertEqual(position.changePercentYTDForDisplay, "", "Empty Position 'changePercentYTDForDisplay' property is incorrect.")
      XCTAssertEqual(position.highForDisplay, "", "Empty Position 'highForDisplay' property is incorrect.")
      XCTAssertEqual(position.lowForDisplay, "", "Empty Position 'lowForDisplay' property is incorrect.")
      XCTAssertEqual(position.openForDisplay, "", "Empty Position 'openForDisplay' property is incorrect.")
      XCTAssertEqual(position.sharesForDisplay, "", "Empty Position 'sharesForDisplay' property is incorrect.")
      XCTAssertEqual(position.valueForDisplay, "", "Empty Position 'valueForDisplay' property is incorrect.")
   }
   
   
   /**
    Complete Position model structure unit tests.
    */
   func testCompletePosition() {
      var position: Position
      switch randomPositionMemberType {
      case .Portfolio:
         position = portfolioPosition
      case .WatchList:
         position = watchListPosition
      }
      
      // Base Properties
      XCTAssertNotNil(position.status, "Complete Position 'status' property is nil.")
      XCTAssertNotNil(position.symbol, "Complete Position 'symbol' property is nil.")
      XCTAssertNotNil(position.name, "Complete Position 'name' property is nil.")
      XCTAssertNotNil(position.lastPrice, "Complete Position 'lastPrice' property is nil.")
      XCTAssertNotNil(position.change, "Complete Position 'change' property is nil.")
      XCTAssertNotNil(position.changePercent, "Complete Position 'changePercent' property is nil.")
      XCTAssertNotNil(position.timeStamp, "Complete Position 'timeStamp' property is nil.")
      XCTAssertNotNil(position.marketCap, "Complete Position 'marketCap' property is nil.")
      XCTAssertNotNil(position.volume, "Complete Position 'volume' property is nil.")
      XCTAssertNotNil(position.changeYTD, "Complete Position 'changeYTD' property is nil.")
      XCTAssertNotNil(position.changePercentYTD, "Complete Position 'changePercentYTD' property is nil.")
      XCTAssertNotNil(position.high, "Complete Position 'high' property is nil.")
      XCTAssertNotNil(position.low, "Complete Position 'low' property is nil.")
      XCTAssertNotNil(position.open, "Complete Position 'open' property is nil.")
      if let memberType = position.memberType where memberType == .Portfolio {
         XCTAssertNotNil(position.shares, "Complete Position 'shares' property is nil.")
      }
      XCTAssertNotNil(position.memberType, "Complete Position 'memberType' property is nil.")
      
      // State Properties
      XCTAssertFalse(position.isEmpty, "Complete Position 'isEmpty' property is true.")
      XCTAssertTrue(position.isComplete, "Complete Position 'isComplete' property is false.")
      
      // Display Properties
      XCTAssertEqual(position.statusForDisplay, position.timeStampForDisplay, "Complete Position 'statusForDisplay' property is incorrect.")
      XCTAssertEqual(position.symbolForDisplay, "AAPL", "Complete Position 'symbolForDisplay' property is incorrect.")
      XCTAssertEqual(position.nameForDisplay, "Apple Inc", "Complete Position 'nameForDisplay' property is incorrect.")
      XCTAssertEqual(position.lastPriceForDisplay, "$105.65", "Complete Position 'lastPriceForDisplay' property is incorrect.")
      XCTAssertEqual(position.changeForDisplay, "-$0.48", "Complete Position 'changeForDisplay' property is incorrect.")
      XCTAssertEqual(position.changePercentForDisplay, "-0.45%", "Complete Position 'changePercentForDisplay' property is incorrect.")
      XCTAssertEqual(position.timeStampForDisplay, "Mar 24 2016 14:59", "Complete Position 'timeStampForDisplay' property is incorrect.")
      XCTAssertEqual(position.marketCapForDisplay, "585.79B", "Complete Position 'marketCapForDisplay' property is incorrect.")
      XCTAssertEqual(position.volumeForDisplay, "1.87M", "Complete Position 'volumeForDisplay' property is incorrect.")
      XCTAssertEqual(position.changeYTDForDisplay, "$0.39", "Complete Position 'changeYTDForDisplay' property is incorrect.")
      XCTAssertEqual(position.changePercentYTDForDisplay, "0.37%", "Complete Position 'changePercentYTDForDisplay' property is incorrect.")
      XCTAssertEqual(position.highForDisplay, "$106.22", "Complete Position 'highForDisplay' property is incorrect.")
      XCTAssertEqual(position.lowForDisplay, "$104.89", "Complete Position 'lowForDisplay' property is incorrect.")
      XCTAssertEqual(position.openForDisplay, "$105.58", "Complete Position 'openForDisplay' property is incorrect.")
      switch position.memberType {
      case .Some(.Portfolio):
         XCTAssertEqual(position.sharesForDisplay, "100.4", "Complete Position 'sharesForDisplay' property is incorrect.")
         XCTAssertEqual(position.valueForDisplay, "$10,607.26", "Complete Position 'valueForDisplay' property is incorrect.")
      default:
         XCTAssertEqual(position.sharesForDisplay, "", "Complete Position 'sharesForDisplay' property is incorrect.")
         XCTAssertEqual(position.valueForDisplay, "", "Complete Position 'valueForDisplay' property is incorrect.")
      }
   }
   
   
   /**
    Incomplete Position model structure unit tests.
    
    Creates and tests a random sampling of incomplete Position models.
    
    - note: Not all properties are excercised since they are mostly checked through other tests.
    */
   func testIncompletePosition() {
      let position = positionWithRandomNilProperties()
      
      if let memberType = position.memberType where memberType == .WatchList
      && position.status != nil
         && position.symbol != nil
         && position.name != nil
         && position.lastPrice != nil
         && position.change != nil
         && position.changePercent != nil
         && position.timeStamp != nil
         && position.marketCap != nil
         && position.volume != nil
         && position.changeYTD != nil
         && position.changePercentYTD != nil
         && position.high != nil
         && position.low != nil
         && position.open != nil {
         XCTAssertFalse(position.isEmpty, "Random incomplete Position 'isEmpty' property is true.")
         XCTAssertTrue(position.isComplete, "Random incomplete Position 'isComplete' property is false.")
         XCTAssertEqual(position.statusForDisplay, position.timeStampForDisplay, "Random incomplete Position 'statusForDisplay' property is incorrect.")
      } else {
         XCTAssertFalse(position.isEmpty, "Random incomplete Position 'isEmpty' property is true.")
         XCTAssertFalse(position.isComplete, "Random incomplete Position 'isComplete' property is true.")
         XCTAssertEqual(position.statusForDisplay, "Incomplete Data", "Random incomplete Position 'statusForDisplay' property is incorrect.")
      }
   }
   
   
   /**
    Unknown status Position model structure unit tests.
    
    - note: Not all properties are excercised since they are mostly checked through other tests.
    */
   func testUnknownStatusPosition() {
      var position: Position
      switch randomPositionMemberType {
      case .Portfolio:
         position = portfolioPosition
      case .WatchList:
         position = watchListPosition
      }
      position.status = "ERROR"
      
      // Display Properties
      XCTAssertEqual(position.statusForDisplay, "Unknown Status", "Unknown status Position 'statusForDisplay' property is incorrect.")
   }
   
   
   // MARK: - Helper Functions
   
   /**
    Returns a position with some properties set to nil.
    
    - returns: A position with one or more, but not all, of it's properties randomly set to nil.
    */
   func positionWithRandomNilProperties() -> Position {
      var position = portfolioPosition
      position.memberType = randomPositionMemberType
      let randomNumberOfNilProperties = Int(arc4random_uniform(UInt32(PositionBaseProperty.count - 1))) + 1  // leaves at least one property set
      for _ in 1...randomNumberOfNilProperties {
         if let randomPositionBaseProperty: PositionBaseProperty = PositionBaseProperty(rawValue: Int(arc4random_uniform(UInt32(PositionBaseProperty.count)))) {
            switch randomPositionBaseProperty {
            case .Status:
               position.status = nil
            case .Symbol:
               position.symbol = nil
            case .Name:
               position.name = nil
            case .LastPrice:
               position.lastPrice = nil
            case .Change:
               position.change = nil
            case .ChangePercent:
               position.changePercent = nil
            case .TimeStamp:
               position.timeStamp = nil
            case .MarketCap:
               position.marketCap = nil
            case .Volume:
               position.volume = nil
            case .ChangeYTD:
               position.changeYTD = nil
            case .ChangePercentYTD:
               position.changePercentYTD = nil
            case .High:
               position.high = nil
            case .Low:
               position.low = nil
            case .Open:
               position.open = nil
            case .Shares:
               position.shares = nil
            case .MemberType:
               position.memberType = nil
            }
         }
      }
      return position
   }
}
