//
//  PetDeserializer.swift
//  Petsy
//
//  Created by Scott Campbell on 11/10/17.
//  Copyright © 2017 DotConfirmed. All rights reserved.
//

import Firebase
import Foundation

class PetDeserializer {
  
  // MARK: - Types
  fileprivate struct Key {
    static let lastOffset = "lastOffset"
    static let universal = "$t"
    static let petfinder = "petfinder"
    static let pets = "pets"
    static let pet = "pet"
  }
  
  fileprivate struct Field {
    static let name = "name"
    static let breeds = "breeds"
    static let breed = "breed"
    static let description = "description"
    static let age = "age"
    static let size = "size"
    static let id = "id"
    static let contact = "contact"
    static let address = "address1"
    static let city = "city"
    static let email = "email"
    static let phone = "phone"
    static let state = "state"
    static let animal = "animal"
    static let sex = "sex"
    static let shelter = "name"
    static let media = "media"
    static let photos = "photos"
    static let photo = "photo"
    static let photoSize = "@size"
    static let large = "x"
  }
  
  // MARK: - Deserialization
  
  /**
   Deserialize a JSON blob into a PetViewModel.
   - Parameter json: JSON response from PetFinder.
   - Returns: (Deserialized PetViewModels, lastOffset).
   */
  func deserialize(json: String) -> ([PetViewModel], Int) {
    guard
      let dictionary = convertToDictionary(json: json),
      let petfinder = dictionary[Key.petfinder] as? [String: Any],
      let offsetDictionary = petfinder[Key.lastOffset] as? [String: Any],
      let petDictionary = petfinder[Key.pets] as? [String: Any]
      else { return ([], 0) }
    
    var lastOffset = 0
    
    if let offset = getLastOffset(from: offsetDictionary) {
      lastOffset = offset
    }
    
    return (getPets(from: petDictionary), lastOffset)
  }
  
  /**
   Deserialize a JSON blob into a PetViewModel.
   - Parameter json: JSON response from PetFinder.
   - Returns: Deserialized PetViewModels.
   */
  func deserializeSinglePet(json: String) -> PetViewModel? {
    guard
      let dictionary = convertToDictionary(json: json),
      let petfinder = dictionary[Key.petfinder] as? [String: Any],
      let petDictionary = petfinder[Key.pet] as? [String: Any]
      else { return nil }
    
    return getPet(from: petDictionary)
  }
  
  /**
   Get the last offset used to query the PetFinder API.
   - Parameter dictionary: Dictionary containing offset information.
   - Returns: The last offset, if it was deserialized.
   */
  fileprivate func getLastOffset(from dictionary: [String: Any]) -> Int? {
    guard
      let offsetString = dictionary[Key.universal] as? String,
      let offset = Int(offsetString)
      else { return nil }
    
    return offset
  }
  
  /**
   Deserialize the content of the 'pets' node.
   - Parameter dictionary: The contents of the 'pets' node.
   - Returns: Array of deserialized PetViewModels.
   */
  fileprivate func getPets(from dictionary: [String: Any]) -> [PetViewModel] {
    guard let pets = dictionary[Key.pet] as? [Any] else { return [] }
    var petViewModels = [PetViewModel]()
    
    for pet in pets {
      if
        let data = pet as? [String: Any],
        let petViewModel = getPet(from: data) {
        petViewModels.append(petViewModel)
      }
    }
    
    return petViewModels
  }
  
  /**
   Deserialize a PetViewModel from a 'pet' node.
   - Parameter dictionary: The contents of a 'pet' node.
   - Returns: PetViewModel, if it was successfully deserialized.
   */
  fileprivate func getPet(from dictionary: [String: Any]) -> PetViewModel? {
    guard
      let nameDict = dictionary[Field.name] as? [String: Any],
      let name = nameDict[Key.universal] as? String,
      let idDict = dictionary[Field.id] as? [String: Any],
      let id = idDict[Key.universal] as? String,
      let animalDict = dictionary[Field.animal] as? [String: Any],
      let animal = animalDict[Key.universal] as? String,
      let sexDict = dictionary[Field.sex] as? [String: Any],
      let sex = sexDict[Key.universal] as? String,
      let sizeDict = dictionary[Field.size] as? [String: Any],
      let size = sizeDict[Key.universal] as? String,
      let breeds = dictionary[Field.breeds] as? [String: Any],
      let breedDict = breeds[Field.breed] as? [String: Any],
      let breed = breedDict[Key.universal] as? String,
      let ageDict = dictionary[Field.age] as? [String: Any],
      let age = ageDict[Key.universal] as? String,
      let contact = dictionary[Field.contact] as? [String: Any],
      let cityDict = contact[Field.city] as? [String: Any],
      let city = cityDict[Key.universal] as? String,
      let stateDict = contact[Field.state] as? [String: Any],
      let state = stateDict[Key.universal] as? String,
      let addressDict = contact[Field.address] as? [String: Any],
      let address = addressDict[Key.universal] as? String,
      let emailDict = contact[Field.email] as? [String: Any],
      let email = emailDict[Key.universal] as? String,
      let phoneDict = contact[Field.phone] as? [String: Any],
      let phone = phoneDict[Key.universal] as? String,
      let mediaDict = dictionary[Field.media] as? [String: Any],
      let photos = mediaDict[Field.photos] as? [String: Any],
      let photo = photos[Field.photo] as? [Any]
      else { return nil }
    
    var imageURLs = [String]()
    
    photo.forEach {
      if let dict = $0 as? [String: Any] {
        if
          let url = dict[Key.universal] as? String,
          let size = dict[Field.photoSize] as? String,
          size == Field.large {
          imageURLs.append(url)
        }
      }
    }
    
    var descript: String? = nil
    
    if let descriptDict = dictionary[Field.description] as? [String: Any] {
      descript = descriptDict[Key.universal] as? String
    }
    
    return PetViewModel(pet: Pet(id: id,
                                 name: name,
                                 animal: animal,
                                 breed: breed,
                                 sex: sex,
                                 age: age,
                                 size: size,
                                 descript: descript,
                                 address: address,
                                 city: city,
                                 state: state,
                                 email: email,
                                 phone: phone,
                                 imageURLs: imageURLs))
  }
  
  // MARK: - Helpers
  
  /**
   Convert JSON string to a dictionary.
   - Parameter json: String representation of a JSON object.
   - Returns: Converted dictionary.
   */
  fileprivate func convertToDictionary(json: String) -> [String: Any]? {
    if let data = json.data(using: .utf8) {
      do {
        return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
      } catch {
        print(error.localizedDescription)
      }
    }
    
    return nil
  }
}
