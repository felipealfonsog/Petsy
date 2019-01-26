//
//  UILabelExtension.swift
//  Petsy
//
//  Created by Scott Campbell on 11/12/17.
//  Copyright © 2017 DotConfirmed. All rights reserved.
//

import UIKit

// MARK: - Fonts

enum FontType {
  case p1, p2, p3, p4
  case h1, h2, h3, h4, h5, h6
}

/**
 
 Extension is responsible for changing the label's font size depending on
 the current screen size.
 
 */
extension UILabel {
  
  // MARK: - Targets
  
  /**
   Set the label's font size for a specific screen.
   - Parameter size: Font size to set.
   */
  func set(size: FontType) {
    switch size {
      
    // Smallest paragraph
    case .p1:
      switch UIScreen.main.bounds.size.width {
      // iPhones
      case Constants.Screen.small: font = UIFont(name: font.fontName, size: 10)
      case Constants.Screen.medium: font = UIFont(name: font.fontName, size: 12)
      case Constants.Screen.large: font = UIFont(name: font.fontName, size: 12)
        
      // iPads
      case Constants.Screen.xlarge: font = UIFont(name: font.fontName, size: 14)
      case Constants.Screen.giant: font = UIFont(name: font.fontName, size: 14)
      case Constants.Screen.enormous: font = UIFont(name: font.fontName, size: 14)
      default: break
      }
      
    case .p2:
      switch UIScreen.main.bounds.size.width {
      // iPhones
      case Constants.Screen.small: font = UIFont(name: font.fontName, size: 12)
      case Constants.Screen.medium: font = UIFont(name: font.fontName, size: 14)
      case Constants.Screen.large: font = UIFont(name: font.fontName, size: 14)
        
      // iPads
      case Constants.Screen.xlarge: font = UIFont(name: font.fontName, size: 20)
      case Constants.Screen.giant: font = UIFont(name: font.fontName, size: 20)
      case Constants.Screen.enormous: font = UIFont(name: font.fontName, size: 24)
      default: break
      }
      
    case .p3:
      switch UIScreen.main.bounds.size.width {
      // iPhones
      case Constants.Screen.small: font = UIFont(name: font.fontName, size: 13)
      case Constants.Screen.medium: font = UIFont(name: font.fontName, size: 15)
      case Constants.Screen.large: font = UIFont(name: font.fontName, size: 15)
        
      // iPads
      case Constants.Screen.xlarge: font = UIFont(name: font.fontName, size: 17)
      case Constants.Screen.giant: font = UIFont(name: font.fontName, size: 17)
      case Constants.Screen.enormous: font = UIFont(name: font.fontName, size: 17)
      default: break
      }
      
    case .p4:
      switch UIScreen.main.bounds.size.width {
      // iPhones
      case Constants.Screen.small: font = UIFont(name: font.fontName, size: 14)
      case Constants.Screen.medium: font = UIFont(name: font.fontName, size: 16)
      case Constants.Screen.large: font = UIFont(name: font.fontName, size: 16)
        
      // iPads
      case Constants.Screen.xlarge: font = UIFont(name: font.fontName, size: 22)
      case Constants.Screen.giant: font = UIFont(name: font.fontName, size: 22)
      case Constants.Screen.enormous: font = UIFont(name: font.fontName, size: 22)
      default: break
      }
      
    // Largest header
    case .h1:
      switch UIScreen.main.bounds.size.width {
      // iPhones
      case Constants.Screen.small: font = UIFont(name: font.fontName, size: 26)
      case Constants.Screen.medium: font = UIFont(name: font.fontName, size: 32)
      case Constants.Screen.large: font = UIFont(name: font.fontName, size: 32)
        
      // iPads
      case Constants.Screen.xlarge: font = UIFont(name: font.fontName, size: 48)
      case Constants.Screen.giant: font = UIFont(name: font.fontName, size: 48)
      case Constants.Screen.enormous: font = UIFont(name: font.fontName, size: 58)
      default: break
      }
      
    case .h2:
      switch UIScreen.main.bounds.size.width {
      // iPhones
      case Constants.Screen.small: font = UIFont(name: font.fontName, size: 22)
      case Constants.Screen.medium: font = UIFont(name: font.fontName, size: 26)
      case Constants.Screen.large: font = UIFont(name: font.fontName, size: 26)
        
      // iPads
      case Constants.Screen.xlarge: font = UIFont(name: font.fontName, size: 36)
      case Constants.Screen.giant: font = UIFont(name: font.fontName, size: 36)
      case Constants.Screen.enormous: font = UIFont(name: font.fontName, size: 36)
      default: break
      }
      
    case .h3:
      switch UIScreen.main.bounds.size.width {
      // iPhones
      case Constants.Screen.small: font = UIFont(name: font.fontName, size: 20)
      case Constants.Screen.medium: font = UIFont(name: font.fontName, size: 24)
      case Constants.Screen.large: font = UIFont(name: font.fontName, size: 24)
        
      // iPads
      case Constants.Screen.xlarge: font = UIFont(name: font.fontName, size: 32)
      case Constants.Screen.giant: font = UIFont(name: font.fontName, size: 32)
      case Constants.Screen.enormous: font = UIFont(name: font.fontName, size: 32)
      default: break
      }
      
    case .h4:
      switch UIScreen.main.bounds.size.width {
      // iPhones
      case Constants.Screen.small: font = UIFont(name: font.fontName, size: 20)
      case Constants.Screen.medium: font = UIFont(name: font.fontName, size: 22)
      case Constants.Screen.large: font = UIFont(name: font.fontName, size: 22)
        
      // iPads
      case Constants.Screen.xlarge: font = UIFont(name: font.fontName, size: 30)
      case Constants.Screen.giant: font = UIFont(name: font.fontName, size: 30)
      case Constants.Screen.enormous: font = UIFont(name: font.fontName, size: 30)
      default: break
      }
      
    case .h5:
      switch UIScreen.main.bounds.size.width {
      // iPhones
      case Constants.Screen.small: font = UIFont(name: font.fontName, size: 18)
      case Constants.Screen.medium: font = UIFont(name: font.fontName, size: 20)
      case Constants.Screen.large: font = UIFont(name: font.fontName, size: 20)
        
      // iPads
      case Constants.Screen.xlarge: font = UIFont(name: font.fontName, size: 22)
      case Constants.Screen.giant: font = UIFont(name: font.fontName, size: 22)
      case Constants.Screen.enormous: font = UIFont(name: font.fontName, size: 22)
      default: break
      }
      
    case .h6:
      switch UIScreen.main.bounds.size.width {
      // iPhones
      case Constants.Screen.small: font = UIFont(name: font.fontName, size: 16)
      case Constants.Screen.medium: font = UIFont(name: font.fontName, size: 18)
      case Constants.Screen.large: font = UIFont(name: font.fontName, size: 18)
        
      // iPads
      case Constants.Screen.xlarge: font = UIFont(name: font.fontName, size: 22)
      case Constants.Screen.giant: font = UIFont(name: font.fontName, size: 22)
      case Constants.Screen.enormous: font = UIFont(name: font.fontName, size: 22)
      default: break
      }
    }
  }
}
