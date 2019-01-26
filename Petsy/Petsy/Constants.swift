//
//  Constants.swift
//  Petsy
//
//  Created by Scott Campbell on 11/10/17.
//  Copyright © 2017 DotConfirmed. All rights reserved.
//

import UIKit

public struct Constants  {
  
  // MARK: - Database references
  
  struct Database {
    
    #if DEBUG
    // Firebase development environment
    static let dbRef = "https://petsy-3b3fc.firebaseio.com"
    #else
    // Firebase production environment
    static let dbRef = "https://petsy-ba2c7.firebaseio.com"
    #endif
    
    static let users = "\(dbRef)/users"
  }
  
  // MARK: - PetFinder
  
  struct PetFinderAPI {
    static let url = "http://api.petfinder.com/"
    static let key = "c6d4f0cc7fe3a18a85ea4b9e49ee3f54"
    static let secret = "5c05e16820f5d3cf66038320e3e59cec"
  }
  
  // MARK: - Screen sizes
  
  struct Screen {
    // iPhone 2G, 3G, 3GS, 4, 4s, 5, 5s, 5SE
    static let small: CGFloat = 320
    
    // iPhone 6, 6s, 7
    static let medium: CGFloat = 375
    
    // iPhone 6+, 6s+, 7+
    static let large: CGFloat = 414
    
    // iPad Mini 2, Mini 3, Mini 4
    // iPad 3, 4
    // iPad Air, Air 2
    // iPad Pro 9.7"
    static let xlarge: CGFloat = 768
    
    // iPad Pro 10.5"
    static let giant: CGFloat = 834
    
    // iPad Pro 12.9"
    static let enormous: CGFloat = 1024
  }
  
  // MARK: - Colors
  
  struct Colors {
    static let primary = UIColor(red: 18.0/255.0, green: 165.0/255.0, blue: 234.0/255.0, alpha: 1.0)
    static let red = UIColor(red: 254/255.0, green: 48.0/255.0, blue: 120.0/255.0, alpha: 1.0)
    static let green = UIColor(red: 29/255.0, green: 226/255.0, blue: 157/255.0, alpha: 1.0)
    static let darkText = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.7)
    static let lightText = UIColor(red: 182.0/255.0, green: 182.0/255.0, blue: 182.0/255.0, alpha: 1.0)
  }
}
