//
//  PetServiceDelegate.swift
//  Petsy
//
//  Created by Scott Campbell on 11/13/17.
//  Copyright © 2017 DotConfirmed. All rights reserved.
//

import Foundation

protocol PetServiceDelegate: class {
  
  /**
   Required: Called when the service deserializes the next batch of PetViewModels.
   - Parameter petViewModels: Array of deserialized PetViewModels.
   */
  func service(didSucceedWith petViewModels: [PetViewModel])
  
  /**
   Required: Called if the service failed to complete a request.
   - Parameter error: Encountered error.
   */
  func petService(didFailWith error: Error)
}
