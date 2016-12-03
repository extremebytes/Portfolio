//
//  ErrorMessagesUITests.swift
//  Portfolio
//
//  Created by John Woolsey on 4/26/16.
//  Copyright © 2016 ExtremeBytes Software. All rights reserved.
//


import XCTest
@testable import Portfolio


class ErrorMessageUITests: XCTestCase {
   
   // MARK: - Test Configuration
   
   override func setUp() {
      super.setUp()
      continueAfterFailure = false
      app.launchArguments.append("UITesting")
      app.launch()
   }
   
   
   override func tearDown() {
      super.tearDown()
   }
   
   
   // MARK: - User Interface Tests
   
   /**
    Portfolio Creation Error error message UI tests.
    */
   func testPortfolioCreationError() {
      // Space for symbol, valid shares entered
      portfolioAddButton.tap()
      XCTAssertTrue(addPositionAlertView.exists, "Add Position alert view does not exist.")
      XCTAssertTrue(appWindow.frame.contains(addPositionAlertView.frame), "Add Position alert view is not visible.")
      addPositionSymbolTextField.typeText(" \r")
      addPositionSharesTextField.typeText("100\r")
      XCTAssertFalse(addPositionAlertView.exists, "Add Position alert view still exists.")
      expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: creationErrorAlertView, handler: nil)
      waitForExpectations(timeout: 5, handler: nil)
      XCTAssertTrue(creationErrorAlertView.exists, "Creation Error alert view does not exist.")
      XCTAssertTrue(appWindow.frame.contains(creationErrorAlertView.frame), "Creation Error alert view is not visible.")
      creationErrorAlertOkButton.tap()
      XCTAssertFalse(creationErrorAlertView.exists, "Creation Error alert view still exists.")
      
