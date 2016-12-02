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
   
   // MARK: Enumerations
   
   enum PositionBaseProperty: Int {
      case status = 0
      case symbol
      case name
      case lastPrice
      case change
      case changePercent
      case timeStamp
      case marketCap
      case volume
      case changeYTD
      case changePercentYTD
      case high
      case low
      case open
      case shares
      case memberType
      
      static var count: Int {
         return PositionBaseProperty.memberType.rawValue + 1
      }
   }
   
   
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
      if arc4random_uniform(2) > 0 {
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
      
      // Base properties
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
      
      // State properties
      XCTAssertTrue(position.isEmpty, "Empty Position 'isEmpty' property is false.")
      XCTAssertFalse(position.isComplete, "Empty Position 'isComplete' property is true.")
      
      // Display properties
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
      
      // Base properties
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
      if let memberType = position.memberType, memberType == .Portfolio {
         XCTAssertNotNil(position.shares, "Complete Position 'shares' property is nil.")
      }
      XCTAssertNotNil(position.memberType, "Complete Position 'memberType' property is nil.")
      
      // State properties
      XCTAssertFalse(position.isEmpty, "Complete Position 'isEmpty' property is true.")
      XCTAssertTrue(position.isComplete, "Complete Position 'isComplete' property is false.")
      
      // Display properties
      XCTAssertEqual(position.statusForDisplay, position.timeStampForDisplay, "Complete Position 'statusForDisplay' property is incorrect.")
      XCTAssertEqual(position.symbolForDisplay, "AAPL", "Complete Position 'symbolForDisplay' property is incorrect.")
      XCTAssertEqual(position.nameForDisplay, "Apple Inc", "Complete Position 'nameForDisplay' property is incorrect.")
      XCTAssertEqual(position.lastPriceForDisplay, "$105.65", "Complete Position 'lastPriceForDisplay' property is incorrect.")
      XCTAssertEqual(position.changeForDisplay, "-$0.48", "Complete Position 'changeForDisplay' property is incorrect.")
      XCTAssertEqual(position.changePercentForDisplay, "-0.45%", "Complete Position 'changePercentForDisplay' property is incorrect.")
      XCTAssertEqual(position.timeStampForDisplay, "Mar 24, 2016, 3:59:59 PM", "Complete Position 'timeStampForDisplay' property is incorrect.")  // TODO: Need to account for local time and data
      XCTAssertEqual(position.marketCapForDisplay, "585.79B", "Complete Position 'marketCapForDisplay' property is incorrect.")
      XCTAssertEqual(position.volumeForDisplay, "1.87M", "Complete Position 'volumeForDisplay' property is incorrect.")
      XCTAssertEqual(position.changeYTDForDisplay, "$0.39", "Complete Position 'changeYTDForDisplay' property is incorrect.")
      XCTAssertEqual(position.changePercentYTDForDisplay, "0.37%", "Complete Position 'changePercentYTDForDisplay' property is incorrect.")
      XCTAssertEqual(position.highForDisplay, "$106.22", "Complete Position 'highForDisplay' property is incorrect.")
      XCTAssertEqual(position.lowForDisplay, "$104.89", "Complete Position 'lowForDisplay' property is incorrect.")
      XCTAssertEqual(position.openForDisplay, "$105.58", "Complete Position 'openForDisplay' property is incorrect.")
      switch position.memberType {
      case .some(.Portfolio):
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
      var position = portfolioPosition
      randomlySetMemberTypeForPosition(&position)
      randomlySetNilPropertiesForPosition(&position)
      
      if let memberType = position.memberType, memberType == .WatchList,
         position.status != nil,
         position.symbol != nil,
         position.name != nil,
         position.lastPrice != nil,
         position.change != nil,
         position.changePercent != nil,
         position.timeStamp != nil,
         position.marketCap != nil,
         position.volume != nil,
         position.changeYTD != nil,
         position.changePercentYTD != nil,
         position.high != nil,
         position.low != nil,
         position.open != nil {
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
      
      XCTAssertEqual(position.statusForDisplay, "Unknown Status", "Unknown status Position 'statusForDisplay' property is incorrect.")
   }
   
   
   /**
    Position model structure equality unit tests.
    */
   func testPositionEquality() {
      var positionA = Position()
      var positionB = Position()
      
      // Empty positions
      XCTAssertEqual(positionA, positionB, "Empty positions are not equal.")
      
      // Modified empty positions
      positionB.high = 18
      XCTAssertNotEqual(positionA, positionB, "Modified empty positions are equal.")
      
      // Positions of same member type
      positionA = watchListPosition
      positionB = watchListPosition
      XCTAssertEqual(positionA, positionB, "Watch List positions are not equal.")
      
      // Positions of different member type
      positionB = portfolioPosition
      XCTAssertNotEqual(positionA, positionB, "Positions of different member type are equal.")
      
      // One random position property changed
      positionB = watchListPosition
      randomlySetNilPropertiesForPosition(&positionB, number: 1)
      XCTAssertNotEqual(positionA, positionB, "Modified Watch List positions are equal.")
      
      // One or more random position properties changed
      positionB = watchListPosition
      randomlySetNilPropertiesForPosition(&positionB)
      XCTAssertNotEqual(positionA, positionB, "Modified Watch List positions are equal.")
   }
   
   
   /**
    Position model forJSON(json) function unit tests.
    */
   func testForJSON() {
      // Test bundle
      let testBundle = Bundle(for: type(of: self))
      
      // Simple object
//      let positionSimpleObject = Position.forJSON(NSObject())
//      XCTAssertNil(positionSimpleObject, "Simple object position is not nil.")
      
      // Simple dictionary
      let simpleDictionary = ["Data": ["Stuff": " "]]
      let positionSimpleDictionary = Position.forJSON(simpleDictionary as JSONDictionary)
      XCTAssertNil(positionSimpleDictionary, "Simple dictionary position is not nil.")
      
      // Empty JSON file
      if let jsonPathEmpty = testBundle.path(forResource: "empty", ofType: "json"),
         let jsonDataEmpty = try? Data(contentsOf: URL(fileURLWithPath: jsonPathEmpty)),
         let jsonDictionaryEmpty = (try? JSONSerialization.jsonObject(with: jsonDataEmpty, options: [])) as? JSONDictionary {
         let positionEmpty = Position.forJSON(jsonDictionaryEmpty)
         XCTAssertNil(positionEmpty, "Empty JSON position was not nil.")
      } else {
         XCTFail("Could not load empty JSON file.")
      }
      
      // Error JSON file
      if let jsonPathError = testBundle.path(forResource: "error", ofType: "json"),
         let jsonDataError = try? Data(contentsOf: URL(fileURLWithPath: jsonPathError)),
         let jsonDictionaryError = (try? JSONSerialization.jsonObject(with: jsonDataError, options: [])) as? JSONDictionary {
         let positionError = Position.forJSON(jsonDictionaryError)
         XCTAssertNil(positionError, "Error JSON position was not nil.")
      } else {
         XCTFail("Could not load error JSON file.")
      }
      
      // AAPL JSON file
      if let jsonPathAAPL = testBundle.path(forResource: "AAPL", ofType: "json"),
         let jsonDataAAPL = try? Data(contentsOf: URL(fileURLWithPath: jsonPathAAPL)),
         let jsonDictionaryAAPL = (try? JSONSerialization.jsonObject(with: jsonDataAAPL, options: [])) as? JSONDictionary {
         if var positionAAPL = Position.forJSON(jsonDictionaryAAPL) {
            positionAAPL.memberType = .WatchList
            XCTAssertFalse(positionAAPL.isEmpty, "AAPL JSON position is empty.")
            XCTAssertTrue(positionAAPL.isComplete, "AAPL JSON position is not complete.")
            XCTAssertEqual(positionAAPL.statusForDisplay, positionAAPL.timeStampForDisplay, "AAPL JSON position does not have the correct status.")
         } else {
            XCTFail("Could not create AAPL position with JSON data.")
         }
      } else {
         XCTFail("Could not load AAPL JSON file.")
      }
      
      // BND JSON file
      if let jsonPathBND = testBundle.path(forResource: "BND", ofType: "json"),
         let jsonDataBND = try? Data(contentsOf: URL(fileURLWithPath: jsonPathBND)),
         let jsonDictionaryBND = (try? JSONSerialization.jsonObject(with: jsonDataBND, options: [])) as? JSONDictionary {
         if var positionBND = Position.forJSON(jsonDictionaryBND) {
            positionBND.memberType = .WatchList
            XCTAssertFalse(positionBND.isEmpty, "BND JSON position is empty.")
            XCTAssertFalse(positionBND.isComplete, "BND JSON position is complete.")
            XCTAssertEqual(positionBND.statusForDisplay, "Incomplete Data", "BND JSON position does not have the correct status.")
         } else {
            XCTFail("Could not create BND position with JSON data.")
         }
      } else {
         XCTFail("Could not load BND JSON file.")
      }
   }
   
   
   // MARK: - Helper Functions
   
   /**
    Randomly sets the specified position's member type property.
    
    - parameter position: The position whose member type property will be updated.
    */
   func randomlySetMemberTypeForPosition(_ position: inout Position) {
      position.memberType = randomPositionMemberType
   }
   
   
   /**
    Randomly sets some of the specified position's properties to nil.
    
    - parameter position: The position whose proprties will be updated.
    - parameter number:   The number of properties to randomly set to nil.  If a number is not specified, defaults to one or more, but not all properties.
    */
   func randomlySetNilPropertiesForPosition(_ position: inout Position, number: Int = Int(arc4random_uniform(UInt32(PositionBaseProperty.count - 1))) + 1) {
      guard number > 0 else { return }
      for _ in 1...number {
         if let randomPositionBaseProperty: PositionBaseProperty = PositionBaseProperty(rawValue: Int(arc4random_uniform(UInt32(PositionBaseProperty.count)))) {
            switch randomPositionBaseProperty {
            case .status:
               position.status = nil
            case .symbol:
               position.symbol = nil
            case .name:
               position.name = nil
            case .lastPrice:
               position.lastPrice = nil
            case .change:
               position.change = nil
            case .changePercent:
               position.changePercent = nil
            case .timeStamp:
               position.timeStamp = nil
            case .marketCap:
               position.marketCap = nil
            case .volume:
               position.volume = nil
            case .changeYTD:
               position.changeYTD = nil
            case .changePercentYTD:
               position.changePercentYTD = nil
            case .high:
               position.high = nil
            case .low:
               position.low = nil
            case .open:
               position.open = nil
            case .shares:
               position.shares = nil
            case .memberType:
               position.memberType = nil
            }
         }
      }
   }
}
