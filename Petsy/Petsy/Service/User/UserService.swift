//
//  UserService.swift
//  Petsy
//
//  Created by Scott Campbell on 11/10/17.
//  Copyright © 2017 DotConfirmed. All rights reserved.
//

import PromiseKit
import Firebase
import UIKit

class UserService {
  
  // MARK: - Private properties
  fileprivate let serializer = UserSerializer()
  fileprivate let deserializer = UserDeserializer()
  fileprivate let errorDispatch = ErrorDispatch()
  fileprivate let reachability = ReachabilityCheck()
  
  // MARK: - Public properties
  weak var delegate: UserServiceDelegate!
  
  // MARK: - Types
  fileprivate struct Node {
    static let saved = "saved"
    static let rejected = "rejected"
  }
  
  // MARK: - Create
  
  /**
   Check to see if a new user should be created in Auth.
   - Parameter email: Email entered by user.
   - Parameter password: Password entered by user.
   */
  func checkUser(email: String, password: String) {
    ActivityIndicator.shared.startAnimating()
    
    if reachability.connectedToNetwork() {
      Auth.auth().fetchProviders(forEmail: email) { (providers, error) in
        if providers != nil {
          ActivityIndicator.shared.stopAnimating()
          self.delegate?.service(didFailWith: self.errorDispatch.getError(for: .accountExists))
        } else if error != nil {
          ActivityIndicator.shared.stopAnimating()
          self.delegate?.service(didFailWith: self.errorDispatch.getError(for: .userSerialization))
        } else {
          self.createUser(email: email, password: password)
        }
      }
    } else {
      self.delegate?.service(didFailWith: self.errorDispatch.getError(for: .noNetworkConnection))
    }
  }
  
