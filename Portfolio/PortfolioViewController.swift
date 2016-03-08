//
//  PortfolioViewController.swift
//  Portfolio
//
//  Created by John Woolsey on 1/26/16.
//  Copyright © 2016 ExtremeBytes Software. All rights reserved.
//


import UIKit


class PortfolioViewController: UICollectionViewController {
   
   // MARK: - Properties
   
   private let appCoordinator = AppCoordinator.sharedInstance
   private let positionCellIdentifier = String(PositionCollectionViewCell)
   private let positionsHeaderIdentifier = String(PositionCollectionViewHeader)
   private let savedPortfolioSymbolsIdentifier = "SavedPortfolioSymbols"
   private let savedWatchListSymbolsIdentifier = "SavedWatchListSymbols"
   private let positionDeletionGestureRecognizer = UITapGestureRecognizer()

   private var symbols: [String] = []
   private var positions: [String:Position] = [:]  // TODO: Use NSCache?
   private var editModeEnabled = false
   private var editingHeaderView: PositionCollectionViewHeader?
   private var refreshButton: UIBarButtonItem?

   private var savedSymbols: [String] {
      var localSymbols: [String] = []
      if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
         let defaults = NSUserDefaults.standardUserDefaults()
         if let defaultSymbols = defaults.objectForKey(savedPortfolioSymbolsIdentifier) as? [String]
            where title == appDelegate.portfolioTitle {
               localSymbols = defaultSymbols
         } else if let defaultSymbols = defaults.objectForKey(savedWatchListSymbolsIdentifier) as? [String]
            where title == appDelegate.watchListTitle {
               localSymbols = defaultSymbols
         }
      }
//      localSymbols = ["NNNN", "AAPL", "KO", "TSLA", "CSCO", "SHIP", "BND", "IBM"]  // TODO: Used for testing
      return localSymbols
   }
   private var editingHeaderViewOrigin: CGPoint {
      if let navigationBarFrame = self.navigationController?.navigationBar.frame {
         return CGPoint(x: 0, y: navigationBarFrame.origin.y + navigationBarFrame.size.height)
      } else {
         return CGPointZero
      }
   }
   private var editingHeaderViewSize: CGSize {
      return CGSize(width: view.frame.width, height: 88)
   }
   
   
   // MARK: - Lifecycle
   
   override func viewDidLoad() {
      super.viewDidLoad()
      configureNavigationBar()
      configureCollectionView()
      applyTheme()
      loadState()
   }
   
   
   override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
      super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
      coordinator.animateAlongsideTransition({ [unowned self] _ in
         self.editingHeaderView?.frame = CGRect(origin: self.editingHeaderViewOrigin, size: self.editingHeaderViewSize)
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
      // Get cell
      let baseCell = collectionView.dequeueReusableCellWithReuseIdentifier(positionCellIdentifier, forIndexPath: indexPath)
      
      // Validate cell
      guard let cell = baseCell as? PositionCollectionViewCell else {
         return baseCell
      }
      
      // Get position
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
      saveState()
   }
   
   
   // MARK: - Actions
   
   /**
   Initiates a request to the user to add an investment position to the portfolio when the Add button is pressed.
   
   - parameter sender: The object that requested the action.
   */
   func addButtonPressed(sender: UIBarButtonItem) {
      requestAdditionSymbolFromUser()
   }
   
   
   /**
    Initiates a request to the user to delete an investment position from the portfolio when a deletion gesture is recognized.
    
    - parameter sender: The object that requested the action.
    */
   func positionDeletionRequested(sender: UITapGestureRecognizer) {
      let location = positionDeletionGestureRecognizer.locationInView(collectionView)
      if let indexPath = collectionView?.indexPathForItemAtPoint(location),
         cell = collectionView?.cellForItemAtIndexPath(indexPath) as? PositionCollectionViewCell,
         symbol = cell.symbolLabel.text {
            requestDeletionConfirmationFromUser(symbol)
      } else {
         appCoordinator.presentErrorToUser(title: "Deletion Error",
            message: "Could not remove the selected investment position from the portfolio. Please try again.")
      }
   }
   
   
   /**
    Enables/Disables portfolio editing when the Edit button is pressed.
    
    - parameter sender: The object that requested the action.
    */
   func editButtonPressed(sender: UIBarButtonItem) {
      if editModeEnabled {
         disableEditing()
      } else {
         enableEditing()
      }
   }
   
   
   /**
    Refreshes investment positions when the Refresh button is pressed.
    
    - parameter sender: The object that requested the action.
    */
   func refreshButtonPressed(sender: UIBarButtonItem) {
      refreshState()
   }
   
   
   /**
    Enables refresh capability when the refresh timer is fired.
    
    - parameter sender: The object that requested the action.
    */
   @objc func refreshTimerFired(sender: NSTimer) {  // @objc required for recognizing method selector signature
      #if DEBUG
         print("Refresh timer fired.")
      #endif
      enableRefresh()
   }
   
   
   // MARK: - Configuration
   
   /**
   Applies view controller specific theming.
   */
   private func applyTheme() {
   }
   
   
   /**
    Configures the navigation bar.
    */
   private func configureNavigationBar() {
      refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: Selector("refreshButtonPressed:"))
      navigationItem.leftBarButtonItem = refreshButton
      let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("addButtonPressed:"))
      let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: Selector("editButtonPressed:"))
      navigationItem.rightBarButtonItems = [editButton, addButton]
   }
   
   
   /**
    Configures the portfolio collection view.
    */
   private func configureCollectionView() {
      installsStandardGestureForInteractiveMovement = false
      collectionView?.backgroundColor = UIColor.whiteColor()
      collectionView?.registerNib(UINib(nibName: positionCellIdentifier, bundle: nil), forCellWithReuseIdentifier: positionCellIdentifier)
      updateCollectionViewFlowLayout()
      
      // Configure deletion gesture recognizer
      positionDeletionGestureRecognizer.numberOfTapsRequired = 2
      positionDeletionGestureRecognizer.addTarget(self, action: Selector("positionDeletionRequested:"))
   }
   
   
   /**
    Updates the portfolio collection view flow layout.
    */
   private func updateCollectionViewFlowLayout() {
      let spacerSize = PositionCoordinator.sharedInstance.spacerSize
      let flowLayout = UICollectionViewFlowLayout()
      flowLayout.minimumInteritemSpacing = spacerSize.width
      flowLayout.minimumLineSpacing = spacerSize.height
      flowLayout.itemSize = PositionCoordinator.sharedInstance.cellSize
      collectionView?.collectionViewLayout = flowLayout
   }

   
   // MARK: - Editing
   
   /**
   Enables editing of the portfolio.
   */
   private func enableEditing() {
      editModeEnabled = true
      installsStandardGestureForInteractiveMovement = true
      
      // Create header view if necessary
      if editingHeaderView == nil {
         let nib = UINib(nibName: positionsHeaderIdentifier, bundle: nil)
         if let headerView = nib.instantiateWithOwner(PositionCollectionViewHeader(), options: nil).first as? PositionCollectionViewHeader {
            editingHeaderView = headerView
         }
      }
      
      // Display header view
      if let headerView = editingHeaderView,
         contentInsetCurrent = collectionView?.contentInset {
            collectionView?.contentInset = UIEdgeInsets(top: contentInsetCurrent.top + editingHeaderViewSize.height, left: 0, bottom: contentInsetCurrent.bottom, right: 0)
            headerView.frame = CGRect(origin: editingHeaderViewOrigin, size: editingHeaderViewSize)
            view.addSubview(headerView)
            self.editingHeaderView = headerView
      }
      
      collectionView?.addGestureRecognizer(positionDeletionGestureRecognizer)
   }
   
   
   /**
    Disables editing of the portfolio.
    */
   private func disableEditing() {
      editModeEnabled = false
      installsStandardGestureForInteractiveMovement = false
      
      // Remove header view
      if let headerView = editingHeaderView,
         contentInsetCurrent = collectionView?.contentInset {
            headerView.removeFromSuperview()
            self.collectionView?.contentInset = UIEdgeInsets(top: contentInsetCurrent.top - editingHeaderViewSize.height, left: 0, bottom: contentInsetCurrent.bottom, right: 0)
      }
      
      collectionView?.removeGestureRecognizer(positionDeletionGestureRecognizer)
   }
   
   
   /**
    Adds a new investment postion to the portfolio.
    
    - parameter symbol: The ticker symbol of the investment position.
    */
   private func addPositionToPortfolio(symbol: String?) {
      // Validate input
      guard let symbol = symbol where !symbol.isEmpty else {
         appCoordinator.presentErrorToUser(title: "Invalid Ticker Symbol",
            message: "The ticker symbol entered was invalid. Please try again.")
         return
      }
      guard symbols.contains(symbol) == false else {
         appCoordinator.presentErrorToUser(title: "Duplicate Ticker Symbol",
            message: "The ticker symbol entered already exists.")
         return
      }
      
      // Fetch symbol information from service and add to positions
      NetworkManager.sharedInstance.fetchPositionForSymbol(symbol) { [unowned self] (position: Position?, error: NSError?) -> Void in
         if let error = error {
            self.appCoordinator.presentErrorToUser(title: "Retrieval Error", message: error.localizedDescription)
         } else if let position = position, symbol = position.symbol where !symbol.isEmpty {
            let index = self.symbols.count
            self.positions[symbol] = position
            self.symbols.append(symbol)
            self.collectionView?.insertItemsAtIndexPaths([NSIndexPath(forItem: index, inSection: 0)])
            self.collectionView?.scrollToItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0), atScrollPosition: .Bottom, animated: true)
            self.saveState()
         } else {
            self.appCoordinator.presentErrorToUser(title: "Creation Error",
               message: "The investment position could not be created. Please try again.")
         }
      }
   }
   
   
   /**
    Deletes an investment position from the portfolio.
    
    - parameter symbol: The ticker symbol of the investment position.
    */
   private func deletePositionFromPortfolio(symbol: String) {
      // Validate input
      guard !symbol.isEmpty && symbols.contains(symbol) != false else {
         appCoordinator.presentErrorToUser(title: "Invalid Ticker Symbol",
            message: "The ticker symbol entered was invalid. Please try again.")
         return
      }
      
      // Remove position
      if let index = symbols.indexOf(symbol) {
         positions[symbol] = nil
         symbols.removeAtIndex(index)
         collectionView?.deleteItemsAtIndexPaths([NSIndexPath(forItem: index, inSection: 0)])
         saveState()
      } else {
         appCoordinator.presentErrorToUser(title: "Deletion Error",
            message: "Could not remove the \(symbol) investment position from the portfolio. Please try again.")
      }
   }

   
   /**
   Presents a pop up window to the user requesting a ticker symbol for adding an investment postion to the portfolio.
   */
   private func requestAdditionSymbolFromUser() {
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
    Presents a confirmation window to the user to confirm deletion of an investment postion from the portfolio.
    
    - parameter symbol: The ticker symbol of the investment position.
    */
   private func requestDeletionConfirmationFromUser(symbol: String) {
      // Present deletion confirmation to user
      let alertController = UIAlertController(title: "Confirm Delete",
         message: "Are you sure you want to remove the \(symbol) investment position from the portfolio?",
         preferredStyle: .ActionSheet)
      let deleteAction = UIAlertAction(title: "Delete", style: .Destructive) { [unowned self] action in
         self.deletePositionFromPortfolio(symbol)
      }
      alertController.addAction(deleteAction)
      let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
      alertController.addAction(cancelAction)
      
      // Apply as popover on iPad
      alertController.modalPresentationStyle = .Popover
      if let presenter = alertController.popoverPresentationController,
         index = symbols.indexOf(symbol),
         cell = collectionView?.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0)) as? PositionCollectionViewCell {
            presenter.sourceView = cell
            presenter.sourceRect = cell.bounds
      }
      
      presentViewController(alertController, animated: true, completion: nil)
   }

   
   // MARK: - State
   
   /**
   Clears the current visible state of investment postions.
   */