      // Invalid symbol, valid shares entered
      portfolioAddButton.tap()
      XCTAssertTrue(addPositionAlertView.exists, "Add Position alert view does not exist.")
      XCTAssertTrue(appWindow.frame.contains(addPositionAlertView.frame), "Add Position alert view is not visible.")
      addPositionSymbolTextField.typeText("12345")
      keyboardReturnButton.tap()
      addPositionSharesTextField.typeText("100\r")
      XCTAssertFalse(addPositionAlertView.exists, "Add Position alert view still exists.")
      expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: creationErrorAlertView, handler: nil)
      waitForExpectations(timeout: 5, handler: nil)
      XCTAssertTrue(creationErrorAlertView.exists, "Creation Error alert view does not exist.")
      XCTAssertTrue(appWindow.frame.contains(creationErrorAlertView.frame), "Creation Error alert view is not visible.")
      creationErrorAlertOkButton.tap()
      XCTAssertFalse(creationErrorAlertView.exists, "Creation Error alert view still exists.")
   }
   
   /**
    Watch List Creation Error error message UI tests.
    */
   func testWatchListCreationError() {
      watchListTab.tap()
      
      // Space for symbol entered
      watchListAddButton.tap()
      XCTAssertTrue(addPositionAlertView.exists, "Add Position alert view does not exist.")
      XCTAssertTrue(appWindow.frame.contains(addPositionAlertView.frame), "Add Position alert view is not visible.")
      addPositionSymbolTextField.typeText(" \r")
      XCTAssertFalse(addPositionAlertView.exists, "Add Position alert view still exists.")
      expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: creationErrorAlertView, handler: nil)
      waitForExpectations(timeout: 5, handler: nil)
      XCTAssertTrue(creationErrorAlertView.exists, "Creation Error alert view does not exist.")
      XCTAssertTrue(appWindow.frame.contains(creationErrorAlertView.frame), "Creation Error alert view is not visible.")
      creationErrorAlertOkButton.tap()
      XCTAssertFalse(creationErrorAlertView.exists, "Creation Error alert view still exists.")
      
      // Invalid symbol entered
      watchListAddButton.tap()
      XCTAssertTrue(addPositionAlertView.exists, "Add Position alert view does not exist.")
      XCTAssertTrue(appWindow.frame.contains(addPositionAlertView.frame), "Add Position alert view is not visible.")
      addPositionSymbolTextField.typeText("12345\r")
      XCTAssertFalse(addPositionAlertView.exists, "Add Position alert view still exists.")
      expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: creationErrorAlertView, handler: nil)
      waitForExpectations(timeout: 5, handler: nil)
      XCTAssertTrue(creationErrorAlertView.exists, "Creation Error alert view does not exist.")
      XCTAssertTrue(appWindow.frame.contains(creationErrorAlertView.frame), "Creation Error alert view is not visible.")
      creationErrorAlertOkButton.tap()
      XCTAssertFalse(creationErrorAlertView.exists, "Creation Error alert view still exists.")
   }
   
   
   /**
    Portfolio Duplicate Ticker Symbol error message UI tests.
    */
   func testPortfolioDuplicateTickerSymbolError() {
      // AAPL symbol, valid shares entered
      portfolioAddButton.tap()
      XCTAssertTrue(addPositionAlertView.exists, "Add Position alert view does not exist.")
      XCTAssertTrue(appWindow.frame.contains(addPositionAlertView.frame), "Add Position alert view is not visible.")
      addPositionSymbolTextField.typeText("aapl\r")
      addPositionSharesTextField.typeText("100\r")
      XCTAssertFalse(addPositionAlertView.exists, "Add Position alert view still exists.")
      expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: cellAAPL, handler: nil)
      waitForExpectations(timeout: 5, handler: nil)
      
      // AAPL symbol, valid shares entered
      portfolioAddButton.tap()
      XCTAssertTrue(addPositionAlertView.exists, "Add Position alert view does not exist.")
      XCTAssertTrue(appWindow.frame.contains(addPositionAlertView.frame), "Add Position alert view is not visible.")
      addPositionSymbolTextField.typeText("aapl\r")
      addPositionSharesTextField.typeText("200\r")
      XCTAssertFalse(addPositionAlertView.exists, "Add Position alert view still exists.")
      expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: duplicateTickerSymbolAlertView, handler: nil)
      waitForExpectations(timeout: 5, handler: nil)
      XCTAssertTrue(duplicateTickerSymbolAlertView.exists, "Duplicate Ticker Symbol alert view does not exist.")
      XCTAssertTrue(appWindow.frame.contains(duplicateTickerSymbolAlertView.frame), "Duplicate Ticker Symbol alert view is not visible.")
      duplicateTickerSymbolAlertOkButton.tap()
      XCTAssertFalse(duplicateTickerSymbolAlertView.exists, "Duplicate Ticker Symbol alert view still exists.")
   }
   
   
   /**
    Watch List Duplicate Ticker Symbol error message UI tests.
    */
   func testWatchListDuplicateTickerSymbolError() {
      watchListTab.tap()
      
      // AAPL symbol entered
      watchListAddButton.tap()
      XCTAssertTrue(addPositionAlertView.exists, "Add Position alert view does not exist.")
      XCTAssertTrue(appWindow.frame.contains(addPositionAlertView.frame), "Add Position alert view is not visible.")
      addPositionSymbolTextField.typeText("aapl\r")
      XCTAssertFalse(addPositionAlertView.exists, "Add Position alert view still exists.")
      expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: cellAAPL, handler: nil)
      waitForExpectations(timeout: 5, handler: nil)
      
      // AAPL symbol entered
      watchListAddButton.tap()
      XCTAssertTrue(addPositionAlertView.exists, "Add Position alert view does not exist.")
      XCTAssertTrue(appWindow.frame.contains(addPositionAlertView.frame), "Add Position alert view is not visible.")
      addPositionSymbolTextField.typeText("aapl\r")
      XCTAssertFalse(addPositionAlertView.exists, "Add Position alert view still exists.")
      expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: duplicateTickerSymbolAlertView, handler: nil)
      waitForExpectations(timeout: 5, handler: nil)
      XCTAssertTrue(duplicateTickerSymbolAlertView.exists, "Duplicate Ticker Symbol alert view does not exist.")
      XCTAssertTrue(appWindow.frame.contains(duplicateTickerSymbolAlertView.frame), "Duplicate Ticker Symbol alert view is not visible.")
      duplicateTickerSymbolAlertOkButton.tap()
      XCTAssertFalse(duplicateTickerSymbolAlertView.exists, "Duplicate Ticker Symbol alert view still exists.")
   }
   
   
   /**
    Portfolio Invalid Ticker Symbol error message UI tests.
    */
   func testPortfolioInvalidTickerSymbolError() {
      // No text entered
      portfolioAddButton.tap()
      XCTAssertTrue(addPositionAlertView.exists, "Add Position alert view does not exist.")
      XCTAssertTrue(appWindow.frame.contains(addPositionAlertView.frame), "Add Position alert view is not visible.")
      addPositionAddButton.tap()
      XCTAssertFalse(addPositionAlertView.exists, "Add Position alert view still exists.")
      expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: invalidTickerSymbolAlertView, handler: nil)
      waitForExpectations(timeout: 5, handler: nil)
      XCTAssertTrue(invalidTickerSymbolAlertView.exists, "Invalid Ticker Symbol alert view does not exist.")
      XCTAssertTrue(appWindow.frame.contains(invalidTickerSymbolAlertView.frame), "Invalid Ticker Symbol alert view is not visible.")
      invalidTickerSymbolAlertOkButton.tap()
      XCTAssertFalse(invalidTickerSymbolAlertView.exists, "Invalid Ticker Symbol alert view still exists.")
      
      // No symbol, valid shares entered
      portfolioAddButton.tap()
      XCTAssertTrue(addPositionAlertView.exists, "Add Position alert view does not exist.")
      XCTAssertTrue(appWindow.frame.contains(addPositionAlertView.frame), "Add Position alert view is not visible.")
      addPositionSymbolTextField.typeText("\r")
      addPositionSharesTextField.typeText("100\r")
      XCTAssertFalse(addPositionAlertView.exists, "Add Position alert view still exists.")
      expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: invalidTickerSymbolAlertView, handler: nil)
      waitForExpectations(timeout: 5, handler: nil)
      XCTAssertTrue(invalidTickerSymbolAlertView.exists, "Invalid Ticker Symbol alert view does not exist.")
      XCTAssertTrue(appWindow.frame.contains(invalidTickerSymbolAlertView.frame), "Invalid Ticker Symbol alert view is not visible.")
      invalidTickerSymbolAlertOkButton.tap()
      XCTAssertFalse(invalidTickerSymbolAlertView.exists, "Invalid Ticker Symbol alert view still exists.")
   }
   
   
   /**
    Watch List Invalid Ticker Symbol error message UI tests.
    */
   func testWatchListInvalidTickerSymbolError() {
      watchListTab.tap()
      
      // No text entered
      watchListAddButton.tap()
      XCTAssertTrue(addPositionAlertView.exists, "Add Position alert view does not exist.")
      XCTAssertTrue(appWindow.frame.contains(addPositionAlertView.frame), "Add Position alert view is not visible.")
      addPositionAddButton.tap()
      XCTAssertFalse(addPositionAlertView.exists, "Add Position alert view still exists.")
      expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: invalidTickerSymbolAlertView, handler: nil)
      waitForExpectations(timeout: 5, handler: nil)
      XCTAssertTrue(invalidTickerSymbolAlertView.exists, "Invalid Ticker Symbol alert view does not exist.")
      XCTAssertTrue(appWindow.frame.contains(invalidTickerSymbolAlertView.frame), "Invalid Ticker Symbol alert view is not visible.")
      invalidTickerSymbolAlertOkButton.tap()
      XCTAssertFalse(invalidTickerSymbolAlertView.exists, "Invalid Ticker Symbol alert view still exists.")
   }
   
   
   /**
    Portfolio Invalid Share Count error message UI tests.
    */
   func testPortfolioInvalidShareCount() {
      // Valid symbol, no shares entered
      portfolioAddButton.tap()
      XCTAssertTrue(addPositionAlertView.exists, "Add Position alert view does not exist.")
      XCTAssertTrue(appWindow.frame.contains(addPositionAlertView.frame), "Add Position alert view is not visible.")
      addPositionSymbolTextField.typeText("aapl\r")
      addPositionSharesTextField.typeText("\r")
      XCTAssertFalse(addPositionAlertView.exists, "Add Position alert view still exists.")
      expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: invalidShareCountAlertView, handler: nil)
      waitForExpectations(timeout: 5, handler: nil)
      XCTAssertTrue(invalidShareCountAlertView.exists, "Invalid Share Count alert view does not exist.")
      XCTAssertTrue(appWindow.frame.contains(invalidShareCountAlertView.frame), "Invalid Share Count alert view is not visible.")
      invalidShareCountAlertOkButton.tap()
      XCTAssertFalse(invalidShareCountAlertView.exists, "Invalid Share Count alert view still exists.")
      
      // Valid symbol, invalid shares entered
      portfolioAddButton.tap()
      XCTAssertTrue(addPositionAlertView.exists, "Add Position alert view does not exist.")
      XCTAssertTrue(appWindow.frame.contains(addPositionAlertView.frame), "Add Position alert view is not visible.")
      addPositionSymbolTextField.typeText("aapl\r")
      addPositionSharesTextField.typeText("9.8.7\r")
      XCTAssertFalse(addPositionAlertView.exists, "Add Position alert view still exists.")
      expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: invalidShareCountAlertView, handler: nil)
      waitForExpectations(timeout: 5, handler: nil)
      XCTAssertTrue(invalidShareCountAlertView.exists, "Invalid Share Count alert view does not exist.")
      XCTAssertTrue(appWindow.frame.contains(invalidShareCountAlertView.frame), "Invalid Share Count alert view is not visible.")
      invalidShareCountAlertOkButton.tap()
      XCTAssertFalse(invalidShareCountAlertView.exists, "Invalid Share Count alert view still exists.")
   }
}
