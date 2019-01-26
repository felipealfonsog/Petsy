//
//  LoginViewController.swift
//  Petsy
//
//  Created by Scott Campbell on 11/10/17.
//  Copyright © 2017 DotConfirmed. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
  
  // MARK: - Outlets
  @IBOutlet weak var petsy: UILabel!
  @IBOutlet weak var signUp: UIButton!
  @IBOutlet weak var logIn: UIButton!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var forgotPassword: UIButton!
  @IBOutlet var backgrounds: [UIView]!
  @IBOutlet var fields: [UITextField]!
  @IBOutlet var buttons: [UIButton]!
  
  // MARK: - Fileprivate properties
  fileprivate let service = UserService()
  fileprivate let errorDispatch = ErrorDispatch()
  fileprivate let emailVerifier = EmailVerifier()
  
  // MARK: - Types
  fileprivate struct Storyboards {
    static let main = "Main"
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureButtons()
    configureSubviews()
    configureService()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    UIApplication.shared.statusBarStyle = .lightContent
  }
  
  // MARK: - Configuration
  
  fileprivate func configureSubviews() {
    forgotPassword.setTitleColor(Constants.Colors.primary, for: .normal)
    backgrounds.forEach { $0.backgroundColor = Constants.Colors.primary }
    
    fields.forEach {
      $0.tintColor = Constants.Colors.primary
      $0.backgroundColor = Constants.Colors.lightText.withAlphaComponent(0.2)
      $0.layer.cornerRadius = 5.0
      $0.textColor = Constants.Colors.darkText
    }
  }
  
  fileprivate func configureButtons() {
    buttons.forEach {
      $0.layer.cornerRadius = $0.frame.height / 2
      $0.layer.shadowColor = Constants.Colors.darkText.withAlphaComponent(0.3).cgColor
      $0.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
      $0.layer.masksToBounds = false
      $0.layer.shadowRadius = 2.0
      $0.layer.shadowOpacity = 0.5
    }
    
    signUp.backgroundColor = Constants.Colors.primary
    signUp.setTitleColor(UIColor.white, for: .normal)
    logIn.setTitleColor(Constants.Colors.primary, for: .normal)
    logIn.layer.borderColor = Constants.Colors.primary.cgColor
    logIn.layer.borderWidth = 1.0
  }
  
  fileprivate func configureService() {
    service.delegate = self
  }
  
  // MARK: - Sign up
  
  /**
   Sign up the new user.
   */
  @IBAction func signUp(_ sender: UIButton) {
    validateSignUp()
  }
  
  /**
   Validate the sign up credentials and tell the service to create a new user.
   */
  fileprivate func validateSignUp() {
    if let email = emailField.text, email != "",
      let password = passwordField.text, password != "" {
      
      if !emailVerifier.properlyFormatted(email) {
        presentErrorAlert(error: errorDispatch.getError(for: .invalidEmail))
      } else if password.count < 6 {
        presentErrorAlert(error: errorDispatch.getError(for: .invalidPassword))
      } else {
        service.checkUser(email: email, password: password)
      }
      
    } else {
      presentErrorAlert(error: errorDispatch.getError(for: .invalidInputs))
    }
  }
  
  // MARK: - Log in
  
  /**
   Log in an existing user.
   */
  @IBAction func logIn(_ sender: UIButton) {
    validateLogIn()
  }
  
  /**
   Validate the log in credentials and tell the service to log the user in.
   */
  fileprivate func validateLogIn() {
    if let email = emailField.text, email != "",
      let password = passwordField.text, password != "" {
      service.logIn(email: email, password: password)
    } else {
      presentErrorAlert(error: errorDispatch.getError(for: .invalidInputs))
    }
  }
  
  // MARK: - Forgot password.
  
  /**
   Handle the user tapping on the forgot password button.
   */
  @IBAction func forgotPassword(_ sender: UIButton) {
    if let email = emailField.text, email != "" {
      if !emailVerifier.properlyFormatted(email) {
        presentErrorAlert(error: errorDispatch.getError(for: .invalidEmail))
      } else {
        service.sendPasswordReset(toEmail: email)
      }
    } else {
      presentErrorAlert(error: errorDispatch.getError(for: .needEmailForReset))
    }
  }
  
  // MARK: - Alerts
  
  /**
   Present an action alert.
   - Parameter error: Generated Error.
   */
  fileprivate func presentErrorAlert(error: Error) {
    let alertController = UIAlertController(title: "",
                                            message: error.localizedDescription,
                                            preferredStyle: .alert)
    
    alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
    alertController.view.tintColor = Constants.Colors.primary
    alertController.popoverPresentationController?.sourceView = view // so that iPads won't crash
    present(alertController, animated: true)
  }
}

// MARK: - UserServiceDelegate protocol
extension LoginViewController: UserServiceDelegate {
  
  func serviceLoggedIn() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    appDelegate.changeRootViewController(toRootFromStoryboard: Storyboards.main)
  }
  
  func serviceResetPassword(error: Error) {
    presentErrorAlert(error: error)
  }
    
  func service(didFailWith error: Error) {
    presentErrorAlert(error: error)
  }
}

// MARK: - UITextFieldDelegate protocol
extension LoginViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let nextTextField = textField.superview?.superview?.viewWithTag(textField.tag + 1) as? UITextField {
      nextTextField.becomeFirstResponder()
    } else {
      textField.resignFirstResponder()
    }
    
    return false
  }
}
