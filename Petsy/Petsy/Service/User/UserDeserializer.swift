//
//  UserDeserializer.swift
//  Petsy
//
//  Created by Scott Campbell on 11/10/17.
//  Copyright © 2017 DotConfirmed. All rights reserved.
//

import Firebase
import Foundation

class UserDeserializer {
  
  // MARK: - Deserialization
  
  /**
   Deserialize a DataSnapshot into a UserViewModel.
   - Parameter snapshot: Firebase DataSnapshot.
   - Returns: Deserialized UserViewModel.
   */
  func deserialize(snapshot: DataSnapshot) -> UserViewModel? {
    guard
      let dictionary = snapshot.value as? [String: Any],
      let email = dictionary["email"] as? String
      else { return nil }
    
    var saved = [String]()
    
    if let ids = dictionary["saved"] as? [String: Bool] {
      for (id, _) in ids {
        saved.append(id)
      }
    }
    
    var rejected = [String]()
    
    if let ids = dictionary["rejected"] as? [String: Bool] {
      for (id, _) in ids {
        rejected.append(id)
      }
    }
    
    let user = User(uid: snapshot.key,
                    email: email,
                    saved: saved,
                    rejected: rejected)
    
    return UserViewModel(user: user)
  }
}
