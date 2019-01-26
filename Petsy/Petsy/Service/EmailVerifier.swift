//
//  EmailVerifier.swift
//  Petsy
//
//  Created by Scott Campbell on 11/10/17.
//  Copyright © 2017 DotConfirmed. All rights reserved.
//

import Foundation

class EmailVerifier {
  
  // MARK: - Validation
  
  /**
   Check to see if the provided email is properly formatted.
   - Parameter email: Email to check.
   - Returns: True if the email is properly formatted.
   */
  func properlyFormatted(_ email: String) -> Bool {
    let emailPrefix = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
    let emailServer = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
    let emailRegEx = emailPrefix + "@" + emailServer + "[A-Za-z]{2,6}"
    
    return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
  }
}
