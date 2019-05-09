//
//  NetworkManagerTests.swift
//  Portfolio
//
//  Created by John Woolsey on 3/30/16.
//  Copyright © 2016 ExtremeBytes Software. All rights reserved.
//


import XCTest
@testable import Portfolio


class NetworkManagerTests: XCTestCase {
   
   // MARK: - Properties
   
   
   // MARK: - Test Configuration
   
   override func setUp() {
      super.setUp()
      // Put setup code here. This method is called before the invocation of each test method in the class.
   }
   
   
   override func tearDown() {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
      super.tearDown()
   }
   
   
   // MARK: - Network Manager Class Unit Tests
   
   /**
    Network Manager fetchPosition(for,completion) function unit tests.
    */
   func testFetchPositionForCompletion() {
      // Fetch empty data
      var positionEmpty: Position?
      var errorEmpty: Error?
      let expectationEmpty = expectation(description: "Wait for empty data to load.")
      NetworkManager.shared.fetchPosition(for: "") { position, error in
         positionEmpty = position
         errorEmpty = error
         expectationEmpty.fulfill()
      }
      
      // Fetch invalid symbol data
      var positionInvalidSymbol: Position?
      var errorInvalidSymbol: Error?
      let expectationInvalidSymbol = expectation(description: "Wait for invalid symbol data to load.")
      NetworkManager.shared.fetchPosition(for: "INVALID") { position, error in
         positionInvalidSymbol = position
         errorInvalidSymbol = error
         expectationInvalidSymbol.fulfill()
      }
      
      // Fetch AAPL data
      var positionAAPL: Position?
      var errorAAPL: Error?
      let expectationAAPL = expectation(description: "Wait for AAPL data to load.")
      NetworkManager.shared.fetchPosition(for: "AAPL") { position, error in
         positionAAPL = position
         errorAAPL = error
         expectationAAPL.fulfill()
      }
      
      // Fetch SHIP data
      var positionSHIP: Position?
      var errorSHIP: Error?
      let expectationSHIP = expectation(description: "Wait for SHIP data to load.")
      NetworkManager.shared.fetchPosition(for: "SHIP") { position, error in
         positionSHIP = position
         errorSHIP = error
         expectationSHIP.fulfill()
      }
      
      // Fetches completed
      waitForExpectations(timeout: 5)
      
      // Empty data
      XCTAssertNil(positionEmpty, "Empty position is not nil.")
      XCTAssertNotNil(errorEmpty, "Empty error is nil.")
      if let errorEmpty = errorEmpty as? NetworkError {
         XCTAssertEqual(errorEmpty, NetworkError.invalidRequest, "Empty error is not an invalid request.")
      }
      
      // Invalid symbol data
      XCTAssertNil(positionInvalidSymbol, "Invalid symbol position is not nil.")
      XCTAssertNil(errorInvalidSymbol, "Invalid symbol error is not nil.")
      
      // AAPL data
      XCTAssertNotNil(positionAAPL, "AAPL position is nil.")
      XCTAssertNil(errorAAPL, "AAPL error is not nil.")
      positionAAPL?.memberType = .watchList
      if let positionAAPL = positionAAPL {
         XCTAssertFalse(positionAAPL.isEmpty, "AAPL position is empty.")
         XCTAssertTrue(positionAAPL.isComplete, "AAPL position is not complete.")
         XCTAssertEqual(positionAAPL.statusForDisplay,
                        positionAAPL.timeStampForDisplay,
                        "AAPL position status is incorrect.")
      }
      
      // SHIP data
      XCTAssertNotNil(positionSHIP, "SHIP position is nil.")
      XCTAssertNil(errorSHIP, "SHIP error is not nil.")
      positionSHIP?.memberType = .watchList
      if let positionSHIP = positionSHIP {
         XCTAssertFalse(positionSHIP.isEmpty, "SHIP position is empty.")
         XCTAssertFalse(positionSHIP.isComplete, "SHIP position is complete.")
         XCTAssertEqual(positionSHIP.statusForDisplay, "Incomplete Data", "SHIP position status is incorrect.")
      }
   }
}
