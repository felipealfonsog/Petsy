//
//  SavedViewController.swift
//  Petsy
//
//  Created by Scott Campbell on 11/10/17.
//  Copyright © 2017 DotConfirmed. All rights reserved.
//

import UIKit

class SavedViewController: NetworkViewController, CalculatesLabelHeights {
  
  // MARK: - Outlets
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var explanationLabel: UILabel!
  @IBOutlet weak var explanationButton: UIButton!
  @IBOutlet weak var explanationView: UIStackView!
  
  // MARK: - Properties
  fileprivate var petViewModels = [PetViewModel]()
  fileprivate let service = UserService()
  fileprivate let petService = PetService()
  
  // MARK: - Types
  fileprivate enum Reuse: String {
    case saved = "SavedCollectionViewCell"
  }
  
  fileprivate struct Segues {
    static let profile = "ShowProfile"
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureService()
    configureNavbar()
    configureCollectionView()
    fetchUser()
  }
  
  // MARK: - Service configuration
  
  /**
   Configure the service.
   */
  fileprivate func configureService() {
    service.delegate = self
    petService.delegate = self
  }
  
  // MARK: - Subview configuration
  
  /**
   Configure the navbar.
   */
  fileprivate func configureNavbar() {
    title = "Saved"
    let backButton = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(popViewController(_:)))
    navigationItem.leftBarButtonItems = [backButton]
  }
  
  /**
   Configure the collectionview.
   */
  fileprivate func configureCollectionView() {
    explanationLabel.textColor = Constants.Colors.darkText
    explanationButton.backgroundColor = Constants.Colors.green
    explanationButton.tintColor = .white
    explanationButton.layer.cornerRadius = explanationButton.frame.height / 2
    explanationButton.layer.shadowColor = Constants.Colors.darkText.withAlphaComponent(0.3).cgColor
    explanationButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    explanationButton.layer.masksToBounds = false
    explanationButton.layer.shadowRadius = 2.0
    explanationButton.layer.shadowOpacity = 0.5
    explanationView.alpha = 0.0
    
    collectionView.register(UINib(nibName: Reuse.saved.rawValue, bundle: nil),
                            forCellWithReuseIdentifier: Reuse.saved.rawValue)
  }
  
  // MARK: - Targets
  
  /**
   Fetch the user models.
   */
  fileprivate func fetchUser() {
    ActivityIndicator.shared.startAnimating()
    
    if let uid = service.getUID() {
      service.getUser(with: uid)
    }
  }
  
  /**
   Fetch the pet models.
   - Parameter userViewModel: User to fetch the pets for.
   */
  fileprivate func fetchPets(for userViewModel: UserViewModel) {
    let saved = userViewModel.getSaved()

    if saved.isEmpty {
      ActivityIndicator.shared.stopAnimating()
      UIView.animate(withDuration: 0.15, animations: {
        self.explanationView.alpha = 1.0
      })

      petViewModels.removeAll()
      collectionView.reloadData()
    } else {
      petService.fetchPets(for: userViewModel.getSaved())
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
  
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier else { return }
    
    if
      identifier == Segues.profile,
      let navController = segue.destination as? UINavigationController,
      let destinationController = navController.viewControllers.first as? PetProfileViewController,
      let sender = sender as? PetViewModel {
      destinationController.petViewModel = sender
      destinationController.deleteButtonVisible = true
    }
  }
  
  /**
   Called if the PetProfileViewController unwinds after a delete.
   */
  @IBAction func unwindAfterDelete(_ segue: UIStoryboardSegue) {
    fetchUser()
  }
  
  /**
   Pop the current view controller.
   */
  @IBAction func popViewController(_ sender: UIBarButtonItem) {
    _ = navigationController?.popViewController(animated: true)
  }
}

// MARK: - UICollectionViewDataSource protocol
extension SavedViewController: UICollectionViewDataSource {
  
  // Dequeue a SavedCollectionViewCell.
  fileprivate func getSavedCell(for indexPath: IndexPath) -> SavedCollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Reuse.saved.rawValue,
                                                  for: indexPath) as! SavedCollectionViewCell
    let petViewModel = petViewModels[indexPath.row]
    cell.imageURL = petViewModel.getCoverImageURL()
    cell.name = petViewModel.getName()
    cell.animal = petViewModel.getInfo()
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return petViewModels.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return getSavedCell(for: indexPath)
  }
}

// MARK: - UICollectionViewDelegateFlowLayout protocol
extension SavedViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let screenWidth = UIScreen.main.bounds.width
    let width = (screenWidth - 76) / 2
    
    let padding: CGFloat = 8.0
    let nameHeight = heightForLabel(withTitle: petViewModels[indexPath.row].getName(),
                                     withFont: "HelveticaNeue-Bold",
                                     withFontSize: 16,
                                     boundedByWidth: width)
    
    let breedHeight = heightForLabel(withTitle: petViewModels[indexPath.row].getInfo(),
                                     withFont: "HelveticaNeue-light",
                                     withFontSize: 12,
                                     boundedByWidth: width)
    
    let height = floor(width) + nameHeight + breedHeight + padding
    
    return CGSize(width: floor(width), height: height)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    performSegue(withIdentifier: Segues.profile, sender: petViewModels[indexPath.row])
  }
}

// MARK: - UserServiceDelegate protocol
extension SavedViewController: UserServiceDelegate {
  
  func service(didReceive userViewModel: UserViewModel) {
    fetchPets(for: userViewModel)
  }
  
  func service(didFailWith error: Error) {
    presentErrorAlert(error: error)
  }
}

// MARK: - PetServiceDelegate protocol
extension SavedViewController: PetServiceDelegate {
  
  func service(didSucceedWith petViewModels: [PetViewModel]) {
    ActivityIndicator.shared.stopAnimating()
    
    if petViewModels.isEmpty {
      UIView.animate(withDuration: 0.15, animations: {
        self.explanationView.alpha = 1.0
      })
    }
    
    self.petViewModels = petViewModels
    collectionView.reloadData()
  }
  
  func petService(didFailWith error: Error) {
    presentErrorAlert(error: error)
  }
}
