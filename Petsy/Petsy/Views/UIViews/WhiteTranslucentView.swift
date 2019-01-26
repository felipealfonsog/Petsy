//
//  WhiteTranslucentView.swift
//  Petsy
//
//  Created by Scott Campbell on 11/12/17.
//  Copyright © 2017 DotConfirmed. All rights reserved.
//

import UIKit

class WhiteTranslucentView: UIView {
  
  // MARK: - Lifecycle
  
  override func willMove(toWindow newWindow: UIWindow?) {
    super.willMove(toWindow: newWindow)
    self.backgroundColor = UIColor(patternImage: UIImage(color: UIColor.white.withAlphaComponent(0.95))!)
  }
}
