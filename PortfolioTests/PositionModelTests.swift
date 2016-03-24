//
//  PositionModelTests.swift
//  Portfolio
//
//  Created by John Woolsey on 3/24/16.
//  Copyright © 2016 ExtremeBytes Software. All rights reserved.
//


import XCTest
@testable import Portfolio

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
      position.type = .Portfolio
      return position
   }
   var watchListPosition: Position {
      var position = populatedPosition
      position.type = .WatchList
      return position
   }
   
   
   // MARK: - Configuration
   
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
    Complete Portfolio Position model structure unit tests.
    */
   func testCompletePortfolioPosition() {
      let position = portfolioPosition
      
      // Base Properties
      XCTAssertNotNil(position.status, "Complete Portfolio Position 'status' property is nil.")
      XCTAssertNotNil(position.symbol, "Complete Portfolio Position 'symbol' property is nil.")
      XCTAssertNotNil(position.name, "Complete Portfolio Position 'name' property is nil.")
      XCTAssertNotNil(position.lastPrice, "Complete Portfolio Position 'lastPrice' property is nil.")
      XCTAssertNotNil(position.change, "Complete Portfolio Position 'change' property is nil.")
      XCTAssertNotNil(position.changePercent, "Complete Portfolio Position 'changePercent' property is nil.")
      XCTAssertNotNil(position.timeStamp, "Complete Portfolio Position 'timeStamp' property is nil.")
      XCTAssertNotNil(position.marketCap, "Complete Portfolio Position 'marketCap' property is nil.")
      XCTAssertNotNil(position.volume, "Complete Portfolio Position 'volume' property is nil.")
      XCTAssertNotNil(position.changeYTD, "Complete Portfolio Position 'changeYTD' property is nil.")
      XCTAssertNotNil(position.changePercentYTD, "Complete Portfolio Position 'changePercentYTD' property is nil.")
      XCTAssertNotNil(position.high, "Complete Portfolio Position 'high' property is nil.")
      XCTAssertNotNil(position.low, "Complete Portfolio Position 'low' property is nil.")
      XCTAssertNotNil(position.open, "Complete Portfolio Position 'open' property is nil.")
      XCTAssertNotNil(position.shares, "Complete Portfolio Position 'shares' property is nil.")
      XCTAssertNotNil(position.type, "Complete Portfolio Position 'type' property is nil.")
      
      // State Properties
      XCTAssertFalse(position.isEmpty, "Complete Portfolio Position 'isEmpty' property is true.")
      XCTAssertTrue(position.isComplete, "Complete Portfolio Position 'isComplete' property is false.")
      
      // Display Properties
      XCTAssertEqual(position.statusForDisplay, position.timeStampForDisplay, "Complete Portfolio Position 'statusForDisplay' property is incorrect.")
      XCTAssertEqual(position.symbolForDisplay, "AAPL", "Complete Portfolio Position 'symbolForDisplay' property is incorrect.")
      XCTAssertEqual(position.nameForDisplay, "Apple Inc", "Complete Portfolio Position 'nameForDisplay' property is incorrect.")
      XCTAssertEqual(position.lastPriceForDisplay, "$105.65", "Complete Portfolio Position 'lastPriceForDisplay' property is incorrect.")
      XCTAssertEqual(position.changeForDisplay, "-$0.48", "Complete Portfolio Position 'changeForDisplay' property is incorrect.")
      XCTAssertEqual(position.changePercentForDisplay, "-0.45%", "Complete Portfolio Position 'changePercentForDisplay' property is incorrect.")
      XCTAssertEqual(position.timeStampForDisplay, "Mar 24 2016 14:59", "Complete Portfolio Position 'timeStampForDisplay' property is incorrect.")
      XCTAssertEqual(position.marketCapForDisplay, "585.79B", "Complete Portfolio Position 'marketCapForDisplay' property is incorrect.")
      XCTAssertEqual(position.volumeForDisplay, "1.87M", "Complete Portfolio Position 'volumeForDisplay' property is incorrect.")
      XCTAssertEqual(position.changeYTDForDisplay, "$0.39", "Complete Portfolio Position 'changeYTDForDisplay' property is incorrect.")
      XCTAssertEqual(position.changePercentYTDForDisplay, "0.37%", "Complete Portfolio Position 'changePercentYTDForDisplay' property is incorrect.")
      XCTAssertEqual(position.highForDisplay, "$106.22", "Complete Portfolio Position 'highForDisplay' property is incorrect.")
      XCTAssertEqual(position.lowForDisplay, "$104.89", "Complete Portfolio Position 'lowForDisplay' property is incorrect.")
      XCTAssertEqual(position.openForDisplay, "$105.58", "Complete Portfolio Position 'openForDisplay' property is incorrect.")
      XCTAssertEqual(position.sharesForDisplay, "100.4", "Complete Portfolio Position 'sharesForDisplay' property is incorrect.")
      XCTAssertEqual(position.valueForDisplay, "$10,607.26", "Complete Portfolio Position 'valueForDisplay' property is incorrect.")
   }
   
   
   /**
    Complete Watch List Position model structure unit tests.
    */
   func testCompleteWatchListPosition() {
      let position = watchListPosition
      
      // Base Properties
      XCTAssertNotNil(position.status, "Complete WatchList Position 'status' property is nil.")
      XCTAssertNotNil(position.symbol, "Complete WatchList Position 'symbol' property is nil.")
      XCTAssertNotNil(position.name, "Complete WatchList Position 'name' property is nil.")
      XCTAssertNotNil(position.lastPrice, "Complete WatchList Position 'lastPrice' property is nil.")
      XCTAssertNotNil(position.change, "Complete WatchList Position 'change' property is nil.")
      XCTAssertNotNil(position.changePercent, "Complete WatchList Position 'changePercent' property is nil.")
      XCTAssertNotNil(position.timeStamp, "Complete WatchList Position 'timeStamp' property is nil.")
      XCTAssertNotNil(position.marketCap, "Complete WatchList Position 'marketCap' property is nil.")
      XCTAssertNotNil(position.volume, "Complete WatchList Position 'volume' property is nil.")
      XCTAssertNotNil(position.changeYTD, "Complete WatchList Position 'changeYTD' property is nil.")
      XCTAssertNotNil(position.changePercentYTD, "Complete WatchList Position 'changePercentYTD' property is nil.")
      XCTAssertNotNil(position.high, "Complete WatchList Position 'high' property is nil.")
      XCTAssertNotNil(position.low, "Complete WatchList Position 'low' property is nil.")
      XCTAssertNotNil(position.open, "Complete WatchList Position 'open' property is nil.")
      XCTAssertNil(position.shares, "Complete WatchList Position 'shares' property is not nil.")
      XCTAssertNotNil(position.type, "Complete WatchList Position 'type' property is nil.")
      
      // State Properties
      XCTAssertFalse(position.isEmpty, "Complete WatchList Position 'isEmpty' property is true.")
      XCTAssertTrue(position.isComplete, "Complete WatchList Position 'isComplete' property is false.")
      
      // Display Properties
      XCTAssertEqual(position.statusForDisplay, position.timeStampForDisplay, "Complete WatchList Position 'statusForDisplay' property is incorrect.")
      XCTAssertEqual(position.symbolForDisplay, "AAPL", "Complete WatchList Position 'symbolForDisplay' property is incorrect.")
      XCTAssertEqual(position.nameForDisplay, "Apple Inc", "Complete WatchList Position 'nameForDisplay' property is incorrect.")
      XCTAssertEqual(position.lastPriceForDisplay, "$105.65", "Complete WatchList Position 'lastPriceForDisplay' property is incorrect.")
      XCTAssertEqual(position.changeForDisplay, "-$0.48", "Complete WatchList Position 'changeForDisplay' property is incorrect.")
      XCTAssertEqual(position.changePercentForDisplay, "-0.45%", "Complete WatchList Position 'changePercentForDisplay' property is incorrect.")
      XCTAssertEqual(position.timeStampForDisplay, "Mar 24 2016 14:59", "Complete WatchList Position 'timeStampForDisplay' property is incorrect.")
      XCTAssertEqual(position.marketCapForDisplay, "585.79B", "Complete WatchList Position 'marketCapForDisplay' property is incorrect.")
      XCTAssertEqual(position.volumeForDisplay, "1.87M", "Complete WatchList Position 'volumeForDisplay' property is incorrect.")
      XCTAssertEqual(position.changeYTDForDisplay, "$0.39", "Complete WatchList Position 'changeYTDForDisplay' property is incorrect.")
      XCTAssertEqual(position.changePercentYTDForDisplay, "0.37%", "Complete WatchList Position 'changePercentYTDForDisplay' property is incorrect.")
      XCTAssertEqual(position.highForDisplay, "$106.22", "Complete WatchList Position 'highForDisplay' property is incorrect.")
      XCTAssertEqual(position.lowForDisplay, "$104.89", "Complete WatchList Position 'lowForDisplay' property is incorrect.")
      XCTAssertEqual(position.openForDisplay, "$105.58", "Complete WatchList Position 'openForDisplay' property is incorrect.")
      XCTAssertEqual(position.sharesForDisplay, "", "Complete WatchList Position 'sharesForDisplay' property is incorrect.")
      XCTAssertEqual(position.valueForDisplay, "", "Complete WatchList Position 'valueForDisplay' property is incorrect.")
   }
   
   
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
      XCTAssertNil(position.type, "Empty Position 'type' property is not nil.")
      
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
}
