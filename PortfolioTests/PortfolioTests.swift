//
//  PortfolioTests.swift
//  PortfolioTests
//
//  Created by John Woolsey on 1/26/16.
//  Copyright © 2016 ExtremeBytes Software. All rights reserved.
//


import XCTest
@testable import Portfolio


class PortfolioTests: XCTestCase {
   
   // MARK: - Test Configuration
   
   override func setUp() {
      super.setUp()
      // Put setup code here. This method is called before the invocation of each test method in the class.
   }
   
   
   override func tearDown() {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
      super.tearDown()
   }
   
   
   // MARK: - App Coordinator Unit Tests
   
   /**
    App Coordinator shared instance initialization unit tests.
    */
   func testAppCoordinatorInitialization() {
      let sharedAppCoordinator = AppCoordinator.sharedInstance
      XCTAssertNotNil(sharedAppCoordinator, "Could not create shared instance of app coordinator.")
   }
}
