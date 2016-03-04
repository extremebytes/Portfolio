//
//  AppDelegate.swift
//  Portfolio
//
//  Created by John Woolsey on 1/26/16.
//  Copyright © 2016 ExtremeBytes Software. All rights reserved.
//


import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
   
   // MARK: - Properties
   
   let portfolioTitle = "Portfolio"
   let watchListTitle = "Watch List"

   var window: UIWindow?

   
   // MARK: - Application Lifecycle
   
   func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
      configureApplication()
      applyTheme()
      return true
   }
   
   
   func applicationWillResignActive(application: UIApplication) {
      // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
      // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   }
   
   
   func applicationDidEnterBackground(application: UIApplication) {
      // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
      // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   }
   
   
   func applicationWillEnterForeground(application: UIApplication) {
      // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
   }
   
   
   func applicationDidBecomeActive(application: UIApplication) {
      // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   }
   
   
   func applicationWillTerminate(application: UIApplication) {
      // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
   }
   
   
   // MARK: - Application Configuration
   
   /**
   Applies global application theming.
   */
   func applyTheme() {
      window?.tintColor = ThemeManager.sharedInstance.globalThemeColor
   }

   
   /**
   Configures the application.
   */
   func configureApplication() {
      // Set up personal portfolio
      let personalPortfolioViewController = PortfolioViewController.init(collectionViewLayout: UICollectionViewLayout())
      personalPortfolioViewController.title = portfolioTitle
      let personalPortfolioNavigationController = UINavigationController.init(rootViewController: personalPortfolioViewController)
      
      // Set up watch list portfolio
      let watchlistPortfolioViewController = PortfolioViewController.init(collectionViewLayout: UICollectionViewLayout())
      watchlistPortfolioViewController.title = watchListTitle
      let watchlistPortfolioNavigationController = UINavigationController.init(rootViewController: watchlistPortfolioViewController)
      
      // Set up tab bar
      let tabBarController = UITabBarController()
      tabBarController.setViewControllers([personalPortfolioNavigationController, watchlistPortfolioNavigationController], animated: false)
      
      // Set up main window
      window = UIWindow()
      window?.rootViewController = tabBarController
      window?.makeKeyAndVisible()
   }
}


// MARK: - UITabBarController Extension

// The following resolves a rotation issue when a view controller is embedded in a navigation controller
// which is embedded in a tab bar controller.
extension UITabBarController {
   override public func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
      self.selectedViewController?.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
   }
}
