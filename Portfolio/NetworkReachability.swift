//
//  NetworkReachability.swift
//  Portfolio
//
//  Created by John Woolsey on 3/7/16.
//  Copyright © 2016 ExtremeBytes Software. All rights reserved.
//


import Foundation
import SystemConfiguration


// http://stackoverflow.com/questions/35905687/swift-how-to-check-for-reachability
class NetworkReachability {
   class func isConnectedToNetwork() -> Bool {
      var zeroAddress = sockaddr_in()
      zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
      zeroAddress.sin_family = sa_family_t(AF_INET)
      guard let defaultRouteReachability = withUnsafePointer(&zeroAddress, {
         SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
      }) else { return false }
      var flags: SCNetworkReachabilityFlags = []
      if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
         return false
      }
      let isReachable = flags.contains(.Reachable)
      let needsConnection = flags.contains(.ConnectionRequired)
      return (isReachable && !needsConnection)
   }
}