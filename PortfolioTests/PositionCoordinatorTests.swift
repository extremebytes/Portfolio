//
//  PositionCoordinatorTests.swift
//  Portfolio
//
//  Created by John Woolsey on 4/1/16.
//  Copyright © 2016 ExtremeBytes Software. All rights reserved.
//


import XCTest
@testable import Portfolio


class PositionCoordinatorTests: XCTestCase {
   
   // MARK: - Test Configuration
   
   override func setUp() {
      super.setUp()
      // Put setup code here. This method is called before the invocation of each test method in the class.
   }
   
   
   override func tearDown() {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
      super.tearDown()
   }
   
   
   // MARK: - Position Coordinator Unit Tests
   
   /**
    PositionMemberType enum unit tests.
    */
   func testPositionMemberType() {
      let portfolioMemberType = PositionMemberType.Portfolio
      XCTAssertEqual(portfolioMemberType.title, "Portfolio", "Position member type Portfolio title is incorrect.")
      let watchListMemberType = PositionMemberType.WatchList
      XCTAssertEqual(watchListMemberType.title, "Watch List", "Position member type Watch List title is incorrect.")
   }
   
   
   /**
    Position Coordinator inputDateFormatter and outputDateFormatter properties unit tests.
    */
   // TODO: Test outputDateFormatter
   func testDateFormatters() {
      let fixedDateFormatter = DateFormatter()
      fixedDateFormatter.dateStyle = .medium
      fixedDateFormatter.timeStyle = .medium
      fixedDateFormatter.locale = Locale(identifier: "en_US")
      fixedDateFormatter.timeZone = TimeZone(abbreviation: "GMT")
      
      let inputDateString = "Tue Apr 5 10:59:28 UTC-04:00 2016"
      let expectedOutputDateString = "Apr 5, 2016, 2:59:28 PM"
      
      if let inputDate = PositionCoordinator.inputDateFormatter.date(from: inputDateString) {
         let calculatedOutputDateString = fixedDateFormatter.string(from: inputDate)
         XCTAssertEqual(calculatedOutputDateString, expectedOutputDateString, "Date formatting is incorrect.")
      } else {
         XCTFail("Input date formatter could not create date.")
      }
   }
   
   
   /**
    Position Coordinator dollarNumberFormatter property unit tests.
    */
   func testNumberFormatters() {
      var numberDouble = 18.346
      var numberString = PositionCoordinator.dollarNumberFormatter.string(from: NSNumber(value: numberDouble as Double))
      XCTAssertEqual(numberString, "$18.35", "Dollar number formatting is incorrect.")
      numberDouble = 9.1
      numberString = PositionCoordinator.dollarNumberFormatter.string(from: NSNumber(value: numberDouble as Double))
      XCTAssertEqual(numberString, "$9.10", "Dollar number formatting is incorrect.")
   }
   
   
   /**
    Position Coordinator cellSizeForScreenWidth(screenWidth,positionType) function unit tests.
    */
   func testCellSizeForScreenWidthPositionType() {
      let screenWidths: [CGFloat] = [320, 375, 414, 480, 568, 667, 736, 768, 1024, 1366]
      let deviceScreenWidth = UIScreen.main.bounds.width
      XCTAssertTrue(screenWidths.contains(deviceScreenWidth), "Screen width collection does not contain actual device width of '\(deviceScreenWidth)'.")
      
      // Portfolio
      for screenWidth in screenWidths {
         let cellSize = PositionCoordinator.cellSizeForScreenWidth(screenWidth, positionType: .Portfolio)
         let actualNumberOfcellsPerRow = Int(floor((screenWidth + PositionCoordinator.spacerSize.width)/(cellSize.width + PositionCoordinator.spacerSize.width)))
         var expectednumberOfcellsPerRow: Int
         switch screenWidth {
         case 320:  // 3.5", 4" and 4.7"(Zoom) iPhone Portrait
            fallthrough
         case 375:  // 4.7" and 5.5"(Zoom) iPhone Portrait
            fallthrough
         case 414:  // 5.5" iPhone Portrait
            expectednumberOfcellsPerRow = 1
         case 480:  // 3.5" iPhone Landscape
            fallthrough
         case 568:  // 4" iPhone Landscape
            fallthrough
         case 667:  // 4.7" and 5.5"(Zoom) iPhone Landscape
            expectednumberOfcellsPerRow = 2
         case 736:  // 5.5" iPhone Landscape
            fallthrough
         case 768:  // 7.9" and 9.7" iPad Portrait
            expectednumberOfcellsPerRow = 3
         case 1024:  // 7.9" and 9.7" iPad Landscape and 12.9" iPad Portrait
            expectednumberOfcellsPerRow = 4
         case 1366:  // 12.9" iPad Landscape
            expectednumberOfcellsPerRow = 5
         default:
            expectednumberOfcellsPerRow = 0
            XCTFail("Hit unexpected screen size 'default' case.")
         }
         XCTAssertEqual(actualNumberOfcellsPerRow, expectednumberOfcellsPerRow, "Number of Portfolio cells is incorrect for screenWidth of '\(screenWidth)'.")
      }
      
      // Watch List
      for screenWidth in screenWidths {
         let cellSize = PositionCoordinator.cellSizeForScreenWidth(screenWidth, positionType: .WatchList)
         let actualNumberOfcellsPerRow = Int(floor((screenWidth + PositionCoordinator.spacerSize.width)/(cellSize.width + PositionCoordinator.spacerSize.width)))
         var expectednumberOfcellsPerRow: Int
         switch screenWidth {
         case 320:  // 3.5", 4" and 4.7"(Zoom) iPhone Portrait
            fallthrough
         case 375:  // 4.7" and 5.5"(Zoom) iPhone Portrait
            fallthrough
         case 414:  // 5.5" iPhone Portrait
            expectednumberOfcellsPerRow = 1
         case 480:  // 3.5" iPhone Landscape
            fallthrough
         case 568:  // 4" iPhone Landscape
            fallthrough
         case 667:  // 4.7" and 5.5"(Zoom) iPhone Landscape
            expectednumberOfcellsPerRow = 2
         case 736:  // 5.5" iPhone Landscape
            fallthrough
         case 768:  // 7.9" and 9.7" iPad Portrait
            expectednumberOfcellsPerRow = 3
         case 1024:  // 7.9" and 9.7" iPad Landscape and 12.9" iPad Portrait
            expectednumberOfcellsPerRow = 4
         case 1366:  // 12.9" iPad Landscape
            expectednumberOfcellsPerRow = 5
         default:
            expectednumberOfcellsPerRow = 0
            XCTFail("Hit unexpected screen size 'default' case.")
         }
         XCTAssertEqual(actualNumberOfcellsPerRow, expectednumberOfcellsPerRow, "Number of Watch List cells is incorrect for screenWidth of '\(screenWidth)'.")
      }
   }
   
   
   /**
    Position Coordinator insertionIndexForSymbol(symbol,from,into) function unit tests.
    */
   func testInsertionIndexForSymbolFromInto() {
      let savedSymbols = ["AAPL", "BND", "CSCO", "IBM", "TSLA"]
      var currentSymbols: [String] = []
      var insertionIndex = PositionCoordinator.insertionIndexForSymbol("CSCO", from: savedSymbols, into: currentSymbols)
      XCTAssertEqual(insertionIndex, 0, "Initial symbol insertion index is incorrect.")
      currentSymbols = ["CSCO"]
      insertionIndex = PositionCoordinator.insertionIndexForSymbol("AAPL", from: savedSymbols, into: currentSymbols)
      XCTAssertEqual(insertionIndex, 0, "First predecessor symbol insertion index is incorrect.")
      insertionIndex = PositionCoordinator.insertionIndexForSymbol("TSLA", from: savedSymbols, into: currentSymbols)
      XCTAssertEqual(insertionIndex, 1, "Last successor symbol insertion index is incorrect.")
      currentSymbols = ["AAPL", "CSCO", "TSLA"]
      insertionIndex = PositionCoordinator.insertionIndexForSymbol("BND", from: savedSymbols, into: currentSymbols)
      XCTAssertEqual(insertionIndex, 1, "Middle predecessor symbol insertion index is incorrect.")
      insertionIndex = PositionCoordinator.insertionIndexForSymbol("IBM", from: savedSymbols, into: currentSymbols)
      XCTAssertEqual(insertionIndex, 2, "Middle successor symbol insertion index is incorrect.")
      insertionIndex = PositionCoordinator.insertionIndexForSymbol("CSCO", from: savedSymbols, into: currentSymbols)
      XCTAssertNil(insertionIndex, "Existing symbol insertion index is incorrect.")
   }
}
