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
   
   static let shared = AppCoordinator()  // singleton
   
   var deviceType: UIUserInterfaceIdiom {
      return UIDevice.current.userInterfaceIdiom
   }
   
   private var isErrorOnScreen = false
   
   
   // MARK: - Lifecycle
   
   private init() {}  // prevents use of default initializer
   
   
   // MARK: - Helper Functions
   
   /**
    Presents an error to the user via a pop up window.
    
    - parameter title:   The window title.
    - parameter message: The error message.
    */
   func presentErrorToUser(title: String, message: String) {
      guard !isErrorOnScreen else {
         return  // don't show additional errors
      }
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
         let rootViewController = appDelegate.window?.rootViewController else {
            return  // no view controller
      }
      
      isErrorOnScreen = true
      let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
      let okAction = UIAlertAction(title: "Ok", style: .cancel) { _ in self.isErrorOnScreen = false }
      alertController.addAction(okAction)
      rootViewController.present(alertController, animated: true)
      return
   }
}


// MARK: - UITabBarController Extension

// The following resolves a rotation issue when a view controller is embedded in a navigation controller
// which is embedded in a tab bar controller.
extension UITabBarController {
   override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
      selectedViewController?.viewWillTransition(to: size, with: coordinator)
   }
}
