//
//  Pet.swift
//  Petsy
//
//  Created by Scott Campbell on 11/10/17.
//  Copyright © 2017 DotConfirmed. All rights reserved.
//

import Foundation

class Pet {
  
  // MARK: - Properties
  var id: String
  var name: String
  var animal: String
  var breed: String
  var sex: String
  var age: String
  var size: String
  var descript: String?
  var address: String
  var city: String
  var state: String
  var email: String
  var phone: String
  var imageURLs: [String]
  
  // MARK: - Lifecycle
  
  init(id: String,
       name: String,
       animal: String,
       breed: String,
       sex: String,
       age: String,
       size: String,
       descript: String?,
       address: String,
       city: String,
       state: String,
       email: String,
       phone: String,
       imageURLs: [String]) {
    self.id = id
    self.name = name
    self.animal = animal
    self.breed = breed
    self.sex = sex
    self.age = age
    self.size = size
    self.descript = descript
    self.address = address
    self.city = city
    self.state = state
    self.email = email
    self.phone = phone
    self.imageURLs = imageURLs
  }
}
