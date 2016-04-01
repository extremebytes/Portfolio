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
    Position Coordinator cellSizeForScreenWidth(screenWidth, positionType) function unit tests.
    */
   func testCellSizeForScreenWidthPositionType() {
      let screenWidths: [CGFloat] = [320, 375, 414, 480, 568, 667, 736, 768, 1024, 1366]
      let deviceScreenWidth = UIScreen.mainScreen().bounds.width
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
}
