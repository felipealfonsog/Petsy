//
//  NetworkStatusListener.swift
//  Petsy
//
//  Created by Scott Campbell on 11/13/17.
//  Copyright © 2017 DotConfirmed. All rights reserved.
//

import Foundation
import ReachabilitySwift

protocol NetworkStatusListener: class {
  
  /**
   Required: Called by ReachabilityManager whenever there is a change in network reachability status.
   - Parameter status: Current network reachability status.
   */
  func networkStatusDidChange(status: Reachability.NetworkStatus)
}
