//
//  NetworkManager.swift
//  Portfolio
//
//  Created by John Woolsey on 1/26/16.
//  Copyright © 2016 ExtremeBytes Software. All rights reserved.
//


import Foundation
import UIKit


class NetworkManager {
   
   // MARK: - Properties
   
   static let sharedInstance = NetworkManager()  // singleton
   let baseURL = NSURL(string: "http://dev.markitondemand.com/api/quote/json")
   let queryParameter = "symbol"
   let errorDomain = "com.extremebytes.portfolio"
   
   
   // MARK: - Errors
   
   enum NetworkErrors: Int, ErrorType {
      case NoConnection = 1
      case InvalidInput
      case InvalidServerResponse
      case InvalidURL
      case Unknown
      
      var description: String {
         switch self {
         case .NoConnection:
            return "No internet connection or the server could not be reached. Please check your settings and try again. Contact the vendor if you continue to see this issue."
         case .InvalidInput:
            return "The provided value was invalid. Please enter a different value and try again."
         case .InvalidServerResponse:
            return "Received an invalid response from the server. Please try again. Contact the vendor if you continue to see this issue."
         case .InvalidURL:
            return NetworkErrors.InvalidServerResponse.description
         case .Unknown:
            return "An unknown network error occurred. Please try again. Please contact the vendor if you continue to see this issue."
         }
      }
   }

   
   // MARK: - Lifecycle
   
   private init() {}  // prevents use of default initializer
   
   
   // MARK: - Network Operations
   
   /**
   Fetches details for an investment position from the server.
   
   - parameter symbol:     The ticker symbol representing the investment.
   - parameter completion: A closure that is executed upon completion.
   */
   func fetchPositionForSymbol(symbol: String, completion: (position: Position, error: NSError?) -> Void) {
      var position = Position()
      var error: NSError? = nil
      
      if !symbol.isEmpty {
         if let baseURL = baseURL, components = NSURLComponents(URL: baseURL, resolvingAgainstBaseURL: true) {
            components.queryItems = [NSURLQueryItem(name: queryParameter, value: symbol)]
            if let requestURL = components.URL {
               // Create network request
               let serverSession = NSURLSession.sharedSession()
               let task = serverSession.dataTaskWithURL(requestURL) {
                  [unowned self] (serverData: NSData?, serverResponse: NSURLResponse?, serverError: NSError?) -> Void in
                  // Hide network indicator
                  dispatch_async(dispatch_get_main_queue(), {
                     UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                  })
                  
                  // Create position with server response
                  if let serverData = serverData {
                     do {
                        if let jsonObject = try NSJSONSerialization.JSONObjectWithData(serverData, options: []) as? [String:AnyObject] {
                           position = PositionCoordinator.sharedInstance.positionForJSON(jsonObject)
                           if position.isEmpty {
                              error = NSError(domain: self.errorDomain, code: NetworkErrors.InvalidServerResponse.hashValue,
                                 userInfo: [NSLocalizedDescriptionKey: NSLocalizedString(NetworkErrors.InvalidServerResponse.description, comment: "")])
                           }
                        }
                     } catch let localError as NSError {
                        error = localError
                     }
                  } else {
                     error = NSError(domain: self.errorDomain, code: NetworkErrors.InvalidServerResponse.hashValue,
                        userInfo: [NSLocalizedDescriptionKey: NSLocalizedString(NetworkErrors.InvalidServerResponse.description, comment: "")])
                  }
                  
                  // Execute completion handler
                  dispatch_async(dispatch_get_main_queue(), {
                     completion(position: position, error: error)
                  })
               }
               
               // Show network indicator
               dispatch_async(dispatch_get_main_queue(), {
                  UIApplication.sharedApplication().networkActivityIndicatorVisible = true
               })
               
               // Execute network request
               task.resume()
            } else {  // invalid request URL
               error = NSError(domain: errorDomain, code: NetworkErrors.InvalidURL.hashValue,
                  userInfo: [NSLocalizedDescriptionKey: NSLocalizedString(NetworkErrors.InvalidURL.description, comment: "")])
            }
         } else {  // invalid base URL or components
            error = NSError(domain: errorDomain, code: NetworkErrors.InvalidURL.hashValue,
               userInfo: [NSLocalizedDescriptionKey: NSLocalizedString(NetworkErrors.InvalidURL.description, comment: "")])
         }
      } else {  // invalid symbol
         error = NSError(domain: errorDomain, code: NetworkErrors.InvalidInput.hashValue,
            userInfo: [NSLocalizedDescriptionKey: NSLocalizedString(NetworkErrors.InvalidInput.description, comment: "")])
      }
      
      // Execute completion handler
      if let error = error {
         dispatch_async(dispatch_get_main_queue(), {
            completion(position: position, error: error)
         })
      }
   }
}