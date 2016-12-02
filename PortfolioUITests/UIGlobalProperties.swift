//
//  UIGlobalProperties.swift
//  Portfolio
//
//  Created by John Woolsey on 4/26/16.
//  Copyright © 2016 ExtremeBytes Software. All rights reserved.
//


import XCTest


// MARK: - Properties

let app = XCUIApplication()

// Alert views
var addPositionAlertView: XCUIElement { return app.alerts["Add Position"] }
var creationErrorAlertView: XCUIElement { return app.alerts["Creation Error"] }
var duplicateTickerSymbolAlertView: XCUIElement { return app.alerts["Duplicate Ticker Symbol"] }
var invalidShareCountAlertView: XCUIElement { return app.alerts["Invalid Share Count"] }
var invalidTickerSymbolAlertView: XCUIElement { return app.alerts["Invalid Ticker Symbol"] }

// Buttons
var addPositionAddButton: XCUIElement { return addPositionAlertView.collectionViews.buttons["Add"] }
var addPositionCancelButton: XCUIElement { return addPositionAlertView.collectionViews.buttons["Cancel"] }
var confirmDeleteSheetCancelButton: XCUIElement { return app.sheets["Confirm Delete"].buttons["Cancel"] }
var confirmDeleteSheetDeleteButton: XCUIElement { return app.sheets["Confirm Delete"].buttons["Delete"] }
var creationErrorAlertOkButton: XCUIElement { return creationErrorAlertView.collectionViews.buttons["Ok"] }
var duplicateTickerSymbolAlertOkButton: XCUIElement { return duplicateTickerSymbolAlertView.collectionViews.buttons["Ok"] }
var invalidShareCountAlertOkButton: XCUIElement { return invalidShareCountAlertView.collectionViews.buttons["Ok"] }
var invalidTickerSymbolAlertOkButton: XCUIElement { return invalidTickerSymbolAlertView.collectionViews.buttons["Ok"] }
var keyboardReturnButton: XCUIElement { return app.buttons["Return"] }
var portfolioAddButton: XCUIElement { return app.navigationBars["Portfolio"].buttons["Add"] }
var portfolioBackButton: XCUIElement { return app.navigationBars["AAPL"].buttons["Portfolio"] }
var portfolioDoneButton: XCUIElement { return app.navigationBars["Portfolio"].buttons["Done"] }
var portfolioEditButton: XCUIElement { return app.navigationBars["Portfolio"].buttons["Edit"] }
var watchListAddButton: XCUIElement { return app.navigationBars["Watch List"].buttons["Add"] }
var watchListBackButton: XCUIElement { return app.navigationBars["AAPL"].buttons["Watch List"] }
var watchListDoneButton: XCUIElement { return app.navigationBars["Watch List"].buttons["Done"] }
var watchListEditButton: XCUIElement { return app.navigationBars["Watch List"].buttons["Edit"] }

// Cells
var cells: XCUIElementQuery { return app.collectionViews.cells }  // TODO: Need distinct Portfolio and Watch List versions?
var cellAAPL: XCUIElement { return cells.staticTexts["AAPL"] }
var cellTSLA: XCUIElement { return cells.staticTexts["TSLA"] }

// Labels
var detailViewMarketCapLabel: XCUIElement { return app.staticTexts["Market Cap:"] }
var detailViewTotalValueLabel: XCUIElement { return app.staticTexts["Total Value:"] }
var editLabel: XCUIElement { return app.staticTexts["Edit Mode Enabled"] }

// Tabs
var portfolioTab: XCUIElement { return app.tabBars.buttons["Portfolio"] }
var watchListTab: XCUIElement { return app.tabBars.buttons["Watch List"] }

// Text fields
var addPositionSharesTextField: XCUIElement { return addPositionAlertView.collectionViews.textFields["number of shares"] }
var addPositionSymbolTextField: XCUIElement { return addPositionAlertView.collectionViews.textFields["ticker symbol"] }

// Other
var appWindow: XCUIElement { return app.windows.element(boundBy: 0) }
var dismissRegion: XCUIElement { return app.otherElements["PopoverDismissRegion"] }
var navigationBarTitle: String { return app.navigationBars.element.identifier }
