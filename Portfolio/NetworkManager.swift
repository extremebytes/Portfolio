//
//  NetworkManager.swift
//  Portfolio
//
//  Created by John Woolsey on 1/26/16.
//  Copyright © 2016 ExtremeBytes Software. All rights reserved.
//


// Note: The Market On Demand service that supplies the API used in this project has very limited bandwidth
//       so only a limited number of positions should be used.


import Foundation
import UIKit


// MARK: - Enumerations

enum NetworkError: Int, ErrorType {
   case NoConnection = 1
   case InvalidRequest
   case InvalidResponse
   case Unknown
   
   var description: String {
      switch self {
      case .NoConnection:
         return "No internet connection or the server could not be reached. Please check your settings and try again. Contact the vendor if you continue to see this issue."
      case .InvalidRequest:
         return "Attempted to submit an invalid request to the server. Please try again. Contact the vendor if you continue to see this issue."
      case .InvalidResponse:
         return "Received an invalid response from the server. Please try again. Contact the vendor if you continue to see this issue."
      case .Unknown:
         return "An unknown network error occurred. Please try again. Please contact the vendor if you continue to see this issue."
      }
   }
   
   var error: NSError {
      return NSError(domain: NetworkManager.sharedInstance.errorDomain,
         code: hashValue,
         userInfo: [NSLocalizedDescriptionKey: NSLocalizedString(description, comment: "")])
   }
}


class NetworkManager {
   
   // MARK: - Properties
   
   static let sharedInstance = NetworkManager()  // singleton
   
   var networkAvailable: Bool {
      return NetworkReachability.isConnectedToNetwork()
   }

   private let baseURL = NSURL(string: "http://dev.markitondemand.com/MODApis/Api/quote/json")
   private let queryParameter = "symbol"
   private let maximumOperationsPerSecond = 10  // service is limited to about 10 operations per second, but sometimes drastically lower
   private let errorDomain = "com.extremebytes.portfolio"
   
   private var operationsQueue: [NSURLSessionTask] = []
   private var operationTimer: NSTimer?
   
   private var operationsInProgress = 0 {
      didSet {
         if operationsInProgress > 0 {
            showNetworkIndicator()
            if operationTimer == nil || operationTimer?.valid == false {
               operationTimer = NSTimer.scheduledTimerWithTimeInterval(1.1, target: self, selector: #selector(fetchTimerFired(_:)), userInfo: nil, repeats: true)
            }
         } else {
            operationTimer?.invalidate()
            operationTimer = nil
            hideNetworkIndicator()
         }
      }
   }

   
   // MARK: - Lifecycle
   
   private init() {}  // prevents use of default initializer
   
   
   // MARK: - Actions
   
   /**
   Requests a batch of network jobs to be submitted when the fetch timer is fired.
   
   - parameter sender: The object that requested the action.
   */
   @objc func fetchTimerFired(sender: NSTimer) {  // @objc required for recognizing method selector signature
      #if DEBUG
         print("Fetch timer fired.")
      #endif
      batchJobs()
   }

   
   // MARK: - Network Operations
   
   /**
   Fetches details for an investment position from the server.
   
   - parameter symbol:     The ticker symbol representing the investment.
   - parameter completion: A closure that is executed upon completion.
   */
   func fetchPositionForSymbol(symbol: String, completion: (position: Position?, error: NSError?) -> Void) {
      var position: Position?
      var error: NSError?
      
      // Verify network request
      guard let baseURL = baseURL, components = NSURLComponents(URL: baseURL, resolvingAgainstBaseURL: true)
         where !symbol.isEmpty else {
            dispatch_async(dispatch_get_main_queue(), {
               completion(position: nil, error: NetworkError.InvalidRequest.error)
            })
            return
      }
      components.queryItems = [NSURLQueryItem(name: queryParameter, value: symbol)]
      guard let requestURL = components.URL else {
         dispatch_async(dispatch_get_main_queue(), {
            completion(position: nil, error: NetworkError.InvalidRequest.error)
         })
         return
      }
      
      // Create network request
      let task = NSURLSession.sharedSession().dataTaskWithURL(requestURL) {
         [unowned self] (serverData: NSData?, serverResponse: NSURLResponse?, serverError: NSError?) -> Void in
         self.operationsInProgress -= 1
         #if DEBUG
            print("Finished fetch: \(self.operationsInProgress) in progress")
         #endif
         
         // Check and apply server results
         do {
            if let serverError = serverError {  // check server error
               if !self.networkAvailable {
                  error = NetworkError.NoConnection.error
               } else {
                  error = serverError
               }
            } else if let serverResponse = serverResponse as? NSHTTPURLResponse where !(200...299 ~= serverResponse.statusCode) {  // check server response
               print("Invalid server response code: \(serverResponse.statusCode)")
               error = NetworkError.InvalidResponse.error
            } else if let serverData = serverData,  // check server data
               jsonObject = try NSJSONSerialization.JSONObjectWithData(serverData, options: []) as? JSONDictionary {
//                  #if DEBUG
//                     let serverString = NSString(data: serverData, encoding: NSUTF8StringEncoding)
//                     print("String data from server:\n\(serverString)")
//                  #endif
                  position = Position.forJSON(jsonObject)
            }
         } catch let jsonError as NSError {
            error = jsonError
         }
         
         // Execute completion handler
         dispatch_async(dispatch_get_main_queue(), {
            completion(position: position, error: error)
         })
      }
      
      // Queue network request
      operationsInProgress += 1
      #if DEBUG
         print("Started fetch: \(operationsInProgress) in progress")
      #endif
      operationsQueue.append(task)
   }

   
   // MARK: - Other
   
   /**
   Hides the status bar network indicator.
   */
   func hideNetworkIndicator() {
      dispatch_async(dispatch_get_main_queue(), {
         UIApplication.sharedApplication().networkActivityIndicatorVisible = false
      })
   }
   
   
   /**
    Shows the status bar network indicator.
    */
   func showNetworkIndicator() {
      dispatch_async(dispatch_get_main_queue(), {
         UIApplication.sharedApplication().networkActivityIndicatorVisible = true
      })
   }
   
   
   /**
    Submits a batch of network jobs.
    */
   private func batchJobs() {
      guard networkAvailable else {
         let error = NetworkError.NoConnection.error
         AppCoordinator.sharedInstance.presentErrorToUser(title: "Network Unvailable", message: error.localizedDescription)
         return
      }
      
      let numberOfBatchTasks = operationsQueue.count < maximumOperationsPerSecond ? operationsQueue.count : maximumOperationsPerSecond
      #if DEBUG
         print("Number of batch tasks: \(numberOfBatchTasks)")
      #endif
      for task in operationsQueue[0..<numberOfBatchTasks] {
         task.resume()
      }
      operationsQueue.removeFirst(numberOfBatchTasks)
   }
}
