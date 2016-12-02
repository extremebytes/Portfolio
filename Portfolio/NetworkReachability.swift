//
//  NetworkReachability.swift
//  Portfolio
//
//  Created by John Woolsey on 3/7/16.
//  Copyright © 2016 ExtremeBytes Software. All rights reserved.
//


import Foundation
import SystemConfiguration


class NetworkReachability {
   
   /// Checks whether the network is reachable.
   ///
   /// The code was obtained from the following URL.
   /// http://stackoverflow.com/questions/39675445/reachability-returns-false-for-cellular-network-in-ios-swift
   ///
   /// - Returns: The reachability of the network, either true or false.
   class func isConnectedToNetwork() -> Bool {
      var zeroAddress = sockaddr_in()
      zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
      zeroAddress.sin_family = sa_family_t(AF_INET)
      let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
         $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
         }
      }
      var flags : SCNetworkReachabilityFlags = []
      if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
         return false
      }
      let isReachable = flags.contains(.reachable)
      let needsConnection = flags.contains(.connectionRequired)
      return (isReachable && !needsConnection)
   }
}
