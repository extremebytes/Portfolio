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
   let minimumPositionCellSize = CGSize(width: 200, height: 100)
   let spacerSize = CGSize(width: 8, height: 8)
   
   
   // MARK: - View Lifecycle
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setupCollectionView()
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
   
   
   // MARK: - Other
   
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
   
   
   func setupCollectionView() {
      portfolioCollectionView.backgroundColor = UIColor.whiteColor()
      portfolioCollectionView.registerNib(UINib(nibName: "PositionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: positionCellReuseIdentifier)
      updateCollectionViewFlowLayout()
   }
   
   
   func updateCollectionViewFlowLayout() {
      let flowLayout = UICollectionViewFlowLayout()
      flowLayout.minimumInteritemSpacing = spacerSize.width
      flowLayout.minimumLineSpacing = spacerSize.height
      flowLayout.itemSize = getPositionCellSize()
      self.portfolioCollectionView?.collectionViewLayout = flowLayout
   }
}


// MARK: - UICollectionViewDataSource

extension PortfolioViewController: UICollectionViewDataSource {
   
   func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return 8
   }
   
   
   func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCellWithReuseIdentifier(positionCellReuseIdentifier, forIndexPath: indexPath)
      return cell
   }
}
