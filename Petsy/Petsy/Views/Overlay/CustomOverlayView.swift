//
//  CustomOverlayView.swift
//  Koloda
//
//  Created by Eugene Andreyev on 7/27/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit
import Koloda

class CustomOverlayView: OverlayView {
  
  // MARK: - Types
  fileprivate struct Img {
    static let good = "overlay-heart"
    static let bad = "overlay-cross"
  }
  
  // MARK: - Outlets
  
  @IBOutlet lazy var button: UIButton! = { [unowned self] in
    var button = UIButton(frame: self.bounds)
    self.addSubview(button)
    return button
  }()
  
  // MARK: - Lifecycle
  
  override var overlayState: SwipeResultDirection? {
    didSet {
      
      self.layer.cornerRadius = 10.0
      button.tintColor = .white
      
      switch overlayState {
      case .left? :
        button.setImage(UIImage(named: Img.bad), for: .normal)
        backgroundColor = Constants.Colors.red.withAlphaComponent(0.5)
      case .right? :
        button.setImage(UIImage(named: Img.good), for: .normal)
        backgroundColor = Constants.Colors.green.withAlphaComponent(0.5)
      default:
        button.setImage(nil, for: .normal)
      }
    }
  }
}
