//
//  ReachabilityManager.swift
//  Petsy
//
//  Created by Scott Campbell on 11/13/17.
//  Copyright © 2017 DotConfirmed. All rights reserved.
//

import UIKit
import ReachabilitySwift

class ReachabilityManager: NSObject {
  
  // MARK: - Properties
  static let shared = ReachabilityManager() // Singleton
  
  // Track network reachability.
  var isNetworkAvailable: Bool {
    return reachabilityStatus != .notReachable
  }
  
  // Track current NetworkStatus (notReachable, reachableViaWifi, reachableViaWWAN)
  var reachabilityStatus: Reachability.NetworkStatus = .notReachable
  
  // Reachability instance for network status monitoring
  let reachability = Reachability()!
  
  // Array of delegates that are interested in listening to network status changes.
  var listeners = [NetworkStatusListener]()
  
  // MARK: - Monitoring
  
  /**
   Called whenever there is a change in network reachability status.
   - Parameter notification: Notification with the Reachability instance.
   */
  @objc func reachabilityChanged(notification: Notification) {
    guard let reachability = notification.object as? Reachability else { return }
    
    switch reachability.currentReachabilityStatus {
    case .notReachable: debugPrint("Network became unreachable")
    case .reachableViaWiFi: debugPrint("Network reachable through Wifi")
    case .reachableViaWWAN: debugPrint("Network reachable through Cellular Data")
    }
    
    // Notify each delegate that the reachability status changed.
    for listener in listeners {
      listener.networkStatusDidChange(status: reachability.currentReachabilityStatus)
    }
  }
  
  /**
   Starts monitoring the network availability status.
   */
  func startMonitoring() {
    NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged), name: ReachabilityChangedNotification, object: reachability)
    
    do {
      try reachability.startNotifier()
    } catch {
      debugPrint("Could not start reachability notifier")
    }
  }
  
  /**
   Stops monitoring the network availability status.
   */
  func stopMonitoring() {
    reachability.stopNotifier()
    NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: reachability)
  }
  
  // MARK: - Handle listeners
  
  /**
   Add a new listener to the listeners array.
   - Parameter listener: A new listener delegate.
   */
  func addListener(listener: NetworkStatusListener) {
    listeners.append(listener)
  }
  
  /**
   Remove a listener from the listeners array.
   - Parameter listener: The listener delegate to be removed.
   */
  func removeListener(listener: NetworkStatusListener) {
    listeners = listeners.filter { $0 !== listener }
  }
}
