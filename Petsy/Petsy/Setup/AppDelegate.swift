//
//  AppDelegate.swift
//  Petsy
//
//  Created by Scott Campbell on 11/10/17.
//  Copyright © 2017 DotConfirmed. All rights reserved.
//

import Firebase
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  // MARK: - Private properties
  fileprivate let setup = Setup()
  
  // MARK: - Public properties
  var window: UIWindow?
  
  // MARK: - Lifecycle
  
  // Override point for customization after application launch.
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    // Setup Firebase.
    setup.configureFirebase()
    
    // Setup the initial view.
    configureRootController()
    
    // Starts monitoring network reachability status changes.
    ReachabilityManager.shared.startMonitoring()
    
    // Configure the navbar.
    if let backgroundImage = UIImage(color: UIColor.white.withAlphaComponent(0.95)) {
      let navBar = UINavigationBar.appearance()
      navBar.setBackgroundImage(backgroundImage, for: .default)
      navBar.tintColor = Constants.Colors.primary
      navBar.shadowImage = UIImage()
      
      if let barFont = UIFont(name: "HelveticaNeue-Bold", size: 18) {
        navBar.titleTextAttributes = [
          .foregroundColor: Constants.Colors.darkText,
          .font: barFont
        ]
      }
    }
        
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {}
  func applicationDidEnterBackground(_ application: UIApplication) {}
  func applicationWillEnterForeground(_ application: UIApplication) {}
  func applicationDidBecomeActive(_ application: UIApplication) {}
  func applicationWillTerminate(_ application: UIApplication) {}
  
  /**
   Configure the intial view controller.
   */
  func configureRootController() {
    let name = Auth.auth().currentUser == nil ? "Login" : "Main"
    window!.rootViewController = UIStoryboard(name: name, bundle: nil).instantiateInitialViewController()
  }
  
  /**
   Animate the replacement of the current root view controller with the specified view controller.
   - Parameter storyboardName: The name of the storyboard whose initial view controller should become the next root view controller.
   */
  func changeRootViewController(toRootFromStoryboard storyboardName: String) {
    let desiredViewController = UIStoryboard(name: storyboardName, bundle: nil).instantiateInitialViewController()
    
    let snapshot: UIView = (self.window?.snapshotView(afterScreenUpdates: true))!
    desiredViewController?.view.addSubview(snapshot);
    
    self.window?.rootViewController = desiredViewController;
    
    UIView.animate(withDuration: 0.3, animations: {() in
      UIApplication.shared.isStatusBarHidden = false
      snapshot.layer.opacity = 0;
    }, completion: { (value: Bool) in
      snapshot.removeFromSuperview();
    });
  }
}



