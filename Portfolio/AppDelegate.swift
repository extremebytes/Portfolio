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
   
   var window: UIWindow?
   
   
   // MARK: - Lifecycle
   
   func application(_ application: UIApplication,
                    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      configureApplication()
      applyTheme()
      return true
   }
   
   
   func applicationWillResignActive(_ application: UIApplication) {
      // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
      // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   }
   
   
   func applicationDidEnterBackground(_ application: UIApplication) {
      // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
      // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   }
   
   
   func applicationWillEnterForeground(_ application: UIApplication) {
      // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
   }
   
   
   func applicationDidBecomeActive(_ application: UIApplication) {
      // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   }
   
   
   func applicationWillTerminate(_ application: UIApplication) {
      // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
   }
   
   
   // MARK: - Configuration
   
   /**
    Applies global application theming.
    */
   private func applyTheme() {
      ThemeManager.applyTheme(ThemeManager.currentTheme)
   }
   
   
   /**
    Configures the application.
    */
   private func configureApplication() {
      // Set up personal portfolio
      let personalPortfolioViewController = PortfolioViewController.init(collectionViewLayout: UICollectionViewLayout())
      personalPortfolioViewController.title = PositionMemberType.portfolio.title
      let personalPortfolioNavigationController =
         UINavigationController.init(rootViewController: personalPortfolioViewController)
      
      // Set up watch list portfolio
      let watchlistPortfolioViewController =
         PortfolioViewController.init(collectionViewLayout: UICollectionViewLayout())
      watchlistPortfolioViewController.title = PositionMemberType.watchList.title
      let watchlistPortfolioNavigationController =
         UINavigationController.init(rootViewController: watchlistPortfolioViewController)
      
      // Set up tab bar
      let tabBarController = UITabBarController()
      tabBarController.setViewControllers([personalPortfolioNavigationController,
                                           watchlistPortfolioNavigationController],
                                          animated: false)
      tabBarController.tabBar.items?.first?.image = UIImage(named: "Dollar")
      tabBarController.tabBar.items?.last?.image = UIImage(named: "Percent")
      
      // Clear defaults system for UI testing
      if ProcessInfo.processInfo.arguments.contains("UITesting") {
         if let bundleIdentifier = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleIdentifier)
            print("Defaults system cleared.")
         } else {
            print("Defaults system not cleared.")
         }
      }
      
      // Set up main window
      window = UIWindow()
      window?.rootViewController = tabBarController
      window?.makeKeyAndVisible()
   }
}