//   private func clearState() {
//      symbols.removeAll()
//      positions.removeAll()
//      collectionView?.reloadData()
//   }
   
   
   /**
    Loads the current visible state of investment positions.
    */
   private func loadState() {
      loadPositions()
      disableRefresh()
   }

   
   /**
    Refreshes the current visible state of investment positions.
    */
   private func refreshState() {
      refreshPositions()
      disableRefresh()
   }
   
   
   /**
    Saves the current list of investment position symbols to the user defaults system.
    */
   private func saveState() {
      if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
         let defaults = NSUserDefaults.standardUserDefaults()
         if title == appDelegate.portfolioTitle {
            defaults.setObject(symbols, forKey: savedPortfolioSymbolsIdentifier)
         } else if title == appDelegate.watchListTitle {
            defaults.setObject(symbols, forKey: savedWatchListSymbolsIdentifier)
         }
         defaults.synchronize()
      }
   }

   
   // MARK: - Other
   
   /**
   Enables refresh capability.
   */
   private func enableRefresh() {
      refreshButton?.enabled = true
   }
   
   
   /**
    Disables refresh capability for 1 minute.
    */
   private func disableRefresh() {
      refreshButton?.enabled = false
      NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: Selector("refreshTimerFired:"), userInfo: nil, repeats: false)
      
   }

   
   /**
   Loads the positions from the server.
   */
   private func loadPositions() {
      for symbol in savedSymbols {
         NetworkManager.sharedInstance.fetchPositionForSymbol(symbol) { [unowned self] (position: Position?, error: NSError?) -> Void in
            if let position = position {
               self.positions[symbol] = position
            } else {
               var newPosition = Position()
               newPosition.symbol = symbol
               self.positions[symbol] = newPosition
            }
            let currentIndex = self.insertionIndexForSymbol(symbol)
            self.symbols.insert(symbol, atIndex: currentIndex)
            self.collectionView?.insertItemsAtIndexPaths([NSIndexPath(forItem: currentIndex, inSection: 0)])
            if let error = error {
               self.appCoordinator.presentErrorToUser(title: "Retrieval Error", message: error.localizedDescription)
            }
         }
      }
   }
   
   
   /**
    Refreshes the positions from the server.
    */
   private func refreshPositions() {
      for symbol in savedSymbols {
         NetworkManager.sharedInstance.fetchPositionForSymbol(symbol) { [unowned self] (position: Position?, error: NSError?) -> Void in
            if let position = position,
               index = self.savedSymbols.indexOf(symbol) {
                  self.positions[symbol] = position
                  self.collectionView?.reloadItemsAtIndexPaths([NSIndexPath(forItem: index, inSection: 0)])
            }
         }
      }
   }
   
   
   /**
    Calculates and returns the appropriate investment position insertion index for the given symbol.
    
    - parameter symbol: The symbol to insert.
    
    - returns: The index to place the new symbol in the partial list of current symbols.
    */
   private func insertionIndexForSymbol(symbol: String) -> Int {
      var index = 0
      if let savedIndex = savedSymbols.indexOf(symbol) {
         let savedPredecessorSymbols = savedSymbols[0..<savedIndex]
         let currentPredecessorSymbols = self.symbols.filter({ savedPredecessorSymbols.contains($0) == true })
         index = currentPredecessorSymbols.count
      }
      return index
   }
}
