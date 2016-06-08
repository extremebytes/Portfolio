//
//  PortfolioViewController.swift
//  Portfolio
//
//  Created by John Woolsey on 1/26/16.
//  Copyright © 2016 ExtremeBytes Software. All rights reserved.
//


import UIKit


class PortfolioViewController: UICollectionViewController {
   
   // MARK: - Enumerations
   
   private enum SelectedTextField: NSInteger {
      case Undefined = 0
      case Symbol
      case Shares
      
      var identifier: NSInteger {
         return rawValue
      }
   }

   
   // MARK: - Properties
   
   private let appCoordinator = AppCoordinator.sharedInstance
   private let positionCellIdentifier = String(PositionCollectionViewCell)
   private let positionsHeaderIdentifier = String(PositionCollectionViewHeader)
   private let savedPortfolioSymbolsIdentifier = "SavedPortfolioSymbols"
   private let savedPortfolioSharesIdentifier = "SavedPortfolioShares"
   private let savedWatchListSymbolsIdentifier = "SavedWatchListSymbols"
   private let positionDeletionGestureRecognizer = UITapGestureRecognizer()
   
   private var symbols: [String] = []
   private var positions: [String: Position] = [:]
   private var shares: [String: Double] = [:]
   private var editingHeaderView: PositionCollectionViewHeader?
   private var refreshButton = UIBarButtonItem()
   private var visibleDetailViewController: PositionViewController?
   
   private var controllerType: PositionMemberType {
      if title == PositionMemberType.Portfolio.title {
         return .Portfolio
      }
      return .WatchList
   }
   
   private var savedSymbols: [String] {
      let defaults = NSUserDefaults.standardUserDefaults()
      switch controllerType {
      case .Portfolio:
         return defaults.objectForKey(savedPortfolioSymbolsIdentifier) as? [String] ?? []
      case .WatchList:
         return defaults.objectForKey(savedWatchListSymbolsIdentifier) as? [String] ?? []
      }
//      return ["NNNN", "AAPL", "KO", "TSLA", "CSCO", "SHIP", "BND", "IBM"]  // TODO: Used for testing
   }
   private var savedShares: [String: Double] {
      let defaults = NSUserDefaults.standardUserDefaults()
      switch controllerType {
      case .Portfolio:
         return defaults.objectForKey(savedPortfolioSharesIdentifier) as? [String: Double] ?? [:]
      default:
         return [:]
      }
//      return ["NNNN": 0, "AAPL": 90.8, "KO": 100.9, "TSLA": 101, "CSCO": 102.1, "SHIP": 88, "BND": 1000, "IBM": 80.8]  // TODO: Used for testing
   }
   private var editingHeaderViewOrigin: CGPoint {
      if let navigationBarFrame = navigationController?.navigationBar.frame {
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
   
   
   override func viewDidAppear(animated: Bool) {
      super.viewDidAppear(animated)
      // TODO: Prefer to handle the following within viewWillAppear, but the view is not updated in time.
      if editing {
         editingHeaderView?.frame = CGRect(origin: editingHeaderViewOrigin, size: editingHeaderViewSize)
         updateCollectionViewFlowLayout()
      }
   }
   
   
   override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
      super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
      coordinator.animateAlongsideTransition({ [unowned self] _ in
         self.updateCollectionViewFlowLayout()
         if self.editing {
            self.editingHeaderView?.frame = CGRect(origin: self.editingHeaderViewOrigin, size: self.editingHeaderViewSize)
         } else if let detailViewController = self.visibleDetailViewController,
            localCollectionView = self.collectionView,
            indexPath = localCollectionView.indexPathsForSelectedItems()?.first
            where self.appCoordinator.deviceType == .Pad && detailViewController.isViewVisible {
            // Dismiss and re-present detail view controller to update popover location and arrow direction
            detailViewController.dismissViewControllerAnimated(true, completion: {
               [unowned self] _ in
               self.collectionView(localCollectionView, didSelectItemAtIndexPath: indexPath)
            })
         }
      }, completion: nil)
   }
   
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
   }
   
   
   override func setEditing(editing: Bool, animated: Bool) {
      super.setEditing(editing, animated: animated)
      if editing {
         enableEditing()
      } else {
         disableEditing()
      }
   }
   
   
   // MARK: - Actions
   
