//
//  UserViewModel.swift
//  Petsy
//
//  Created by Scott Campbell on 11/10/17.
//  Copyright © 2017 DotConfirmed. All rights reserved.
//

import UIKit

class UserViewModel {
  
  // MARK: - Private properties
  fileprivate var user: User
  
  // MARK: - Lifecycle
  
  init(user: User) {
    self.user = user
  }
  
  // MARK: - Accessors
  
  /**
   - Returns: The UID for this user.
   */
  func getUID() -> String {
    return user.uid
  }
  
  /**
   - Returns: The User's email.
   */
  func getEmail() -> String {
    return user.email
  }
  
  /**
   - Returns: IDs of the Pets this user has saved.
   */
  func getSaved() -> [String] {
    return user.saved
  }
  
  /**
   - Returns: IDs of the Pets this user has rejected.
   */
  func getRejected() -> [String] {
    return user.rejected
  }
  
  /**
   - Returns: Set of all IDs the user has saved or rejected.
   */
  func getIDsAsSet() -> Set<String> {
    return Set(user.saved).union(Set(user.rejected))
  }
}
