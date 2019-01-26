//
//  SwipeViewController.swift
//  Petsy
//
//  Created by Scott Campbell on 11/10/17.
//  Copyright © 2017 DotConfirmed. All rights reserved.
//

import UIKit
import Koloda
import AlamofireImage

class SwipeViewController: NetworkViewController {
    
  // MARK: - Outlets
  @IBOutlet weak var kolodaView: KolodaView!
  @IBOutlet weak var locationView: UIStackView!
  @IBOutlet weak var errorView: UIStackView!
  @IBOutlet var labels: [UILabel]!
  @IBOutlet weak var infoButton: UIButton!
  @IBOutlet weak var errorButton: UIButton!
  @IBOutlet weak var badButton: UIButton!
  @IBOutlet weak var goodButton: UIButton!
  @IBOutlet var buttons: [UIButton]!
  @IBOutlet var secondaryButtons: [UIButton]!
  
  // MARK: - Private properties
  fileprivate var currentIndex: Int?
  fileprivate var petViewModels = [PetViewModel]()
  fileprivate var service = SwipeService()
  
  // MARK: - Types
  fileprivate struct Segues {
    static let profile = "ShowProfile"
    static let saved = "ShowSaved"
  }
  
  fileprivate struct Storyboards {
    static let login = "Login"
  }
  
  fileprivate struct Views {
    static let overlay = "CustomOverlayView"
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureService()
    configureNavbar()
    configureCards()
    configureButtons()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    UIApplication.shared.statusBarStyle = .default
  }
  
  // MARK: - Service Configuration

  /**
   Configure the swiping service.
   */
  fileprivate func configureService() {
    service.delegate = self
    service.initializeQuery()
  }
  
  // MARK: - Subview Configuration
  
  /**
   Configure the navbar.
   */
  fileprivate func configureNavbar() {
    let settingsButton = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: #selector(logOut(_:)))
    let savedButton = UIBarButtonItem(image: UIImage(named: "heart"), style: .plain, target: self, action: #selector(showSaved(_:)))
    navigationItem.leftBarButtonItems = [settingsButton]
    navigationItem.rightBarButtonItems = [savedButton]
  }
  
  /**
   Configure the cards.
   */
  fileprivate func configureCards() {
    kolodaView.dataSource = self
    kolodaView.delegate = self

    labels.forEach { $0.textColor = Constants.Colors.darkText }
    locationView.alpha = 0.0
    errorView.alpha = 0.0
  }
  
  /**
   Configure the buttons.
   */
  fileprivate func configureButtons() {
    buttons.forEach {
      $0.layer.cornerRadius = $0.frame.height / 2
      $0.layer.shadowColor = Constants.Colors.darkText.withAlphaComponent(0.3).cgColor
      $0.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
      $0.layer.masksToBounds = false
      $0.layer.shadowRadius = 2.0
      $0.layer.shadowOpacity = 0.5
    }
    
    secondaryButtons.forEach {
      $0.layer.borderWidth = 1.0
      $0.layer.borderColor = Constants.Colors.primary.cgColor
      $0.setTitleColor(Constants.Colors.primary, for: .normal)
    }
    
    errorButton.backgroundColor = Constants.Colors.red
    infoButton.backgroundColor = Constants.Colors.primary
    goodButton.backgroundColor = Constants.Colors.green
    badButton.backgroundColor = Constants.Colors.red
  }
  
  // MARK: - Actions

  @IBAction func leftSwipe(_ sender: UIButton) {
    kolodaView.swipe(.left, force: true)
  }
  
  @IBAction func rightSwipe(_ sender: UIButton) {
    kolodaView.swipe(.right, force: true)
  }
  
  @IBAction func showProfile(_ sender: UIButton) {
    guard let currentIndex = currentIndex else { return }
    showProfile(for: petViewModels[currentIndex])
  }
  
  @IBAction func showSaved(_ sender: UIButton) {
    performSegue(withIdentifier: Segues.saved, sender: nil)
  }
  
  @IBAction func openSettings(_ sender: UIButton) {
    guard let appSettings = URL(string: UIApplicationOpenSettingsURLString) else { return }
    UIApplication.shared.open(appSettings as URL)
  }
  
  @IBAction func retryQuery(_ sender: UIButton) {
    UIView.animate(withDuration: 0.15, animations: {
      self.locationView.alpha = 0.0
    })
    
    kolodaView.isHidden = false
    service.initializeQuery()
  }
  
  /**
   Show the PetProfileViewController for the specified animal.
   - Parameter petViewModel: PetVideModel to pass into the PetProfileViewController.
   */
  fileprivate func showProfile(for petViewModel: PetViewModel) {
    performSegue(withIdentifier: Segues.profile, sender: petViewModel)
  }
  
  // MARK: - Targets
  
  /**
   Fade the navbar's title change.
   - Parameter name: Name being shown in title.
   */
  func animateTitle(to name: String) {
    let animation = CATransition()
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    animation.type = kCATransitionFade
    animation.duration = 0.3
    navigationController?.navigationBar.layer.add(animation, forKey: kCATransitionFade)
    navigationItem.title = name
  }
  
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier else { return }
    
    if
      identifier == Segues.profile,
      let navController = segue.destination as? UINavigationController,
      let destinationController = navController.viewControllers.first as? PetProfileViewController,
      let sender = sender as? PetViewModel {
      destinationController.petViewModel = sender
    }
  }
  
