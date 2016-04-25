//
//  PortfolioUITests.swift
//  PortfolioUITests
//
//  Created by John Woolsey on 1/26/16.
//  Copyright © 2016 ExtremeBytes Software. All rights reserved.
//


import XCTest
@testable import Portfolio


class PortfolioUITests: XCTestCase {
   
   // MARK: - Properties
   
   let app = XCUIApplication()
   
   var navigationBarTitle: String { return app.navigationBars.element.identifier }
   
   var appWindow: XCUIElement { return app.windows.elementBoundByIndex(0) }
   var keyboardReturnButton: XCUIElement { return app.buttons["Return"] }
   var portfolioTab: XCUIElement { return app.tabBars.buttons["Portfolio"] }
   var watchListTab: XCUIElement { return app.tabBars.buttons["Watch List"] }
   var portfolioAddButton: XCUIElement { return app.navigationBars["Portfolio"].buttons["Add"] }
   var portfolioEditButton: XCUIElement { return app.navigationBars["Portfolio"].buttons["Edit"] }
   var portfolioDoneButton: XCUIElement { return app.navigationBars["Portfolio"].buttons["Done"] }
   var editLabel: XCUIElement { return app.staticTexts["Edit Mode Enabled"] }
   var dismissRegion: XCUIElement { return XCUIApplication().otherElements["PopoverDismissRegion"] }
   var addPositionAlertView: XCUIElement { return app.alerts["Add Position"] }
   var addPositionSymbolTextField: XCUIElement { return addPositionAlertView.collectionViews.textFields["ticker symbol"] }
   var addPositionSharesTextField: XCUIElement { return addPositionAlertView.collectionViews.textFields["number of shares"] }
   var addPositionAddButton: XCUIElement { return addPositionAlertView.collectionViews.buttons["Add"] }
   var addPositionCancelButton: XCUIElement { return addPositionAlertView.collectionViews.buttons["Cancel"] }
   var confirmDeleteSheetCancelButton: XCUIElement { return app.sheets["Confirm Delete"].buttons["Cancel"] }
   var confirmDeleteSheetDeleteButton: XCUIElement { return app.sheets["Confirm Delete"].buttons["Delete"] }
   var cellAAPL: XCUIElement { return cells.staticTexts["AAPL"] }
   var cellTSLA: XCUIElement { return cells.staticTexts["TSLA"] }
   
   var cells: XCUIElementQuery { return app.collectionViews.cells }  // TODO: Need distinct Portfolio and Watch List versions?
   
   
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
   
   func testTabMoves() {
      XCTAssertEqual(navigationBarTitle, "Portfolio")
      watchListTab.tap()
      XCTAssertEqual(navigationBarTitle, "Watch List")
      portfolioTab.tap()
      XCTAssertEqual(navigationBarTitle, "Portfolio")
   }
   
   
   func testAddWithCancel() {
      XCTAssertEqual(cells.count, 0, "Incorrect number of Portfolio cells.")
      portfolioAddButton.tap()
      XCTAssertTrue(addPositionAlertView.exists, "Add position alert view does not exist.")
      XCTAssertTrue(CGRectContainsRect(appWindow.frame, addPositionAlertView.frame), "Add position alert view is not visible.")
      addPositionCancelButton.tap()
      XCTAssertFalse(addPositionAlertView.exists, "Add position alert view still exists.")
      XCTAssertEqual(cells.count, 0, "Incorrect number of Portfolio cells.")
   }
   
   
   func testPositions() {
      XCTAssertEqual(cells.count, 0, "Incorrect number of Portfolio cells.")

      // Add AAPL position
      portfolioAddButton.tap()
      XCTAssertTrue(addPositionAlertView.exists, "Add position alert view does not exist.")
      XCTAssertTrue(CGRectContainsRect(appWindow.frame, addPositionAlertView.frame), "Add position alert view is not visible.")
      addPositionSymbolTextField.typeText("aapl")
      keyboardReturnButton.tap()
      addPositionSharesTextField.typeText("100")
      addPositionAddButton.tap()
      expectationForPredicate(NSPredicate(format: "exists == 1"), evaluatedWithObject: cellAAPL, handler: nil)
      waitForExpectationsWithTimeout(5, handler: nil)
      XCTAssertFalse(addPositionAlertView.exists, "Add position alert view still exists.")
      XCTAssertTrue(cellAAPL.hittable, "AAPL cell is not hittable.")
      XCTAssertEqual(cells.count, 1, "Incorrect number of Portfolio cells.")
      
      // Cancel AAPL deletion
      portfolioEditButton.tap()
      XCTAssertTrue(editLabel.exists, "Edit mode view does not exist.")
      XCTAssertTrue(CGRectContainsRect(appWindow.frame, editLabel.frame), "Edit mode view is not visible.")
      cellAAPL.doubleTap()
      if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
         dismissRegion.tap()
      } else {
         confirmDeleteSheetCancelButton.tap()
      }
      portfolioDoneButton.tap()
      XCTAssertFalse(editLabel.exists, "Edit mode view still exists.")
      XCTAssertEqual(cells.count, 1, "Incorrect number of Portfolio cells.")
      
