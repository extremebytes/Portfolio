//
//  NetworkManager.swift
//  Portfolio
//
//  Created by John Woolsey on 1/26/16.
//  Copyright © 2016 ExtremeBytes Software. All rights reserved.
//


// Example network call: http://dev.markitondemand.com/MODApis/Api/quote/json?symbol=AAPL
// Note: The Market On Demand service that supplies the API used in this project has very limited bandwidth
//       so only a limited number of positions should be used.


import Foundation
import UIKit


// MARK: - Enumerations

enum NetworkError: Int, Error {
   case noConnection = 1 ,invalidRequest, invalidResponse, unknown
   
   var description: String {
      switch self {
      case .noConnection:
         return "No internet connection or the server could not be reached. Please check your settings and try again. Contact the vendor if you continue to see this issue."
      case .invalidRequest:
         return "Attempted to submit an invalid request to the server. Please try again. Contact the vendor if you continue to see this issue."
      case .invalidResponse:
         return "Received an invalid response from the server. Please try again. Contact the vendor if you continue to see this issue."
      case .unknown:
         return "An unknown network error occurred. Please try again. Please contact the vendor if you continue to see this issue."
      }
   }
   
   var error: Error {
      return NSError(domain: NetworkManager.shared.errorDomain,
                     code: hashValue,
                     userInfo: [NSLocalizedDescriptionKey: NSLocalizedString(description, comment: "")]) as Error
   }
}


class NetworkManager {
   
   // MARK: - Properties
   
   static let shared = NetworkManager()  // singleton
   
   var isNetworkAvailable: Bool { return NetworkReachability.isConnectedToNetwork() }
   
   private let baseURL = URL(string: "http://dev.markitondemand.com/MODApis/Api/quote/json")
   private let queryParameter = "symbol"
   private let maximumOperationsPerSecond = 5  // service is limited to about 10 operations per second, but sometimes drastically lower
   fileprivate let errorDomain = "com.extremebytes.portfolio"
   
   private var operationsQueue: [URLSessionTask] = []
   private var operationTimer: Timer?
   private var operationsInProgress = 0 {
      didSet {
         if operationsInProgress > 0 {
            showNetworkIndicator()
            if operationTimer == nil || operationTimer?.isValid == false {
               operationTimer = Timer.scheduledTimer(timeInterval: 1.1,
                                                     target: self,
                                                     selector: #selector(fetchTimerFired(_:)),
                                                     userInfo: nil,
                                                     repeats: true)
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
   @objc func fetchTimerFired(_ sender: Timer) {  // @objc required for recognizing method selector signature
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
   func fetchPosition(for symbol: String, completion: @escaping (_ position: Position?, _ error: Error?) -> Void) {
      var position: Position?
      var error: Error?
      
      // Verify network request
      guard !symbol.isEmpty,
         let baseURL = baseURL,
         var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
         DispatchQueue.main.async {
            completion(nil, NetworkError.invalidRequest.error)
         }
         return
      }
      components.queryItems = [URLQueryItem(name: queryParameter, value: symbol)]
      guard let requestURL = components.url else {
         DispatchQueue.main.async {
            completion(nil, NetworkError.invalidRequest.error)
         }
         return
      }
      
      // Create network request
      let task = URLSession.shared.dataTask(with: requestURL) { serverData, serverResponse, serverError in
         self.operationsInProgress -= 1
         #if DEBUG
            print("Finished fetch: \(self.operationsInProgress) in progress")
         #endif
         
         // Check and apply server results
         do {
            if let serverError = serverError {  // check server error
               if !self.isNetworkAvailable {
                  error = NetworkError.noConnection.error
               } else {
                  error = serverError
               }
            } else if let serverResponse = serverResponse as? HTTPURLResponse,
               !(200...299 ~= serverResponse.statusCode) {  // check server response
               print("Invalid server response code: \(serverResponse.statusCode)")
               error = NetworkError.invalidResponse.error
            } else if let serverData = serverData,  // check server data
               let jsonObject = try JSONSerialization.jsonObject(with: serverData, options: []) as? JSONDictionary {
//               #if DEBUG
//                  let serverString = NSString(data: serverData, encoding: String.Encoding.utf8.rawValue)
//                  print("String data from server:\n\(serverString)")
//               #endif
               position = Position.forJSON(jsonObject)
            }
         } catch let jsonError {
            error = jsonError
         }
         
         // Execute completion handler
         DispatchQueue.main.async {
            completion(position, error)
         }
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
      DispatchQueue.main.async {
         UIApplication.shared.isNetworkActivityIndicatorVisible = false
      }
   }
   
   
   /**
    Shows the status bar network indicator.
    */
   func showNetworkIndicator() {
      DispatchQueue.main.async {
         UIApplication.shared.isNetworkActivityIndicatorVisible = true
      }
   }
   
   
   /**
    Submits a batch of network jobs.
    */
   private func batchJobs() {
      guard isNetworkAvailable else {
         let error = NetworkError.noConnection.error
         AppCoordinator.shared.presentErrorToUser(title: "Network Unvailable", message: error.localizedDescription)
         return
      }
      
      let numberOfBatchTasks = operationsQueue.count < maximumOperationsPerSecond ?
         operationsQueue.count : maximumOperationsPerSecond
      #if DEBUG
         print("Number of batch tasks: \(numberOfBatchTasks)")
      #endif
      for task in operationsQueue[0..<numberOfBatchTasks] {
         task.resume()
      }
      operationsQueue.removeFirst(numberOfBatchTasks)
   }
}