  // MARK: - Alerts
  
  /**
   Present an alert for the user to confirm logout.
   */
  @IBAction func logOut(_ sender: UIBarButtonItem) {
    let alertController = UIAlertController(title: "Settings", message: nil, preferredStyle: .actionSheet)
    
    alertController.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { [unowned self] _ in
      self.service.logOut()
    }))
    
    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    alertController.view.tintColor = Constants.Colors.primary
    alertController.popoverPresentationController?.sourceView = view // so that iPads won't crash
    present(alertController, animated: true)
  }
}

// MARK: - KolodaViewDelegate protocol
extension SwipeViewController: KolodaViewDelegate {
  
  func kolodaShouldTransparentizeNextCard(_ koloda: KolodaView) -> Bool {
    return false
  }
  
  func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
    switch direction {
    case .right: service.save(petID: petViewModels[index].getID())
    case .left: service.reject(petID: petViewModels[index].getID())
    default: return
    }
  }
  
  func koloda(_ koloda: KolodaView, didShowCardAt index: Int) {
    currentIndex = index
    animateTitle(to: petViewModels[index].getName())
  }
  
  func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
    showProfile(for: petViewModels[index])
  }
  
  func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
    ActivityIndicator.shared.startAnimating()
    service.repeatQuery()
  }
}

// MARK: - KolodaViewDataSource protocol
extension SwipeViewController: KolodaViewDataSource {
  
  func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
    return .default
  }
  
  func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
    return petViewModels.count
  }
  
  func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
    let petViewModel = petViewModels[index]

    let imageView = UIImageView(frame: koloda.frame)
    
    if let url = petViewModel.getCoverImageURL() {
      let size = CGSize(width: koloda.frame.width, height: koloda.frame.height)
      let imageFilter = AspectScaledToFillSizeWithRoundedCornersFilter(size: size, radius: 10.0)
      
      imageView.af_setImage(withURL: url,
                            placeholderImage: nil,
                            filter: imageFilter,
                            imageTransition: .crossDissolve(0.2)
      )
    }
    
    return imageView
  }
  
  func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
    return Bundle.main.loadNibNamed(Views.overlay, owner: self, options: nil)![0] as? CustomOverlayView
  }
}

// MARK: - SwipeServiceDelegate protocol
extension SwipeViewController: SwipeServiceDelegate {
  
  func serviceLoggedOut() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    appDelegate.changeRootViewController(toRootFromStoryboard: Storyboards.login)
  }
  
  func userNeedsToAllowLocation() {
    ActivityIndicator.shared.stopAnimating()
    
    UIView.animate(withDuration: 0.15, animations: {
      self.locationView.alpha = 1.0
    })

    errorView.alpha = 0.0
    kolodaView.isHidden = true
  }
  
  func service(didSucceedWith petViewModels: [PetViewModel]) {
    if petViewModels.isEmpty {
      service.repeatQuery()
    } else {
      locationView.alpha = 0.0
      errorView.alpha = 0.0

      ActivityIndicator.shared.stopAnimating()
      
      self.petViewModels.append(contentsOf: petViewModels)
      kolodaView.reloadData()
    }
  }
  
  func service(didFailWith error: Error) {
    ActivityIndicator.shared.stopAnimating()
    
    UIView.animate(withDuration: 0.15, animations: {
      self.errorView.alpha = 1.0
    })

    locationView.alpha = 0.0
    kolodaView.isHidden = true
  }
}
