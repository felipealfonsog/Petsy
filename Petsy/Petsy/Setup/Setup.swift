//
//  Setup.swift
//  Petsy
//
//  Created by Scott Campbell on 11/10/17.
//  Copyright © 2017 DotConfirmed. All rights reserved.
//

import Firebase
import Foundation

class Setup {
 
  // MARK: - Reference
  struct Resources {
    static let Dev = "GoogleService-Info-Dev"
    static let Prod = "GoogleService-Info"
    static let Plist = "plist"
  }
  
  struct Console_Message {
    static let Dev = "[RUNNING] - Development mode\n[plist]: GoogleService-Info-Dev\n[target]: https://petsy-3b3fc.firebaseio.com\n"
    static let Prod = "[RUNNING] - Production mode\n[plist]: GoogleService-Info\n[target]: https://\n"
    static let Fatal = "[ERROR] - Invalid Firebase configuration file."
  }
  
  // MARK: - Firebase
  
  /**
   Use Firebase library to configure APIs.
   */
  func configureFirebase() {
    
    // Use Macros to determine the app environment (development or production) for Firebase config.
    #if DEBUG
      print(Console_Message.Dev)
      let firebaseConfig = Bundle.main.path(forResource: Resources.Dev, ofType: Resources.Plist)
    #else
      print(Console_Message.Prod)
      let firebaseConfig = Bundle.main.path(forResource: Resources.Prod, ofType: Resources.Plist)
    #endif
    
    guard let options = FirebaseOptions(contentsOfFile: firebaseConfig!) else {
      fatalError(Console_Message.Fatal)
    }
    
    // Use Firebase library to configure APIs.
    FirebaseApp.configure(options: options)
  }
}
