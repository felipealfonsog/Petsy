//
//  ActivityIndicator.swift
//  Petsy
//
//  Created by Scott Campbell on 11/10/17.
//  Copyright © 2017 DotConfirmed. All rights reserved.
//

import UIKit

class ActivityIndicator {
  
  // MARK: - Properties
  static let shared = ActivityIndicator() // Singleton
  
  fileprivate var containerView = UIView()
  fileprivate var progressView = UIView()
  fileprivate var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
  
  // MARK: - Initialization
  
  /**
   Private initialization to ensure ActivityIndicator is a singleton.
   */
  private init() {}
  
  // MARK: - Targets
  
  /**
   Add the ActivityIndicator to the window.
   */
  func startAnimating() {
    let window = UIApplication.shared.keyWindow!
    containerView.frame = window.frame
    containerView.center = window.center
    containerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    
    progressView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    progressView.center = window.center
    progressView.backgroundColor = UIColor.white
    progressView.clipsToBounds = true
    progressView.layer.cornerRadius = 10
    
    activityIndicator.center = CGPoint(x: progressView.bounds.width / 2, y: progressView.bounds.height / 2)
    
    progressView.addSubview(activityIndicator)
    containerView.addSubview(progressView)
    containerView.alpha = 0.0
    window.addSubview(self.containerView)
    
    UIView.animate(withDuration: 0.1, animations: {
      self.containerView.alpha = 1.0
    })
    
    activityIndicator.startAnimating()
  }
  
  /**
   Remove the ActivityIndicator from the window.
   */
  func stopAnimating() {
    UIView.animate(withDuration: 0.1, animations: {
      self.containerView.alpha = 0.0
    }) { _ in
      self.containerView.removeFromSuperview()
    }
    
    activityIndicator.stopAnimating()
  }
}

