//
//  UIImage.swift
//  Petsy
//
//  Created by Scott Campbell on 11/12/17.
//  Copyright © 2017 DotConfirmed. All rights reserved.
//

import UIKit

// MARK: - UIImage extension
public extension UIImage {
  
  // MARK: - Constructors
  
  /**
   Adding a translucent white background image to navigation bar.
   - Parameter color: Color for the background view.
   - Parameter size: Pixel size.
   */
  public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
    let rect = CGRect(origin: .zero, size: size)
    
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
    color.setFill()
    UIRectFill(rect)
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    guard let cgImage = image?.cgImage else { return nil }
    self.init(cgImage: cgImage)
  }
}

