//
//  PositionCollectionViewCell.swift
//  Portfolio
//
//  Created by John Woolsey on 1/26/16.
//  Copyright © 2016 ExtremeBytes Software. All rights reserved.
//


import UIKit


class PositionCollectionViewCell: UICollectionViewCell {
   
   // MARK: - Properties
   
   @IBOutlet weak var symbolLabel: UILabel!
   @IBOutlet weak var nameLabel: UILabel!
   @IBOutlet weak var quoteLabel: UILabel!
   @IBOutlet weak var changeLabel: UILabel!
   @IBOutlet weak var valueLabel: UILabel!
   @IBOutlet weak var statusLabel: UILabel!
   @IBOutlet weak var valueLayoutConstraint: NSLayoutConstraint!
   
   
   // MARK: - Lifecycle
   
   override func awakeFromNib() {
      super.awakeFromNib()
      applyTheme()
   }
   
   
   // MARK: - Configuration
   
   /**
   Applies view specific theming.
   */
   private func applyTheme() {
   }
}
