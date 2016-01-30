//
//  PortfolioViewController.swift
//  Portfolio
//
//  Created by John Woolsey on 1/26/16.
//  Copyright © 2016 ExtremeBytes Software. All rights reserved.
//


import UIKit


class PortfolioViewController: UIViewController {
   
   // MARK: - Properties
   
   @IBOutlet weak var portfolioCollectionView: UICollectionView!
   let positionCellReuseIdentifier = "PositionCell"
   let minimumPositionCellSize = CGSize(width: 220, height: 68)
   let spacerSize = CGSize(width: 8, height: 8)
   var positions: [Position] = []
   
   
   // MARK: - View Lifecycle
   
   override func viewDidLoad() {
      super.viewDidLoad()
      configureNavigationBar()
      configureCollectionView()
   }
   
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
   }
   
   
   override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
      super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
      coordinator.animateAlongsideTransition({ [unowned self] _ in
         self.updateCollectionViewFlowLayout()
         }, completion: nil)
   }

   
   // MARK: - View Configuration
   
   /**
   Configures the navigation bar.
   */
   func configureNavigationBar() {
      let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("addButtonPressed:"))
      let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: Selector("editButtonPressed:"))
      self.navigationItem.rightBarButtonItems = [editButton, addButton]
   }
   
   
   /**
    Calculates and returns the size of an investment position collection view cell.
    
    - returns: The size of the cell.
    */
   func getPositionCellSize() -> CGSize {
      let screenWidth = UIScreen.mainScreen().bounds.width
      var itemSize: CGSize
      if screenWidth < minimumPositionCellSize.width * 2 + spacerSize.width * 3 {  // 1 item per row
         itemSize = CGSize(width: screenWidth - spacerSize.width * 2, height: minimumPositionCellSize.height)
      } else if screenWidth < minimumPositionCellSize.width * 3 + spacerSize.width * 4 {  // 2 items per row
         itemSize = CGSize(width: (screenWidth - spacerSize.width * 3) / 2, height: minimumPositionCellSize.height)
      } else if screenWidth < minimumPositionCellSize.width * 4 + spacerSize.width * 5 {  // 3 items per row
         itemSize = CGSize(width: (screenWidth - spacerSize.width * 4) / 3, height: minimumPositionCellSize.height)
      } else {  // 4 items per row (maximum)
         itemSize = CGSize(width: (screenWidth - spacerSize.width * 5) / 4, height: minimumPositionCellSize.height)
      }
      return itemSize
   }
   
   
   /**
    Configures the portfolio collection view.
    */
   func configureCollectionView() {
      portfolioCollectionView.backgroundColor = UIColor.whiteColor()
      portfolioCollectionView.registerNib(UINib(nibName: "PositionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: positionCellReuseIdentifier)
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
      self.portfolioCollectionView?.collectionViewLayout = flowLayout
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
    Enables editing of the portfolio when the Edit button is pressed.
    
    - parameter sender: The object that requested the action.
    */
   func editButtonPressed(sender: UIBarButtonItem) {
   }

   
   // MARK: - Other

   /**
   Presents an error via a pop up window to the user.
   
   - parameter title:   The window title.
   - parameter message: The error message to display to the user.
   */
   func presentErrorToUser(title title: String, message: String) {
      let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
      let okAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
      alertController.addAction(okAction)
      self.presentViewController(alertController, animated: true, completion: nil)
      return
   }
   
   
   /**
   Presents a pop up window to the user requesting a new symbol to add an investment postion to the portfolio.
   */
   func requestSymbolFromUser() {
      // Present pop up symbol input view to user
      let alertController = UIAlertController(title: "Enter Symbol",
         message: "Enter the exchange symbol for the stock or other investment you would like to add.",
         preferredStyle: .Alert)
      let addAction = UIAlertAction(title: "Add", style: .Default) { [unowned self] action in
         self.addPositionToPortfolio(alertController.textFields?[0].text?.uppercaseString)
      }
      alertController.addAction(addAction)
      let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
      alertController.addAction(cancelAction)
      alertController.addTextFieldWithConfigurationHandler { (textField: UITextField!) in
         textField.placeholder = "Enter Symbol"
      }
      self.presentViewController(alertController, animated: true, completion: nil)
      return
   }
   
   
   /**
    Adds a new investment postion to the portfolio.
    
    - parameter symbol: The symbol of the position.
    */
   func addPositionToPortfolio(symbol: String?) {
      // Validate input
      guard let symbol = symbol where !symbol.isEmpty else {
         presentErrorToUser(title: "Invalid Symbol", message: "Received an invalid symbol from the user. Please try again.")
         return
      }
      
      // Fetch symbol information from service and add to positions
      NetworkManager.sharedInstance.fetchPositionForSymbol(symbol) { [unowned self] (position: Position?, error: NSError?) -> Void in
         if let error = error {
            self.presentErrorToUser(title: "Retrieval Error", message: error.localizedDescription)
         } else if let position = position {
            self.positions.append(position)
            self.portfolioCollectionView.reloadData()
         } else {
            self.presentErrorToUser(title: "Creation Error", message: "The investment position could not be created. Please try again.")
         }
      }
   }
}


// MARK: - UICollectionViewDataSource

extension PortfolioViewController: UICollectionViewDataSource {
   
   func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return positions.count
   }
   
   
   func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCellWithReuseIdentifier(positionCellReuseIdentifier, forIndexPath: indexPath) as! PositionCollectionViewCell
      
      // Configure cell
      cell.symbolLabel?.text = positions[indexPath.row].symbol
      cell.nameLabel?.text = positions[indexPath.row].name
      cell.quoteLabel?.text = positions[indexPath.row].lastPrice
      cell.changeLabel?.text = positions[indexPath.row].changePercent
      if Double(positions[indexPath.row].changePercent.substringToIndex(positions[indexPath.row].changePercent.endIndex.predecessor())) < 0 {
         cell.changeLabel?.textColor = UIColor.redColor()
      } else {
         cell.changeLabel?.textColor = UIColor.greenColor()
      }
      
      return cell
   }
}