   /**
    Changes the application theme when the Action button is pressed.
    
    - parameter sender: The object that requested the action.
    */
   func actionButtonPressed(sender: UIBarButtonItem) {
      if ThemeManager.currentTheme() == .Light {
         ThemeManager.applyTheme(.Dark)
      } else {
         ThemeManager.applyTheme(.Light)
      }
      applyTheme()
      
      // Reload views
      for window in UIApplication.sharedApplication().windows {
         for view in window.subviews {
            view.removeFromSuperview()
            window.addSubview(view)
         }
      }
   }
   
   
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
         symbol = cell.symbol {
            requestDeletionConfirmationFromUser(symbol)
      } else {
         appCoordinator.presentErrorToUser(title: "Deletion Error",
            message: "Could not remove the selected investment position from the portfolio. Please try again.")
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
      refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: #selector(refreshButtonPressed(_:)))
      let themeButton = UIBarButtonItem(image: UIImage(named: "Switch"), style: .Plain, target: self, action: #selector(actionButtonPressed(_:)))
      navigationItem.leftBarButtonItems = [refreshButton, themeButton]
      let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addButtonPressed(_:)))
      let editButton = editButtonItem()
      navigationItem.rightBarButtonItems = [editButton, addButton]
   }
   
   
   /**
    Configures the portfolio collection view.
    */
   private func configureCollectionView() {
      installsStandardGestureForInteractiveMovement = false
      collectionView?.registerNib(UINib(nibName: positionCellIdentifier, bundle: nil), forCellWithReuseIdentifier: positionCellIdentifier)
      updateCollectionViewFlowLayout()
      
      // Configure deletion gesture recognizer
      positionDeletionGestureRecognizer.numberOfTapsRequired = 2
      positionDeletionGestureRecognizer.addTarget(self, action: #selector(positionDeletionRequested(_:)))
   }
   
   
   /**
    Updates the portfolio collection view flow layout.
    */
   private func updateCollectionViewFlowLayout() {
      let spacerSize = PositionCoordinator.spacerSize
      let flowLayout = UICollectionViewFlowLayout()
      flowLayout.minimumInteritemSpacing = spacerSize.width
      flowLayout.minimumLineSpacing = spacerSize.height
      flowLayout.itemSize = PositionCoordinator.cellSizeForScreenWidth(UIScreen.mainScreen().bounds.width, positionType: controllerType)
      collectionView?.collectionViewLayout = flowLayout
   }

   
   // MARK: - Editing
   
   /**
   Enables editing of the portfolio.
   */
   private func enableEditing() {
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
            collectionView?.contentInset = UIEdgeInsets(top: contentInsetCurrent.top + editingHeaderViewSize.height,
               left: 0, bottom: contentInsetCurrent.bottom, right: 0)
            headerView.frame = CGRect(origin: editingHeaderViewOrigin, size: editingHeaderViewSize)
            view.addSubview(headerView)
            editingHeaderView = headerView
      }
      
      collectionView?.addGestureRecognizer(positionDeletionGestureRecognizer)
   }
   
   
   /**
    Disables editing of the portfolio.
    */
   private func disableEditing() {
      installsStandardGestureForInteractiveMovement = false
      
      // Remove header view
      if let headerView = editingHeaderView,
         contentInsetCurrent = collectionView?.contentInset {
            headerView.removeFromSuperview()
            collectionView?.contentInset = UIEdgeInsets(top: contentInsetCurrent.top - editingHeaderViewSize.height,
               left: 0, bottom: contentInsetCurrent.bottom, right: 0)
      }
      
      collectionView?.removeGestureRecognizer(positionDeletionGestureRecognizer)
   }
   
   
   /**
    Adds a new investment postion to the portfolio.
    
    - parameter symbol: The ticker symbol of the investment position.
    */
   private func addPositionToPortfolio(symbol symbol: String?, shares: String?) {
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
      var shareCount: Double = 0
      if controllerType == .Portfolio {
         if let sharesString = shares, sharesNumber = Double(sharesString) where sharesNumber.isNormal && sharesNumber > 0 {
            shareCount = sharesNumber
         } else {
            appCoordinator.presentErrorToUser(title: "Invalid Share Count",
               message: "The number of shares entered was invalid. Please try again.")
            return
         }
      }
      
      // Fetch symbol information from service and add to positions
      NetworkManager.sharedInstance.fetchPositionForSymbol(symbol) {
         [unowned self] (position: Position?, error: NSError?) -> Void in
         if let error = error {
            self.appCoordinator.presentErrorToUser(title: "Retrieval Error",
               message: error.localizedDescription)
         } else if var position = position, let symbol = position.symbol where !symbol.isEmpty {
            let index = self.symbols.count
            position.memberType = self.controllerType
            if self.controllerType == .Portfolio {
               self.shares[symbol] = shareCount
               position.shares = shareCount
            }
            self.positions[symbol] = position
            self.symbols.append(symbol)
            self.collectionView?.insertItemsAtIndexPaths([NSIndexPath(forItem: index, inSection: 0)])
            self.collectionView?.scrollToItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0),
               atScrollPosition: .Bottom, animated: true)
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
         shares[symbol] = nil
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
      let alertController = UIAlertController(title: "Add Position",
         message: "Enter the information for the investment position you would like to add.",
         preferredStyle: .Alert)
      let addAction = UIAlertAction(title: "Add", style: .Default) { [unowned self] action in
         switch self.controllerType {
         case .Portfolio:
            self.addPositionToPortfolio(symbol: alertController.textFields?[0].text?.uppercaseString,
               shares: alertController.textFields?[1].text)
         case .WatchList:
            self.addPositionToPortfolio(symbol: alertController.textFields?[0].text?.uppercaseString,
               shares: nil)
         }
      }
      alertController.addAction(addAction)
      let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
      alertController.addAction(cancelAction)
      alertController.addTextFieldWithConfigurationHandler { (textField: UITextField) in
         textField.placeholder = "ticker symbol"
      }
      if controllerType == .Portfolio {
         alertController.addTextFieldWithConfigurationHandler { (textField: UITextField) in
            textField.tag = SelectedTextField.Shares.identifier
            textField.keyboardType = .NumbersAndPunctuation
            textField.placeholder = "number of shares"
            textField.delegate = self
         }
      }
      presentViewController(alertController, animated: true, completion: nil)
      return
   }
   
   
   /**
    Presents a confirmation window to the user to confirm deletion of an investment postion from the portfolio.
    
    - parameter symbol: The ticker symbol of the investment position.
    */
   private func requestDeletionConfirmationFromUser(symbol: String) {
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
      if appCoordinator.deviceType == .Pad {
         alertController.modalPresentationStyle = .Popover
         if let presenter = alertController.popoverPresentationController,
            index = symbols.indexOf(symbol),
            cell = collectionView?.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0)) as? PositionCollectionViewCell {
               presenter.sourceView = cell
               presenter.sourceRect = cell.bounds
         }
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
      loadShares()
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
      let defaults = NSUserDefaults.standardUserDefaults()
      switch controllerType {
      case .Portfolio:
         defaults.setObject(symbols, forKey: savedPortfolioSymbolsIdentifier)
         defaults.setObject(shares, forKey: savedPortfolioSharesIdentifier)
      case .WatchList:
         defaults.setObject(symbols, forKey: savedWatchListSymbolsIdentifier)
      }
      defaults.synchronize()
   }

   
   // MARK: - Other
   
   /**
   Enables refresh capability.
   */
   private func enableRefresh() {
      refreshButton.enabled = true
   }
   
   
   /**
    Disables refresh capability for 1 minute.
    */
   private func disableRefresh() {
      refreshButton.enabled = false
      NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: #selector(refreshTimerFired(_:)),
         userInfo: nil, repeats: false)
   }

   
   /**
   Loads saved symbols and builds positions from the server.
   */
   private func loadPositions() {
      for symbol in savedSymbols {
         NetworkManager.sharedInstance.fetchPositionForSymbol(symbol) {
            [unowned self] (position: Position?, error: NSError?) -> Void in
            var newPosition: Position
            if let position = position where position.symbol == symbol {
               newPosition = position
               newPosition.memberType = self.controllerType
            } else {
               newPosition = self.defaultPositionForSymbol(symbol)
            }
            if let shares = self.shares[symbol] {
               newPosition.shares = shares
            }
            self.positions[symbol] = newPosition
            if let currentIndex = PositionCoordinator.insertionIndexForSymbol(symbol, from: self.savedSymbols, into: self.symbols) {
               self.symbols.insert(symbol, atIndex: currentIndex)
               self.collectionView?.insertItemsAtIndexPaths([NSIndexPath(forItem: currentIndex, inSection: 0)])
            }
            if let error = error {
               self.appCoordinator.presentErrorToUser(title: "Retrieval Error",
                  message: error.localizedDescription)
            }
         }
      }
   }
   
   
   /**
    Loads saved shares.
    */
   private func loadShares() {
      shares = savedShares
   }
   
   
   /**
    Refreshes the positions from the server.
    */
   private func refreshPositions() {
      for symbol in symbols {
         NetworkManager.sharedInstance.fetchPositionForSymbol(symbol) {
            [unowned self] (position: Position?, error: NSError?) -> Void in
            if var newPosition = position,
               let index = self.symbols.indexOf(symbol)
               where newPosition.symbol == symbol {
                  newPosition.memberType = self.controllerType
                  if let shares = self.shares[symbol] {
                     newPosition.shares = shares
                  }
                  self.positions[symbol] = newPosition
                  self.collectionView?.reloadItemsAtIndexPaths([NSIndexPath(forItem: index, inSection: 0)])
            }
         }
      }
   }
   
   
   /**
    Creates and returns a simple default position.
    
    - returns: A default position.
    */
   private func defaultPosition() -> Position {
      var position = Position()
      position.memberType = controllerType
      return position
   }
   
   
   /**
    Creates and returns a default position with the symbol applied.
    
    - parameter symbol: The investment position ticker symbol.
    
    - returns: A default position with applied symbol.
    */
   private func defaultPositionForSymbol(symbol: String) -> Position {
      var position = defaultPosition()
      position.symbol = symbol
      return position
   }
   
   
   /**
    Returns a position for the specified symbol.
    
    - parameter symbol: The investment position ticker symbol.
    
    - returns: The saved position if found, otherwise a new default position.
    */
   private func savedPositionForSymbol(symbol: String) -> Position {
      guard !symbol.isEmpty else {
         return defaultPosition()
      }
      
      if let savedPosition = positions[symbol] where savedPosition.symbol == symbol {
         return savedPosition
      } else {
         return defaultPositionForSymbol(symbol)
      }
   }
}