  /**
   Actually create a new user in Auth.
   - Parameter email: Email entered by user.
   - Parameter password: Password entered by user.
   */
  fileprivate func createUser(email: String, password: String) {
    Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
      if error != nil {
        self.delegate?.service(didFailWith: self.errorDispatch.getError(for: .userSerialization))
        ActivityIndicator.shared.stopAnimating()
      } else if let user = user {
        self.setUser(uid: user.uid, email: email)
      }
    }
  }
  
  /**
   Set a new user in Firebase.
   - Parameter uid: UID of the new user.
   - Parameter email: Email address of the new user.
   */
  fileprivate func setUser(uid: String, email: String) {
    self.writeUser(uid: uid, payload: self.serializer.serialize(email: email))
      .then { _ -> Void in
        self.delegate?.serviceLoggedIn()
      }.catch { _ -> Void in
        ActivityIndicator.shared.stopAnimating()
        self.delegate?.service(didFailWith: self.errorDispatch.getError(for: .userSerialization))
    }
  }
  
  /**
   Write the payload to the database.
   - Parameter uid: UID of the new user.
   - Parameter payload: Serialized payload to be written to the database.
   - Returns: Promise<success> if the user was written successfully.
   */
  fileprivate func writeUser(uid: String, payload: [String: Any]) -> Promise<Bool> {
    return Promise { (fulfill, reject) in
      
      let ref = Database.database().reference(fromURL: Constants.Database.users)
      
      ref.child(uid).setValue(payload) { (error, reference) in
        if let error = error {
          reject(error)
        } else {
          fulfill(true)
        }
      }
    }
  }
  
  // MARK: - Retrieve
  
  /**
   Get the UID of the user currently logged in to Auth.
   - Returns: UID, if the user is logged in.
   */
  func getUID() -> String? {
    return Auth.auth().currentUser?.uid
  }
  
  /**
   Calls the delegate with either:
   1. The deserialized UserViewModel.
   2. The error that was encountered.
   - Parameter uid: UID of the user to fetch.
   */
  func getUser(with uid: String) {    
    userRequest(uid: uid)
      .then { snapshot -> Void in
        if let userViewModel = self.deserializer.deserialize(snapshot: snapshot) {
          self.delegate?.service(didReceive: userViewModel)
        } else {
          self.delegate?.service(didFailWith: self.errorDispatch.getError(for: .userDeserialization))
        }
      }.catch { error -> Void in
        self.delegate?.service(didFailWith: error)
    }
  }
  
  /**
   Perform the actual Firebase request.
   - Parameter uid: UID of the user to fetch.
   - Returns: Promise<UserViewModel> if it was deserialized.
   */
  fileprivate func userRequest(uid: String) -> Promise<DataSnapshot> {
    return Promise { (fulfill, reject) in
      
      let ref = Database.database().reference(fromURL: Constants.Database.users)
      
      ref.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
        fulfill(snapshot)
      }) { error -> Void in
        reject(self.errorDispatch.getError(for: .userDeserialization))
      }
    }
  }
  
  // MARK: - Update
  
  /**
   Saved the specified pet.
   - Parameter petID: ID of the pet to save.
   - Parameter uid: UID of the user to save the pet for.
   */
  func save(petID: String, for uid: String) {
    let ref = Database.database().reference(fromURL: Constants.Database.users)
    ref.child(uid).child(Node.saved).child(petID).setValue(true)
  }
  
  /**
   Reject the specified pet.
   - Parameter petID: ID of the pet to reject.
   - Parameter uid: UID of the user to reject the pet for.
   */
  func reject(petID: String, for uid: String) {
    let ref = Database.database().reference(fromURL: Constants.Database.users)
    ref.child(uid).child(Node.rejected).child(petID).setValue(true)
  }
  
  /**
   Delete the specified saved pet.
   - Parameter petID: ID of the pet to delete from saves.
   - Parameter uid: UID of the user to delete the pet for.
   */
  func delete(petID: String, for uid: String) {
    ActivityIndicator.shared.startAnimating()
    
    let ref = Database.database().reference(fromURL: Constants.Database.users)
    
    ref.child(uid).child(Node.saved).child(petID).removeValue() { (error, reference) in
      ActivityIndicator.shared.stopAnimating()
      
      if error != nil {
        self.delegate?.service(didFailWith: self.errorDispatch.getError(for: .couldNotDelete))
      } else {
        self.delegate?.serviceDidDeletePet()
      }
    }
  }
  
  // MARK: - Login
  
  /**
   Log the user into Auth using their email and password.
   - Parameter email: User's email.
   - Parameter password: User's password.
   */
  func logIn(email: String, password: String) {
    ActivityIndicator.shared.startAnimating()
    
    Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
      if user != nil {
        self.delegate?.serviceLoggedIn()
      } else {
        ActivityIndicator.shared.stopAnimating()
        self.delegate?.service(didFailWith: self.errorDispatch.getError(for: .invalidLogin))
      }
    }
  }
  
  // MARK: - Logout
  
  /**
   Log the user out of Auth.
   */
  func logOut() {
    ActivityIndicator.shared.startAnimating()
    
    do {
      try Auth.auth().signOut()
      ActivityIndicator.shared.stopAnimating()
      delegate?.serviceLoggedOut()
    } catch {
      ActivityIndicator.shared.stopAnimating()
      delegate?.service(didFailWith: errorDispatch.getError(for: .couldNotLogOut))
    }
  }
  
  // MARK: - Password reset
  
  /**
   Send a password reset email to the member with the provided email address.
   */
  func sendPasswordReset(toEmail email: String) {
    ActivityIndicator.shared.startAnimating()
    
    Auth.auth().sendPasswordReset(withEmail: email) { (error) in
      ActivityIndicator.shared.stopAnimating()
      
      if error != nil {
        self.delegate?.service(didFailWith: self.errorDispatch.getError(for: .passwordResetError))
      } else {
        self.delegate?.serviceResetPassword(error: self.errorDispatch.getError(for: .successfulPasswordReset))
      }
    }
  }
}
