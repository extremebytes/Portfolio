//
//  PortfolioViewController.swift
//  Portfolio
//
//  Created by John Woolsey on 1/26/16.
//  Copyright © 2016 ExtremeBytes Software. All rights reserved.
//


// TODO: Add timer to disable frequent position updates.


import UIKit


class PortfolioViewController: UICollectionViewController {
   
   // MARK: - Properties
   
   let positionCellReuseIdentifier = "PositionCell"
   let savedPortfolioSymbolsIdentifier = "SavedPortfolioSymbols"
   let savedWatchListSymbolsIdentifier = "SavedWatchListSymbols"
   let minimumPositionCellSize = CGSize(width: 224, height: 96)
   let spacerSize = CGSize(width: 8, height: 8)
   var symbols: [String] = []
   var positions: [String:Position] = [:]  // TODO: Use NSCache?
   var editModeEnabled = false
   var errorOnScreen = false
   
   
   // MARK: - View Lifecycle
   
   override func viewDidLoad() {
      super.viewDidLoad()
      configureNavigationBar()
      configureCollectionView()
      applyTheme()
      loadPositions()
   }
   
   
   override func viewWillDisappear(animated: Bool) {
      super.viewWillDisappear(animated)
      saveState()
   }
   
   
   override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
      super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
      coordinator.animateAlongsideTransition({ [unowned self] _ in
         self.updateCollectionViewFlowLayout()
         }, completion: nil)
   }
   
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
   }

   
   // MARK: - UICollectionViewDataSource
   
   override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return symbols.count
   }
   
   
   override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCellWithReuseIdentifier(positionCellReuseIdentifier, forIndexPath: indexPath) as! PositionCollectionViewCell
      
      // Validate cell
      let symbol = symbols[indexPath.item]
      var position: Position
      if let savedPosition = positions[symbol] where savedPosition.symbol == symbol {
         position = savedPosition
      } else {
         position = Position()
         position.symbol = symbol
      }
      
      // Configure cell
      cell.symbolLabel?.text = position.symbolForDisplay
      cell.nameLabel?.text = position.nameForDisplay
      cell.quoteLabel?.text = position.lastPriceForDisplay
      cell.changeLabel?.text = position.changePercentForDisplay
      let changePercentValue = position.changePercent
      switch changePercentValue {
      case _ where changePercentValue < 0:
         cell.changeLabel?.textColor = UIColor.redColor()
      case _ where changePercentValue > 0:
         cell.changeLabel?.textColor = UIColor.greenColor()
      default:
         cell.changeLabel?.textColor = UIColor.blackColor()
      }
      if let status = position.status where status.lowercaseString.rangeOfString("success") != nil {
         cell.statusLabel?.textColor = UIColor.darkGrayColor()
      } else {
         cell.statusLabel?.textColor = UIColor.redColor()
      }
      cell.statusLabel?.text = position.statusForDisplay
      
      return cell
   }
   
   
   override func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
      let temp = symbols.removeAtIndex(sourceIndexPath.item)
      symbols.insert(temp, atIndex: destinationIndexPath.item)
   }
   
   
   // MARK: - Configuration
   
   /**
   Applies view controller specific theming.
   */
   func applyTheme() {
   }

   
   /**
   Configures the navigation bar.
   */
   func configureNavigationBar() {
      let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: Selector("refreshButtonPressed:"))
      navigationItem.leftBarButtonItem = refreshButton
      let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("addButtonPressed:"))
      let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: Selector("editButtonPressed:"))
      navigationItem.rightBarButtonItems = [editButton, addButton]
   }
   
   
   /**
    Configures the portfolio collection view.
    */
   func configureCollectionView() {
      installsStandardGestureForInteractiveMovement = false
      collectionView?.backgroundColor = UIColor.whiteColor()
      collectionView?.registerNib(UINib(nibName: "PositionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: positionCellReuseIdentifier)
      updateCollectionViewFlowLayout()
   }
   
   
   /**
    Updates the portfolio collection view flow layout.
    */
   func updateCollectionViewFlowLayout() {
      let flowLayout = UICollectionViewFlowLayout()
      flowLayout.minimumInteritemSpacing = spacerSize.width
      flowLayout.minimumLineSpacing = spacerSize.height
      flowLayout.itemSize = getPositionCellSize()
      collectionView?.collectionViewLayout = flowLayout
   }
   
   
   /**
    Calculates and returns the size of an investment position collection view cell.
    
    - returns: The size of the cell.
    */
   func getPositionCellSize() -> CGSize {
      let screenWidth = UIScreen.mainScreen().bounds.width
      var itemSize: CGSize
      if screenWidth < minimumPositionCellSize.width * 2 + spacerSize.width * 1 {  // 1 item per row
         itemSize = CGSize(width: screenWidth, height: minimumPositionCellSize.height)
      } else if screenWidth < minimumPositionCellSize.width * 3 + spacerSize.width * 2 {  // 2 items per row
         itemSize = CGSize(width: (screenWidth - spacerSize.width) / 2, height: minimumPositionCellSize.height)
      } else if screenWidth < minimumPositionCellSize.width * 4 + spacerSize.width * 3 {  // 3 items per row
         itemSize = CGSize(width: (screenWidth - spacerSize.width * 2) / 3, height: minimumPositionCellSize.height)
      } else {  // 4 items per row (maximum)
         itemSize = CGSize(width: (screenWidth - spacerSize.width * 3) / 4, height: minimumPositionCellSize.height)
      }
      return itemSize
   }
   
   
   // MARK: - Actions
   
   /**
   Initiates a request to the user to add an investment position to the portfolio when the Add button is pressed.
   
   - parameter sender: The object that requested the action.
   */
   func addButtonPressed(sender: UIBarButtonItem) {
      requestSymbolFromUser()
   }
   
   
   /**
    Enables portfolio editing when the Edit button is pressed.
    
    - parameter sender: The object that requested the action.
    */
   func editButtonPressed(sender: UIBarButtonItem) {
      // TODO: Add ability to delete positions
      if editModeEnabled {  // disable editing mode
         installsStandardGestureForInteractiveMovement = false
      } else {  // enable editing mode
         installsStandardGestureForInteractiveMovement = true
      }
   }
   
   
   /**
    Refreshes investment positions when the Refresh button is pressed.
    
    - parameter sender: The object that requested the action.
    */
   func refreshButtonPressed(sender: UIBarButtonItem) {
      refreshPositions()
   }
   
   
   // MARK: - Other
   
   /**
   Loads the positions from the server.
   */
   func loadPositions() {
      let savedSymbols = getSavedSymbols()
      for symbol in savedSymbols {
         NetworkManager.sharedInstance.fetchPositionForSymbol(symbol) { [unowned self] (position: Position?, error: NSError?) -> Void in
            if let position = position {
               self.positions[symbol] = position
            } else {
               var newPosition = Position()
               newPosition.symbol = symbol
               self.positions[symbol] = newPosition
            }
            let currentIndex = self.getIndexForSavedSymbol(symbol, savedSymbols: savedSymbols)
            self.symbols.insert(symbol, atIndex: currentIndex)
            // TODO: Getting the following error when rotating
            // *** Assertion failure in -[UICollectionView _endItemAnimationsWithInvalidationContext:tentativelyForReordering:]
            // Invalid update: invalid number of items in section 0.  The number of items contained in an existing section after the update (1) must be equal to the number of items contained in that section before the update (1), plus or minus the number of items inserted or deleted from that section (1 inserted, 0 deleted) and plus or minus the number of items moved into or out of that section (0 moved in, 0 moved out).
            self.collectionView?.insertItemsAtIndexPaths([NSIndexPath(forItem: currentIndex, inSection: 0)])
            if let error = error {
               self.presentErrorToUser(title: "Retrieval Error", message: error.localizedDescription)
            }
         }
      }
   }
   
   
   /**
    Refreshes position information by clearing and reloading the positions from the server.
    */
   func refreshPositions() {
      // TODO: Refresh positions in place instead of clearing state.
      saveState()
      clearState()
      loadPositions()
   }
   
   
   /**
    Retrieves saved investment position symbols from the user defaults system.
    
    - returns: The saved symbols.
    */
   func getSavedSymbols() -> [String] {
      var savedSymbols: [String] = []
      if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
         let defaults = NSUserDefaults.standardUserDefaults()
         if let defaultSymbols = defaults.objectForKey(savedPortfolioSymbolsIdentifier) as? [String]
            where title == appDelegate.portfolioTitleIdentifier {
               savedSymbols = defaultSymbols
         } else if let defaultSymbols = defaults.objectForKey(savedWatchListSymbolsIdentifier) as? [String]
            where title == appDelegate.watchListTitleIdentifier {
               savedSymbols = defaultSymbols
         }
      }
//      savedSymbols = ["AAPL", "KO", "TSLA", "CSCO", "SHIP", "BND", "IBM", "AAPL", "KO", "TSLA", "AAPL", "KO", "TSLA", "CSCO", "SHIP", "BND", "IBM", "AAPL", "KO", "TSLA"]  // TODO: Used for testing
//      savedSymbols = ["NNNNN", "AAPL", "KO", "TSLA", "CSCO", "SHIP", "BND", "IBM"]  // TODO: Used for testing
      return savedSymbols
   }
   
   
   /**
    Calculates and returns the appropriate investment position insertion index for the current list.
    
    - parameter symbol:       The symbol to insert.
    - parameter savedSymbols: The full list of saved symbols.
    
    - returns: The index to place the new symbol in the partial list of current symbols.
    */
   func getIndexForSavedSymbol(symbol: String, savedSymbols: [String]) -> Int {
      var index = 0
      if let savedIndex = savedSymbols.indexOf(symbol) {
         let savedPredecessorSymbols = savedSymbols[0..<savedIndex]
         let currentPredecessorSymbols = self.symbols.filter({ savedPredecessorSymbols.contains($0) == true })
         index = currentPredecessorSymbols.count
      }
      return index
   }
   
   
   /**
    Presents a pop up window to the user requesting a ticker symbol for adding an investment postion to the portfolio.
    */
   func requestSymbolFromUser() {
      // Present pop up symbol input view to user
      let alertController = UIAlertController(title: "Enter Ticker Symbol",
         message: "Enter the ticker symbol for the stock or other investment you would like to add.",
         preferredStyle: .Alert)
      let addAction = UIAlertAction(title: "Add", style: .Default) { [unowned self] action in
         self.addPositionToPortfolio(alertController.textFields?[0].text?.uppercaseString)
      }
      alertController.addAction(addAction)
      let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
      alertController.addAction(cancelAction)
      alertController.addTextFieldWithConfigurationHandler { (textField: UITextField!) in
         textField.placeholder = "ticker symbol"
      }
      presentViewController(alertController, animated: true, completion: nil)
      return
   }
   
   
   /**
    Adds a new investment postion to the portfolio.
    
    - parameter symbol: The ticker symbol of the investment position.
    */
   func addPositionToPortfolio(symbol: String?) {
      // Validate input
      guard let symbol = symbol where !symbol.isEmpty else {
         presentErrorToUser(title: "Invalid Ticker Symbol", message: "The ticker symbol entered was invalid. Please try again.")
         return
      }
      guard symbols.contains(symbol) == false else {
         presentErrorToUser(title: "Duplicate Ticker Symbol", message: "The ticker symbol entered already exists.")
         return
      }
      
      // Fetch symbol information from service and add to positions
      NetworkManager.sharedInstance.fetchPositionForSymbol(symbol) { [unowned self] (position: Position?, error: NSError?) -> Void in
         if let error = error {
            self.presentErrorToUser(title: "Retrieval Error", message: error.localizedDescription)
         } else if let position = position, symbol = position.symbol where !symbol.isEmpty {
            let index = self.symbols.count
            self.positions[symbol] = position
            self.symbols.append(symbol)
            self.collectionView?.insertItemsAtIndexPaths([NSIndexPath(forItem: index, inSection: 0)])
            self.collectionView?.scrollToItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0), atScrollPosition: .Bottom, animated: true)
         } else {
            self.presentErrorToUser(title: "Creation Error", message: "The investment position could not be created. Please try again.")
         }
      }
   }
   
   
   /**
    Presents an error to the user via a pop up window.
    
    - parameter title:   The window title.
    - parameter message: The error message.
    */
   func presentErrorToUser(title title: String, message: String) {
      guard !errorOnScreen else {
         return  // don't show additional errors
      }
      errorOnScreen = true
      let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
      let okAction = UIAlertAction(title: "Ok", style: .Cancel, handler: { [unowned self] action in
         self.errorOnScreen = false
         })
      alertController.addAction(okAction)
      presentViewController(alertController, animated: true, completion: nil)
      return
   }

   
   /**
    Clears the current visible state of investment postions.
    */
   func clearState() {
      saveState()
      symbols.removeAll()
      positions.removeAll()
      collectionView?.reloadData()
   }
   
   
   /**
    Saves the current list of investment position symbols to the user defaults system.
    */
   func saveState() {
      if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
         let defaults = NSUserDefaults.standardUserDefaults()
         if title == appDelegate.portfolioTitleIdentifier {
            defaults.setObject(symbols, forKey: savedPortfolioSymbolsIdentifier)
         } else if title == appDelegate.watchListTitleIdentifier {
            defaults.setObject(symbols, forKey: savedWatchListSymbolsIdentifier)
         }
         defaults.synchronize()
      }
   }
}