// MARK: - UICollectionViewDataSource

extension PortfolioViewController {
   
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
      let position = savedPositionForSymbol(symbol)
      
      // Configure cell
      cell.configure(with: position)
      
      return cell
   }
   
   
   override func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
      let temp = symbols.removeAtIndex(sourceIndexPath.item)
      symbols.insert(temp, atIndex: destinationIndexPath.item)
      saveState()
   }
}


// MARK: - UICollectionViewDelegate

extension PortfolioViewController {
   
   override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
      return !editing
   }
   
   
   override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
      let symbol = symbols[indexPath.item]
      let detailViewController = PositionViewController()
      detailViewController.title = symbol
      detailViewController.position = savedPositionForSymbol(symbol)
      
      // Present position detail view controller
      switch appCoordinator.deviceType {
      case .Pad:  // apply as popover
         detailViewController.modalPresentationStyle = .Popover
         if let presenter = detailViewController.popoverPresentationController,
            cell = collectionView.cellForItemAtIndexPath(indexPath) as? PositionCollectionViewCell {
               presenter.sourceView = cell
               presenter.sourceRect = cell.bounds
         }
         visibleDetailViewController = detailViewController
         presentViewController(detailViewController, animated: true, completion: nil)
      default:
         navigationController?.pushViewController(detailViewController, animated: true)
      }
   }
}


// MARK: - UITextFieldDelegate

extension PortfolioViewController: UITextFieldDelegate {
   
   func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
      if textField.tag == SelectedTextField.Shares.identifier {
         let invalidCharacters = NSCharacterSet(charactersInString: "0123456789.").invertedSet
         let filteredString = string.componentsSeparatedByCharactersInSet(invalidCharacters).joinWithSeparator("")
         return string == filteredString
      } else {
         return true
      }
   }
   
   
   func textFieldShouldReturn(textField: UITextField) -> Bool {
      return true
   }
}
