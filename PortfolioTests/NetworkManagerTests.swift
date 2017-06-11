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
      
      // Fetch BND data
      var positionBND: Position?
      var errorBND: Error?
      let expectationBND = expectation(description: "Wait for BND data to load.")
      NetworkManager.shared.fetchPosition(for: "BND") { position, error in
         positionBND = position
         errorBND = error
         expectationBND.fulfill()
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
      
      // BND data
      XCTAssertNotNil(positionBND, "BND position is nil.")
      XCTAssertNil(errorBND, "BND error is not nil.")
      positionAAPL?.memberType = .watchList
      if let positionBND = positionBND {
         XCTAssertFalse(positionBND.isEmpty, "BND position is empty.")
         XCTAssertFalse(positionBND.isComplete, "BND position is complete.")
         XCTAssertEqual(positionBND.statusForDisplay, "Incomplete Data", "BND position status is incorrect.")
      }
   }
}
