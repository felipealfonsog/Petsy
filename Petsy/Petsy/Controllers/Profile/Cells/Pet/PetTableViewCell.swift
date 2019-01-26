//
//  PetTableViewCell.swift
//  Petsy
//
//  Created by Mackenzie Kary on 2017-11-10.
//  Copyright © 2017 DotConfirmed. All rights reserved.
//

import UIKit

class PetTableViewCell: UITableViewCell {
  
  // MARK: - Outlets
  
  @IBOutlet weak var breedLabel: UILabel!
  @IBOutlet weak var infoLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  // MARK: - Properties
  
  var breed: String? {
    didSet {
      breedLabel.text = breed
    }
  }
  
  var petInfo: String? {
    didSet {
      infoLabel.text = petInfo
    }
  }
  
  var petDescription: String? {
    didSet {
      descriptionLabel.text = petDescription
    }
  }
  
  // MARK: - Lifecycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
    configureSubviews()
  }
  
  // MARK: - Subview configuration
  
  /**
   Configure the subviews.
   */
  fileprivate func configureSubviews() {
    breedLabel.textColor = Constants.Colors.darkText
    infoLabel.textColor = Constants.Colors.darkText
    descriptionLabel.textColor = Constants.Colors.darkText
  }
}
