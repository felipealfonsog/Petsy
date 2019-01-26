//
//  PetProfileViewController.swift
//  Petsy
//
//  Created by Mackenzie Kary on 2017-11-10.
//  Copyright © 2017 DotConfirmed. All rights reserved.
//

import UIKit

class PetProfileViewController: NetworkViewController {
  
  // MARK: - Outlets
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var callButton: UIButton!
  @IBOutlet weak var emailButton: UIButton!
  @IBOutlet var buttons: [UIButton]!
  
  // MARK: - Properties
  var petViewModel: PetViewModel!
  var deleteButtonVisible: Bool = false
  fileprivate var service: UserService?
  
  // MARK: - Types
  fileprivate enum Reuse: String {
    case images = "ImagesTableViewCell"
    case pet = "PetTableViewCell"
    case shelter = "ShelterTableViewCell"
    static let all = [images, pet, shelter]
  }
  
  fileprivate struct Segues {
    static let delete = "UnwindAfterDelete"
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureService()
    configureNavbar()
    configureTableView()
    configureButtons()
  }
  
  // MARK: - Configuration
  
  /**
   Configure the service.
   */
  fileprivate func configureService() {
    guard deleteButtonVisible else { return }
    service = UserService()
    service?.delegate = self
    
    let savedButton = UIBarButtonItem(image: UIImage(named: "delete"), style: .plain, target: self, action: #selector(deletePet(_:)))
    navigationItem.rightBarButtonItems = [savedButton]
  }
  
  /**
   Configure the navbar.
   */
  fileprivate func configureNavbar() {
    title = petViewModel.getName()
    let backButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(popViewController(_:)))
    navigationItem.leftBarButtonItems = [backButton]
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
    
    callButton.setTitleColor(UIColor.white, for: .normal)
    callButton.backgroundColor = Constants.Colors.primary
    emailButton.setTitleColor(Constants.Colors.primary, for: .normal)
    emailButton.layer.borderWidth = 1
    emailButton.layer.borderColor = Constants.Colors.primary.cgColor
  }
  
  /**
   Configure the tableview.
   */
  fileprivate func configureTableView() {
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 74.0, right: 0)
    for identifier in Reuse.all {
      tableView.register(UINib(nibName: identifier.rawValue, bundle: nil),
                         forCellReuseIdentifier: identifier.rawValue)
    }
  }
  
  // MARK: - Actions
  
  /**
   Respond to the call button being tapped.
   */
  @IBAction func callShelter(_ sender: Any) {
    guard let url = petViewModel.getPhoneURL() else { return }
    UIApplication.shared.open(url)
  }
  
  /**
   Respond to the email button being tapped.
   */
  @IBAction func emailShelter(_ sender: Any) {
    guard let url = petViewModel.getEmailURL() else { return }
    UIApplication.shared.open(url)
  }
  
  /**
   Present an alert for the user to confirm deletion.
   */
  @IBAction func deletePet(_ sender: UIBarButtonItem) {
    guard let uid = service?.getUID() else { return }
    
    let alertController = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .actionSheet)
    alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [unowned self] _ in
      self.service?.delete(petID: self.petViewModel.getID(), for: uid)
    }))
    
    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    alertController.view.tintColor = Constants.Colors.primary
    alertController.popoverPresentationController?.sourceView = view // so that iPads won't crash
    present(alertController, animated: true)
  }
  
  // MARK: - Navigation
  
  /**
   Pop the current view controller.
   */
  @IBAction func popViewController(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
}

// MARK: - UITableViewDataSource protocol
extension PetProfileViewController: UITableViewDataSource {
  
  // Dequeue a ImagesTableViewCell.
  fileprivate func getImagesCell(at indexPath: IndexPath) -> ImagesTableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Reuse.images.rawValue,
                                             for: indexPath) as! ImagesTableViewCell
    cell.imageURLs = petViewModel.getImageURLs()
    return cell
  }
  
  // Dequeue a PetTableViewCell.
  fileprivate func getPetCell(at indexPath: IndexPath) -> PetTableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Reuse.pet.rawValue,
                                             for: indexPath) as! PetTableViewCell
    cell.breed = petViewModel.getBreed()
    cell.petInfo = petViewModel.getInfo()
    cell.petDescription = petViewModel.getDescription()
    return cell
  }
  
  // Dequeue a ShelterTableViewCell.
  fileprivate func getShelterCell(at indexPath: IndexPath) -> ShelterTableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Reuse.shelter.rawValue,
                                             for: indexPath) as! ShelterTableViewCell
    cell.address = petViewModel.getAddress()
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.row {
    case 0: return getImagesCell(at: indexPath)
    case 1: return getPetCell(at: indexPath)
    case 2: return getShelterCell(at: indexPath)
    default: return UITableViewCell()
    }
  }
}

// MARK: - UserServiceDelegate protocol
extension PetProfileViewController: UserServiceDelegate {
  
  func serviceDidDeletePet() {
    performSegue(withIdentifier: Segues.delete, sender: nil)
  }
  
  func service(didFailWith error: Error) {}
}
