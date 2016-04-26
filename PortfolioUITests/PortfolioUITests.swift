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
   
   var portfolioTab: XCUIElement { return app.tabBars.buttons["Portfolio"] }
   var portfolioAddButton: XCUIElement { return app.navigationBars["Portfolio"].buttons["Add"] }
   var portfolioEditButton: XCUIElement { return app.navigationBars["Portfolio"].buttons["Edit"] }
   var portfolioDoneButton: XCUIElement { return app.navigationBars["Portfolio"].buttons["Done"] }
   
   var watchListTab: XCUIElement { return app.tabBars.buttons["Watch List"] }
   var watchListAddButton: XCUIElement { return app.navigationBars["Watch List"].buttons["Add"] }
   var watchListEditButton: XCUIElement { return app.navigationBars["Watch List"].buttons["Edit"] }
   var watchListDoneButton: XCUIElement { return app.navigationBars["Watch List"].buttons["Done"] }
   
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
   
   /**
    Tab moves UI tests.
    */
   func testTabMoves() {
      XCTAssertEqual(navigationBarTitle, "Portfolio")
      watchListTab.tap()
      XCTAssertEqual(navigationBarTitle, "Watch List")
      portfolioTab.tap()
      XCTAssertEqual(navigationBarTitle, "Portfolio")
   }
   
   
   /**
    Requests then cancels Portfolio position addition UI tests.
    */
   func testPortfolioAddWithCancel() {
      XCTAssertEqual(navigationBarTitle, "Portfolio")
      XCTAssertEqual(cells.count, 0, "Incorrect number of Portfolio cells.")
      portfolioAddButton.tap()
      XCTAssertTrue(addPositionAlertView.exists, "Add position alert view does not exist.")
      XCTAssertTrue(CGRectContainsRect(appWindow.frame, addPositionAlertView.frame), "Add position alert view is not visible.")
      addPositionCancelButton.tap()
      XCTAssertFalse(addPositionAlertView.exists, "Add position alert view still exists.")
      XCTAssertEqual(cells.count, 0, "Incorrect number of Portfolio cells.")
   }
   
   
   /**
    Requests then cancels Watch List position addition UI tests.
    */
   func testWatchListAddWithCancel() {
      watchListTab.tap()
      XCTAssertEqual(navigationBarTitle, "Watch List")
      XCTAssertEqual(cells.count, 0, "Incorrect number of Watch List cells.")
      watchListAddButton.tap()
      XCTAssertTrue(addPositionAlertView.exists, "Add position alert view does not exist.")
      XCTAssertTrue(CGRectContainsRect(appWindow.frame, addPositionAlertView.frame), "Add position alert view is not visible.")
      addPositionCancelButton.tap()
      XCTAssertFalse(addPositionAlertView.exists, "Add position alert view still exists.")
      XCTAssertEqual(cells.count, 0, "Incorrect number of Watch List cells.")
   }
   
   
   /**
    Portfolio position editing UI tests.
    */
   func testPortfolioPositionEditing() {
      XCTAssertEqual(navigationBarTitle, "Portfolio")
      XCTAssertEqual(cells.count, 0, "Incorrect number of Portfolio cells.")

      // Add AAPL position
      addPortfolioPositionAAPL()
      XCTAssertEqual(cells.count, 1, "Incorrect number of Portfolio cells.")
      
      // Add TSLA position
      addPortfolioPositionTSLA()
      XCTAssertEqual(cells.count, 2, "Incorrect number of Portfolio cells.")
      
      // Enable position editing
      enablePortfolioEditing()
      
      // Request then cancel AAPL deletion
      cellAAPL.doubleTap()
      if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
         dismissRegion.tap()
      } else {
         confirmDeleteSheetCancelButton.tap()
      }
      XCTAssertEqual(cells.count, 2, "Incorrect number of Portfolio cells.")
      
      // Move TSLA position to AAPL
      swapPositions()
      
      // Delete AAPL position
      deletePositionAAPL()
      // Testing decrementing collection view cell count not working properly due to cell caching
      // XCTAssertEqual(cells.count, 0, "Incorrect number of Portfolio cells.")
      XCTAssertFalse(cellAAPL.hittable, "AAPL cell is still hittable.")
      XCTAssertTrue(cellTSLA.hittable, "TSLA cell is not hittable.")
      
      // Disable position editing
      disablePortfolioEditing()
   }
   
   
   /**
    Watch List position editing UI tests.
    */
   func testWatchListPositionEditing() {
      watchListTab.tap()
      XCTAssertEqual(navigationBarTitle, "Watch List")
      XCTAssertEqual(cells.count, 0, "Incorrect number of Watch List cells.")
      
      // Add AAPL position
      addWatchListPositionAAPL()
      XCTAssertEqual(cells.count, 1, "Incorrect number of Watch List cells.")
      
      // Add TSLA position
      addWatchListPositionTSLA()
      XCTAssertEqual(cells.count, 2, "Incorrect number of Watch List cells.")
      
      // Enable position editing
      enableWatchListEditing()
      
      // Request then cancel AAPL deletion
      cellAAPL.doubleTap()
      if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
         dismissRegion.tap()
      } else {
         confirmDeleteSheetCancelButton.tap()
      }
      XCTAssertEqual(cells.count, 2, "Incorrect number of Watch List cells.")
      
      // Move TSLA position to AAPL
      swapPositions()
      
      // Delete AAPL position
      deletePositionAAPL()
      // Testing decrementing collection view cell count not working properly due to cell caching
      // XCTAssertEqual(cells.count, 0, "Incorrect number of Watch List cells.")
      XCTAssertFalse(cellAAPL.hittable, "AAPL cell is still hittable.")
      XCTAssertTrue(cellTSLA.hittable, "TSLA cell is not hittable.")
      
      // Disable position editing
      disableWatchListEditing()
   }

   
   // MARK: - Helper Functions (includes assertions)
   
   /**
    Adds AAPL position to Portfolio.
    
    Keyboard return and Add button utilized.
    */
   func addPortfolioPositionAAPL() {
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
   }
   
   
   /**
    Adds AAPL position to Watch List.
    
    Keyboard Add button utilized.
    */
   func addWatchListPositionAAPL() {
      watchListAddButton.tap()
      XCTAssertTrue(addPositionAlertView.exists, "Add position alert view does not exist.")
      XCTAssertTrue(CGRectContainsRect(appWindow.frame, addPositionAlertView.frame), "Add position alert view is not visible.")
      addPositionSymbolTextField.typeText("aapl")
      addPositionAddButton.tap()
      expectationForPredicate(NSPredicate(format: "exists == 1"), evaluatedWithObject: cellAAPL, handler: nil)
      waitForExpectationsWithTimeout(5, handler: nil)
      XCTAssertFalse(addPositionAlertView.exists, "Add position alert view still exists.")
      XCTAssertTrue(cellAAPL.hittable, "AAPL cell is not hittable.")
   }

   
   /**
    Adds TSLA position to Portfolio.
    
    Text based returns utilized.
    */
   func addPortfolioPositionTSLA() {
      portfolioAddButton.tap()
      XCTAssertTrue(addPositionAlertView.exists, "Add position alert view does not exist.")
      XCTAssertTrue(CGRectContainsRect(appWindow.frame, addPositionAlertView.frame), "Add position alert view is not visible.")
      addPositionSymbolTextField.typeText("tsla\r")
      addPositionSharesTextField.typeText("50.89\r")
      expectationForPredicate(NSPredicate(format: "exists == 1"), evaluatedWithObject: cellTSLA, handler: nil)
      waitForExpectationsWithTimeout(5, handler: nil)
      XCTAssertFalse(addPositionAlertView.exists, "Add position alert view still exists.")
      XCTAssertTrue(cellTSLA.hittable, "TSLA cell is not hittable.")
   }
   
   
   /**
    Adds TSLA position to Watch List.
    
    Text based return utilized.
    */
   func addWatchListPositionTSLA() {
      watchListAddButton.tap()
      XCTAssertTrue(addPositionAlertView.exists, "Add position alert view does not exist.")
      XCTAssertTrue(CGRectContainsRect(appWindow.frame, addPositionAlertView.frame), "Add position alert view is not visible.")
      addPositionSymbolTextField.typeText("tsla\r")
      expectationForPredicate(NSPredicate(format: "exists == 1"), evaluatedWithObject: cellTSLA, handler: nil)
      waitForExpectationsWithTimeout(5, handler: nil)
      XCTAssertFalse(addPositionAlertView.exists, "Add position alert view still exists.")
      XCTAssertTrue(cellTSLA.hittable, "TSLA cell is not hittable.")
   }

   
   /**
    Enables Portfolio editing mode.
    */
   func enablePortfolioEditing() {
      portfolioEditButton.tap()
      XCTAssertTrue(editLabel.exists, "Edit mode view does not exist.")
      XCTAssertTrue(CGRectContainsRect(appWindow.frame, editLabel.frame), "Edit mode view is not visible.")
   }
   
   
   /**
    Enables Watch List editing mode
    */
   func enableWatchListEditing() {
      watchListEditButton.tap()
      XCTAssertTrue(editLabel.exists, "Edit mode view does not exist.")
      XCTAssertTrue(CGRectContainsRect(appWindow.frame, editLabel.frame), "Edit mode view is not visible.")
   }

   
   /**
    Disables Portfolio editing mode.
    */
   func disablePortfolioEditing() {
      portfolioDoneButton.tap()
      XCTAssertFalse(editLabel.exists, "Edit mode view still exists.")
   }
   
   
   /**
    Disables Watch List editing mode.
    */
   func disableWatchListEditing() {
      watchListDoneButton.tap()
      XCTAssertFalse(editLabel.exists, "Edit mode view still exists.")
   }

   
   /**
    Deletes AAPL position.
    */
   func deletePositionAAPL() {
      cellAAPL.doubleTap()
      confirmDeleteSheetDeleteButton.tap()
   }
   
   
   /**
    Swaps AAPL and TSLA positions.
    */
   func swapPositions() {
      XCTAssertTrue(cellAAPL.hittable, "AAPL cell is not hittable.")
      XCTAssertTrue(cellTSLA.hittable, "TSLA cell is not hittable.")
      XCTAssertEqual("AAPL", cells.elementBoundByIndex(0).staticTexts.elementBoundByIndex(0).label, "AAPL is in incorrect location.")
      XCTAssertEqual("TSLA", cells.elementBoundByIndex(1).staticTexts.elementBoundByIndex(0).label, "TSLA is in incorrect location.")
      cellTSLA.pressForDuration(0.5, thenDragToElement: cellAAPL)
      XCTAssertEqual("AAPL", cells.elementBoundByIndex(1).staticTexts.elementBoundByIndex(0).label, "AAPL is in incorrect location.")
      XCTAssertEqual("TSLA", cells.elementBoundByIndex(0).staticTexts.elementBoundByIndex(0).label, "TSLA is in incorrect location.")
      XCTAssertTrue(cellAAPL.hittable, "AAPL cell is not hittable.")
      XCTAssertTrue(cellTSLA.hittable, "TSLA cell is not hittable.")
   }
}
