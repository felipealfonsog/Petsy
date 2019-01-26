//
//  LocationServiceDelegate.swift
//  Petsy
//
//  Created by Scott Campbell on 11/10/17.
//  Copyright © 2017 DotConfirmed. All rights reserved.
//

import Foundation

protocol LocationServiceDelegate: class {
  
  /**
   Required: Called if member denied access to core location.
   */
  func userDidDenyAuthorization()
  
  /**
   Required: Called if location service fetched coordinate.
   - Parameter location: Fetched location string.
   */
  func service(didSucceedWith location: String)
  
  /**
   Required: Called if the service failed to complete a request.
   - Parameter error: Encountered error.
   */
  func locationService(didFailWith error: Error)
}
