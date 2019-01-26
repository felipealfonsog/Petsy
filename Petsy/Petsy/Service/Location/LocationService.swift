//
//  LocationService.swift
//  Petsy
//
//  Created by Scott Campbell on 11/10/17.
//  Copyright © 2017 DotConfirmed. All rights reserved.
//

import Foundation
import PromiseKit
import CoreLocation

class LocationService {
  
  // MARK: - Private properties
  fileprivate let errorDispatch = ErrorDispatch()
  
  // MARK: - Public properties
  weak var delegate: LocationServiceDelegate!

  // MARK: - Checking permissions
  
  /**
   Request authorization from the current member for the
   */
  func requestLocation() {
    CLLocationManager.requestAuthorization(type: .whenInUse)
      .then { status -> Void in
        
        switch status {
        case .authorizedWhenInUse:
          self.getLocation()
        case .denied, .restricted:
          self.delegate?.userDidDenyAuthorization()
        default:
          self.delegate?.locationService(didFailWith: self.errorDispatch.getError(for: .locationNotAvailable))
        }
      }.catch { error -> Void in
        self.delegate?.locationService(didFailWith: error)
    }
  }
  
  // MARK: - Location
  
  /**
   Get the user's current location.
   */
  func getLocation()  {
    CLLocationManager.promise()
      .then { location in
        return CLGeocoder().reverseGeocode(location: location)
      }.then { placemark -> Void in
        if
          let dictionary = placemark.addressDictionary,
          let city = dictionary["City"],
          let state = dictionary["State"] {
          let address = "\(city),\(state)"
          self.delegate?.service(didSucceedWith: address.replacingOccurrences(of: " ", with: ""))
        } else {
          self.delegate?.locationService(didFailWith: self.errorDispatch.getError(for: .locationNotAvailable))
        }
      }.catch { error in
        self.delegate?.locationService(didFailWith: self.errorDispatch.getError(for: .locationNotAvailable))
    }
  }
}
