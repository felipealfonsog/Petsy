//
//  SwipeService.swift
//  Petsy
//
//  Created by Scott Campbell on 11/10/17.
//  Copyright © 2017 DotConfirmed. All rights reserved.
//

import Alamofire
import Foundation

class SwipeService {
  
  // MARK: - Private properties
  fileprivate var userService = UserService()
  fileprivate var locationService = LocationService()
  fileprivate let errorDispatch = ErrorDispatch()
  fileprivate let deserializer = PetDeserializer()
  fileprivate let reachability = ReachabilityCheck()
  
  fileprivate var location: String?
  fileprivate var userViewModel: UserViewModel?
  fileprivate var lastOffset: Int?
  
  // MARK: - Public properties
  weak var delegate: SwipeServiceDelegate!
  
  // MARK: - Query
  
  /**
   Configure the services and initialize the primary query.
   This should be called when the SwipeViewController is first loaded.
   */
  func initializeQuery() {
    guard reachability.connectedToNetwork() else { return }
    
    ActivityIndicator.shared.startAnimating()
    userService.delegate = self
    locationService.delegate = self
    locationService.requestLocation()
  }
  
  /**
   Called if the service should perform another query to fetch an additional 100 records.
   */
  func repeatQuery() {
    guard reachability.connectedToNetwork() else { return }
        
    if let location = location, let lastOffset = lastOffset {
      let url = "\(Constants.PetFinderAPI.url)pet.find?format=json&key=\(Constants.PetFinderAPI.key)&output=full&count=100&location=\(location)&offset=\(lastOffset)"
      executeQuery(withURL: url)
    } else {
      delegate?.service(didFailWith: errorDispatch.getError(for: .catchAll))
    }
  }
  
  /**
   Configure the query parameters for the PetFinder API call.
   */
  fileprivate func configureQuery() {
    guard let location = location else { return }
    let url = "\(Constants.PetFinderAPI.url)pet.find?format=json&key=\(Constants.PetFinderAPI.key)&output=full&count=100&location=\(location)"
    executeQuery(withURL: url)
  }
  
  /**
   Execute the query and retrieve a response from the PetFinder API.
   - Parameter url: Configured API URL.
   */
  fileprivate func executeQuery(withURL url: String) {
    Alamofire.request(url).responseString { response in
      if let json = response.result.value {
        let (petViewModels, lastOffset) = self.deserializer.deserialize(json: json)
        self.lastOffset = lastOffset // Persist the lastOffset used for the PetFinder API call.
        self.filter(petViewModels: petViewModels)
      } else {
        self.delegate?.service(didFailWith: self.errorDispatch.getError(for: .catchAll))
      }
    }
  }
  
  /**
   Filter out the pets that this user has already saved or rejected.
   This method is the final method in the chain; it calls the delegate with the
   final array of PetViewModels once they have been filtered.
   - Parameter petViewModels: PetViewModels that have been deserialized.
   */
  fileprivate func filter(petViewModels: [PetViewModel]) {
    guard let userViewModel = userViewModel else { return }
    
    let goodIDs = Array(Set(petViewModels.map { $0.getID() }).subtracting(userViewModel.getIDsAsSet()))
    delegate?.service(didSucceedWith: petViewModels.filter { goodIDs.contains($0.getID()) })
  }
  
  // MARK: - UserService
  
  /**
   Get the current user.
   */
  fileprivate func fetchUser() {
    if let uid = userService.getUID() {
      userService.getUser(with: uid)
    } else {
      delegate?.service(didFailWith: self.errorDispatch.getError(for: .catchAll))
    }
  }
  
  /**
   Log the user out.
   */
  func logOut() {
    userService.logOut()
  }
  
  /**
   Saved the specified pet.
   - Parameter petID: ID of the pet to save.
   */
  func save(petID: String) {
    guard let userViewModel = userViewModel else { return }
    userService.save(petID: petID, for: userViewModel.getUID())
  }
  
  /**
   Reject the specified pet.
   - Parameter petID: ID of the pet to reject.
   */
  func reject(petID: String) {
    guard let userViewModel = userViewModel else { return }
    userService.reject(petID: petID, for: userViewModel.getUID())
  }
}

// MARK: - LocationServiceDelegate protocol
extension SwipeService: LocationServiceDelegate {
  
  func userDidDenyAuthorization() {
    delegate?.userNeedsToAllowLocation()
  }
  
  func service(didSucceedWith location: String) {
    self.location = location
    fetchUser()
  }
  
  func locationService(didFailWith error: Error) {
    delegate?.service(didFailWith: error)
  }
}

// MARK: - UserServiceDelegate protocol
extension SwipeService: UserServiceDelegate {
  
  func serviceLoggedOut() {
    delegate?.serviceLoggedOut()
  }
  
  func service(didReceive userViewModel: UserViewModel) {
    self.userViewModel = userViewModel
    configureQuery()
  }
  
  func service(didFailWith error: Error) {
    delegate?.service(didFailWith: error)
  }
}
