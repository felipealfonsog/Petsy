//
//  UserSerializer.swift
//  Petsy
//
//  Created by Scott Campbell on 11/10/17.
//  Copyright © 2017 DotConfirmed. All rights reserved.
//

import Foundation

class UserSerializer {
  
  // MARK: - Serialization
  
  /**
   Serialize a user to be written to Firebase.
   - Parameter uid: User's UID.
   - Parameter email: User's email.
   - Returns: Serialized payload.
   */
  func serialize(email: String) -> [String: Any] {
    return [
      "email": email
    ]
  }
}
