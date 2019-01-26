//
//  PetService.swift
//  Petsy
//
//  Created by Scott Campbell on 11/13/17.
//  Copyright © 2017 DotConfirmed. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

class PetService {
  
  // MARK: - Properties
  weak var delegate: PetServiceDelegate!
  fileprivate let deserializer = PetDeserializer()
  fileprivate let errorDispatch = ErrorDispatch()
  
  // MARK: - Fetch
  
  /**
   Fetch an array of pets using the specified IDs.
   - Parameter ids: List of IDs to use to fetch Pets.
   */
  func fetchPets(for ids: [String]) {
    var petViewModels = [PetViewModel]()
    var iterator = 0
    
    for id in ids {
      fetchPet(id: id)
        .then { petViewModel -> Void in
          iterator += 1
          petViewModels.append(petViewModel)
          self.checkIfDone(petViewModels: petViewModels, iterator: iterator, count: ids.count)
        }.catch { _ -> Void in
          iterator += 1
          self.checkIfDone(petViewModels: petViewModels, iterator: iterator, count: ids.count)
      }
    }
  }
  
  /**
   Check if we have iterated through all the pets.
   - Parameter petViewModels: PetViewModels which have been deserialized.
   - Parameter iterator: Current iteration count.
   - Parameter count: Total number of IDs to iterate through.
   */
  fileprivate func checkIfDone(petViewModels: [PetViewModel], iterator: Int, count: Int) {
    if iterator == count {
      self.delegate?.service(didSucceedWith: petViewModels)
    }
  }
  
  /**
   Fetch the speficied PetViewModel.
   - Parameter id: ID of the pet to fetch.
   - Returns: Deserialized PetViewModel, if it was fetched.
   */
  fileprivate func fetchPet(id: String) -> Promise<PetViewModel> {
    return Promise { (fulfill, reject) in
      
      let url = "\(Constants.PetFinderAPI.url)pet.get?format=json&key=\(Constants.PetFinderAPI.key)&id=\(id)"
      
      Alamofire.request(url).responseString { response in
        if let json = response.result.value {
          if let petViewModel = self.deserializer.deserializeSinglePet(json: json) {
            fulfill(petViewModel)
          } else {
            reject(self.errorDispatch.getError(for: .catchAll))
          }
        }
      }
    }
  }
}