      // Add TSLA position
      portfolioAddButton.tap()
      XCTAssertTrue(addPositionAlertView.exists, "Add position alert view does not exist.")
      XCTAssertTrue(CGRectContainsRect(appWindow.frame, addPositionAlertView.frame), "Add position alert view is not visible.")
      addPositionSymbolTextField.typeText("tsla\r")
      addPositionSharesTextField.typeText("50.89\r")
      expectationForPredicate(NSPredicate(format: "exists == 1"), evaluatedWithObject: cellTSLA, handler: nil)
      waitForExpectationsWithTimeout(5, handler: nil)
      XCTAssertFalse(addPositionAlertView.exists, "Add position alert view still exists.")
      XCTAssertTrue(cellTSLA.hittable, "TSLA cell is not hittable.")
      XCTAssertEqual(cells.count, 2, "Incorrect number of Portfolio cells.")
      
      // Enter Edit mode
      portfolioEditButton.tap()
      XCTAssertTrue(editLabel.exists, "Edit mode view does not exist.")
      XCTAssertTrue(CGRectContainsRect(appWindow.frame, editLabel.frame), "Edit mode view is not visible.")
      
      // Move positions
      XCTAssertTrue(cellAAPL.hittable, "AAPL cell is not hittable.")
      XCTAssertTrue(cellTSLA.hittable, "TSLA cell is not hittable.")
      XCTAssertEqual("AAPL", cells.elementBoundByIndex(0).staticTexts.elementBoundByIndex(0).label, "AAPL is in incorrect location.")
      XCTAssertEqual("TSLA", cells.elementBoundByIndex(1).staticTexts.elementBoundByIndex(0).label, "TSLA is in incorrect location.")
      cellTSLA.pressForDuration(0.5, thenDragToElement: cellAAPL)
      XCTAssertEqual("AAPL", cells.elementBoundByIndex(1).staticTexts.elementBoundByIndex(0).label, "AAPL is in incorrect location.")
      XCTAssertEqual("TSLA", cells.elementBoundByIndex(0).staticTexts.elementBoundByIndex(0).label, "TSLA is in incorrect location.")
      XCTAssertTrue(cellAAPL.hittable, "AAPL cell is not hittable.")
      XCTAssertTrue(cellTSLA.hittable, "TSLA cell is not hittable.")
      
      // Delete AAPL position
      cellAAPL.doubleTap()
      confirmDeleteSheetDeleteButton.tap()
      portfolioDoneButton.tap()
      XCTAssertFalse(editLabel.exists, "Edit mode view still exists.")
      // Testing decrementing collection view cell count not working properly due to cell caching
      // XCTAssertEqual(portfolioCells.count, 0, "Incorrect number of Portfolio cells.")
      XCTAssertFalse(cellAAPL.hittable, "AAPL cell is still hittable.")
      XCTAssertTrue(cellTSLA.hittable, "TSLA cell is not hittable.")
   }
   
   
   // MARK - Helper Functions
   
}
