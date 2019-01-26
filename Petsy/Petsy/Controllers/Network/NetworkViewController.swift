//
//  NetworkViewController.swift
//  Petsy
//
//  Created by Scott Campbell on 11/13/17.
//  Copyright © 2017 DotConfirmed. All rights reserved.
//

import UIKit
import ReachabilitySwift

class NetworkViewController: UIViewController {
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // Connect the network listener.
    ReachabilityManager.shared.addListener(listener: self)
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    // Detatch the network listener.
    ReachabilityManager.shared.removeListener(listener: self)
  }
  
  // MARK: - Targets
  
  /**
   Show the network popup if the user loses connection.
   */
  func cannotReachNetwork() {
    NoNetworkPopup.shared.show()
  }
  
  /**
   Kill the network popup if the use reconnects.
   */
  func canReachNetwork() {
    NoNetworkPopup.shared.kill()
  }
}

// MARK: - NetworkStatusListener protocol
extension NetworkViewController: NetworkStatusListener {
  
  func networkStatusDidChange(status: Reachability.NetworkStatus) {
    switch status {
    case .notReachable: cannotReachNetwork()
    default: canReachNetwork()
    }
  }
}

