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
      XCTAssertTrue(addPositionAlertView.exists, "Add Position alert view does not exist.")
      XCTAssertTrue(CGRectContainsRect(appWindow.frame, addPositionAlertView.frame), "Add Position alert view is not visible.")
      addPositionCancelButton.tap()
      XCTAssertFalse(addPositionAlertView.exists, "Add Position alert view still exists.")
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
      XCTAssertTrue(addPositionAlertView.exists, "Add Position alert view does not exist.")
      XCTAssertTrue(CGRectContainsRect(appWindow.frame, addPositionAlertView.frame), "Add Position alert view is not visible.")
      addPositionCancelButton.tap()
      XCTAssertFalse(addPositionAlertView.exists, "Add Position alert view still exists.")
      XCTAssertEqual(cells.count, 0, "Incorrect number of Watch List cells.")
   }
   
   
   /**
    Creates then views AAPL Portfolio position detail view UI tests.
    */
   func testPortfolioPositionDetail() {
      XCTAssertEqual(navigationBarTitle, "Portfolio")
      addPortfolioPositionAAPL()
      XCTAssertEqual(cells.count, 1, "Incorrect number of Portfolio cells.")
      cellAAPL.tap()
      XCTAssertTrue(detailViewMarketCapLabel.exists, "Detail view Market Cap label does not exist.")
      XCTAssertTrue(CGRectContainsRect(appWindow.frame, detailViewMarketCapLabel.frame), "Detail view Market Cap label is not visible.")
      XCTAssertTrue(detailViewTotalValueLabel.exists, "Detail view Total Value label does not exist.")
      XCTAssertTrue(CGRectContainsRect(appWindow.frame, detailViewTotalValueLabel.frame), "Detail view Total Value label is not visible.")
      if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
         dismissRegion.tap()
      } else {
         XCTAssertEqual(navigationBarTitle, "AAPL")
         portfolioBackButton.tap()
      }
      XCTAssertFalse(detailViewMarketCapLabel.exists, "Detail view Market Cap label still exists.")
      XCTAssertFalse(detailViewTotalValueLabel.exists, "Detail view Total Value label still exists.")
   }
   
   
   /**
    Creates then views AAPL Watch List position detail view UI tests.
    */
   func testWatchListPositionDetail() {
      watchListTab.tap()
      XCTAssertEqual(navigationBarTitle, "Watch List")
      addWatchListPositionAAPL()
      XCTAssertEqual(cells.count, 1, "Incorrect number of Watch List cells.")
      cellAAPL.tap()
      XCTAssertTrue(detailViewMarketCapLabel.exists, "Detail view Market Cap label does not exist.")
      XCTAssertTrue(CGRectContainsRect(appWindow.frame, detailViewMarketCapLabel.frame), "Detail view Market Cap label is not visible.")
      XCTAssertFalse(detailViewTotalValueLabel.exists, "Detail view Total Value label exists.")
      if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
         dismissRegion.tap()
      } else {
         XCTAssertEqual(navigationBarTitle, "AAPL")
         watchListBackButton.tap()
      }
      XCTAssertFalse(detailViewMarketCapLabel.exists, "Market Cap label still exists.")
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
      XCTAssertTrue(addPositionAlertView.exists, "Add Position alert view does not exist.")
      XCTAssertTrue(CGRectContainsRect(appWindow.frame, addPositionAlertView.frame), "Add Position alert view is not visible.")
      addPositionSymbolTextField.typeText("aapl")
      keyboardReturnButton.tap()
      addPositionSharesTextField.typeText("100")
      addPositionAddButton.tap()
      expectationForPredicate(NSPredicate(format: "exists == 1"), evaluatedWithObject: cellAAPL, handler: nil)
      waitForExpectationsWithTimeout(5, handler: nil)
      XCTAssertFalse(addPositionAlertView.exists, "Add Position alert view still exists.")
      XCTAssertTrue(cellAAPL.hittable, "AAPL cell is not hittable.")
   }
   
   
   /**
    Adds AAPL position to Watch List.
    
    Keyboard Add button utilized.
    */
   func addWatchListPositionAAPL() {
      watchListAddButton.tap()
      XCTAssertTrue(addPositionAlertView.exists, "Add Position alert view does not exist.")
      XCTAssertTrue(CGRectContainsRect(appWindow.frame, addPositionAlertView.frame), "Add Position alert view is not visible.")
      addPositionSymbolTextField.typeText("aapl")
      addPositionAddButton.tap()
      expectationForPredicate(NSPredicate(format: "exists == 1"), evaluatedWithObject: cellAAPL, handler: nil)
      waitForExpectationsWithTimeout(5, handler: nil)
      XCTAssertFalse(addPositionAlertView.exists, "Add Position alert view still exists.")
      XCTAssertTrue(cellAAPL.hittable, "AAPL cell is not hittable.")
   }
   
   
   /**
    Adds TSLA position to Portfolio.
    
    Text based returns utilized.
    */
   func addPortfolioPositionTSLA() {
      portfolioAddButton.tap()
      XCTAssertTrue(addPositionAlertView.exists, "Add Position alert view does not exist.")
      XCTAssertTrue(CGRectContainsRect(appWindow.frame, addPositionAlertView.frame), "Add Position alert view is not visible.")
      addPositionSymbolTextField.typeText("tsla\r")
      addPositionSharesTextField.typeText("50.89\r")
      expectationForPredicate(NSPredicate(format: "exists == 1"), evaluatedWithObject: cellTSLA, handler: nil)
      waitForExpectationsWithTimeout(5, handler: nil)
      XCTAssertFalse(addPositionAlertView.exists, "Add Position alert view still exists.")
      XCTAssertTrue(cellTSLA.hittable, "TSLA cell is not hittable.")
   }
   
   
   /**
    Adds TSLA position to Watch List.
    
    Text based return utilized.
    */
   func addWatchListPositionTSLA() {
      watchListAddButton.tap()
      XCTAssertTrue(addPositionAlertView.exists, "Add Position alert view does not exist.")
      XCTAssertTrue(CGRectContainsRect(appWindow.frame, addPositionAlertView.frame), "Add Position alert view is not visible.")
      addPositionSymbolTextField.typeText("tsla\r")
      expectationForPredicate(NSPredicate(format: "exists == 1"), evaluatedWithObject: cellTSLA, handler: nil)
      waitForExpectationsWithTimeout(5, handler: nil)
      XCTAssertFalse(addPositionAlertView.exists, "Add Position alert view still exists.")
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
