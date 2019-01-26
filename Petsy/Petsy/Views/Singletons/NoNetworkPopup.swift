//
//  NoNetworkPopup.swift
//  Petsy
//
//  Created by Scott Campbell on 11/12/17.
//  Copyright © 2017 DotConfirmed. All rights reserved.
//

import UIKit

class NoNetworkPopup {
  
  // MARK: - Properties
  static let shared = NoNetworkPopup() // Singleton
  
  fileprivate var containerView = UIView()
  fileprivate var progressView = UIView()
  fileprivate var iconButton = UIButton()
  
  // MARK: - Initialization
  
  /**
   Private initialization to ensure ActivityIndicator is a singleton.
   */
  private init() {}
  
  // MARK: - Targets
  
  /**
   Add the ActivityIndicator to the window.
   */
  func show() {
    let window = UIApplication.shared.keyWindow!
    containerView.frame = window.frame
    containerView.center = window.center
    containerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    
    progressView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    progressView.center = window.center
    progressView.backgroundColor = UIColor.white
    progressView.clipsToBounds = true
    progressView.layer.cornerRadius = 10
    
    iconButton.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    iconButton.setImage(UIImage(named: "wifi")!, for: .normal)
    iconButton.isUserInteractionEnabled = false
    iconButton.tintColor = Constants.Colors.darkText

    iconButton.center = CGPoint(x: progressView.bounds.width / 2, y: progressView.bounds.height / 2)
    
    progressView.addSubview(iconButton)
    containerView.addSubview(progressView)
    containerView.alpha = 0.0
    window.addSubview(self.containerView)
    
    UIView.animate(withDuration: 0.1, animations: {
      self.containerView.alpha = 1.0
    })
  }
  
  /**
   Remove the ActivityIndicator from the window.
   */
  func kill() {
    UIView.animate(withDuration: 0.1, animations: {
      self.containerView.alpha = 0.0
    }) { _ in
      self.containerView.removeFromSuperview()
    }
  }
}

