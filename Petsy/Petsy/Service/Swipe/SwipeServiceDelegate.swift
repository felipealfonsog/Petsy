//
//  SwipeServiceDelegate.swift
//  Petsy
//
//  Created by Scott Campbell on 11/10/17.
//  Copyright © 2017 DotConfirmed. All rights reserved.
//

import Foundation

protocol SwipeServiceDelegate: class {
  
  /**
   Required: Called when the service successfully logs a user out.
   */
  func serviceLoggedOut()
  
  /**
   Required: Called if the service was not allowed to fetch the user's location.
   */
  func userNeedsToAllowLocation()
  
  /**
   Required: Called when the service deserializes the next batch of PetViewModels.
   - Parameter petViewModels: Array of deserialized PetViewModels.
   */
  func service(didSucceedWith petViewModels: [PetViewModel])
  
  /**
   Required: Called if the service failed to complete a request.
   - Parameter error: Encountered error.
   */
  func service(didFailWith error: Error)
}
