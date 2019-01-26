//
//  ErrorDispatch.swift
//  Petsy
//
//  Created by Scott Campbell on 11/10/17.
//  Copyright © 2017 DotConfirmed. All rights reserved.
//

import Foundation

class ErrorDispatch {
  
  // MARK: - Private properties
  
  enum Err: String {
    case accountExists = "Oops! Looks like you've already got an account. Try logging in instead."
    case catchAll = "Oops! Something bad happened. Please try again!"
    case couldNotLogOut = "Oops! There was a problem logging out. Please try again."
    case couldNotDelete = "Oops! Your pet couldn't be deleted. Please try again."
    case invalidEmail = "Hmm... that doesn't look like an email address."
    case invalidInputs = "Hmm... it looks like you forgot to enter your email or password."
    case invalidLogin = "Hmm... those credentials don't look right. Please try again."
    case invalidPassword = "Oops! Your password needs at least 6 characters."
    case locationNotAvailable = "Hmm... we can't access your location. Check your internet connection and try again."
    case needEmailForReset = "Oops! We can't reset your passsword unless you enter your email."
    case noNetworkConnection = "Hmm... you're not connected to the internet. Check your connection and try again."
    case passwordResetError = "Oops! Something happened while trying to reset your password. Please try again."
    case successfulPasswordReset = "Success! Please check your email to reset your password."
    case userDeserialization = "Oops, something bad happened. Please try again!"
    case userSerialization = "Oops, we couldn't create your account. Please try again!"
  }
  
  /**
   Get the appropriate error for an event.
   - Parameter: The type of error that occurred.
   - Returns: New NSError with appropriate localizedDescription.
   */
  func getError(for type: Err) -> NSError {
    return NSError(
      domain: "Petsy",
      code: 0,
      userInfo: [NSLocalizedDescriptionKey: type.rawValue]
    )
  }
}
