//
//  User.swift
//  Petsy
//
//  Created by Scott Campbell on 11/10/17.
//  Copyright © 2017 DotConfirmed. All rights reserved.
//

import Foundation

class User {
  
  // MARK: - Properties
  var uid: String
  var email: String
  var saved: [String]
  var rejected: [String]
  
  // MARK: - Lifecycle
  
  init(uid: String,
       email: String,
       saved: [String],
       rejected: [String]) {
    self.uid = uid
    self.email = email
    self.saved = saved
    self.rejected = rejected
  }
}
