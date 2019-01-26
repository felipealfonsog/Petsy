//
//  PetViewModel.swift
//  Petsy
//
//  Created by Scott Campbell on 11/10/17.
//  Copyright © 2017 DotConfirmed. All rights reserved.
//

import UIKit

class PetViewModel {
  
  // MARK: - Private properties
  fileprivate var pet: Pet
  
  // MARK: - Lifecycle
  
  init(pet: Pet) {
    self.pet = pet
  }
  
  // MARK: - Pet Fields
  
  /**
   - Returns: Pet's PetFinder ID.
   */
  func getID() -> String {
    return pet.id
  }
  
  /**
   - Returns: Pet's name.
   */
  func getName() -> String {
    return pet.name
  }
  
  /**
   - Returns: Pet's animal type.
   */
  func getAnimalType() -> String {
    return pet.animal
  }
  
  /**
   - Returns: Pet's breed.
   */
  func getBreed() -> String {
    return pet.breed
  }
  
  /**
   - Returns: Pet's sex, formatted.
   */
  func getSex() -> String {
    switch pet.sex {
    case "M": return "Male"
    case "F": return "Female"
    default: return pet.sex
    }
  }
  
  /**
   - Returns: Pet's age.
   */
  func getAge() -> String {
    return pet.age
  }
  
  /**
   - Returns: Pet's size, formatted.
   */
  func getSize() -> String {
    switch pet.size {
    case "S": return "Small"
    case "M": return "Medium"
    case "L": return "Large"
    case "XL": return "Extra Large"
    default: return pet.size
    }
  }
  
  /**
   - Returns: Pet's description, if it exists.
   */
  func getDescription() -> String? {
    return pet.descript
  }
  
  /**
   - Returns: Pet's info, formatted.
   */
  func getInfo() -> String {
    return "\(getSize()) | \(pet.age) | \(getSex())"
  }
  
  // MARK: - Address
  
  /**
   - Returns: Shelter's location, formatted.
   */
  func getAddress() -> String {
    return "\(pet.address), \(pet.city), \(pet.state)"
  }
  
  // MARK: - Email
  
  /**
   - Returns: Shelter's email.
   */
  func getEmail() -> String {
    return pet.email
  }
  
  /**
   - Returns: URL for sending an in-app email.
   */
  func getEmailURL() -> URL? {
    return URL(string: "mailto:\(pet.email)")
  }
  
  // MARK: - Phone number
  
  /**
   - Returns: Shelter's phone number, formatted for display.
   */
  func getPhone() -> String {
    return pet.phone
  }
  
  /**
   - Returns: URL for making an in-app call.
   */
  func getPhoneURL() -> URL? {
    let phone = pet.phone.replacingOccurrences(of: "(", with: "")
    let a = phone.replacingOccurrences(of: ")", with: "")
    let b = a.replacingOccurrences(of: " ", with: "")
    let c = b.replacingOccurrences(of: "-", with: "")
    return URL(string: "telprompt://\(c)")
  }
  
  // MARK: - Image URLs
  
  /**
   - Returns: The URL for the cover image.
   */
  func getCoverImageURL() -> URL? {
    guard let coverImageURL = pet.imageURLs.first else { return nil }
    return URL(string: coverImageURL)
  }
  
  /**
   - Returns: The URLs for the images.
   */
  func getImageURLs() -> [URL]? {
    guard !pet.imageURLs.isEmpty else { return nil }
    
    var imageURLs = [URL]()
    
    pet.imageURLs.forEach {
      if let url = URL(string: $0) {
        imageURLs.append(url)
      }
    }
    
    guard !imageURLs.isEmpty else { return nil }
    return imageURLs
  }
}
