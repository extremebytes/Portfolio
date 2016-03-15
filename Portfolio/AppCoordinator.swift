//
//  AppCoordinator.swift
//  Portfolio
//
//  Created by John Woolsey on 3/3/16.
//  Copyright © 2016 ExtremeBytes Software. All rights reserved.
//


import Foundation
import UIKit


class AppCoordinator {
   
   // MARK: - Properties
   
   static let sharedInstance = AppCoordinator()  // singleton
   
   var errorOnScreen = false
   
   var deviceType: UIUserInterfaceIdiom {
      return UIDevice.currentDevice().userInterfaceIdiom
   }
   
   
   // MARK: - Lifecycle
   
   private init() {}  // prevents use of default initializer

   
   // MARK: - Helper Functions
   
   /**
   Presents an error to the user via a pop up window.
   
   - parameter title:   The window title.
   - parameter message: The error message.
   */
   func presentErrorToUser(title title: String, message: String) {
      guard !errorOnScreen else {
         return  // don't show additional errors
      }
      guard let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate,
      rootViewController = appDelegate.window?.rootViewController else {
         return  // no view controller
      }
      
      errorOnScreen = true
      let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
      let okAction = UIAlertAction(title: "Ok", style: .Cancel, handler: { [unowned self] action in
         self.errorOnScreen = false
         })
      alertController.addAction(okAction)
      rootViewController.presentViewController(alertController, animated: true, completion: nil)
      return
   }
}


// MARK: - UITabBarController Extension

// The following resolves a rotation issue when a view controller is embedded in a navigation controller
// which is embedded in a tab bar controller.
extension UITabBarController {
   override public func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
      selectedViewController?.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
   }
}
