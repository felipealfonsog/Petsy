//
//  UserServiceDelegate.swift
//  Petsy
//
//  Created by Scott Campbell on 11/10/17.
//  Copyright © 2017 DotConfirmed. All rights reserved.
//

import Foundation

protocol UserServiceDelegate: class {
  
  /**
   Optional: Called when the service successfully logs a user in.
   */
  func serviceLoggedIn()
  
  /**
   Optional: Called when the service successfully logs a user out.
   */
  func serviceLoggedOut()
  
  /**
   Optional: Called when the service successfully emails a password reset.
   - Parameter error: Message sent back to the controller.
   */
  func serviceResetPassword(error: Error)
  
  /**
   Optional: Called when the service successfully deletes a pet.
   */
  func serviceDidDeletePet()
  
  /**
   Optional: Called when the service successfully fetches a user.
   - Parameter userViewModel: Deserialized UserViewModel.
   */
  func service(didReceive userViewModel: UserViewModel)
  
  /**
   Required: Called if the service failed to complete a request.
   - Parameter error: Encountered error.
   */
  func service(didFailWith error: Error)
}

// MARK: - UserServiceDelegate protocol
extension UserServiceDelegate {
  
  // MARK: - Overrides to provide optional conformance.
  func serviceLoggedIn() {}
  func serviceLoggedOut() {}
  func serviceResetPassword(error: Error) {}
  func serviceDidDeletePet() {}
  func service(didReceive userViewModel: UserViewModel) {}
}
