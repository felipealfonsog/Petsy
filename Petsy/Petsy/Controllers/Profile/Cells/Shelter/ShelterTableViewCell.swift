//
//  ShelterTableViewCell.swift
//  Petsy
//
//  Created by Mackenzie Kary on 2017-11-12.
//  Copyright © 2017 DotConfirmed. All rights reserved.
//

import UIKit

class ShelterTableViewCell: UITableViewCell {
  
  // MARK: - Outlets
  
  @IBOutlet weak var shelterLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  
  // MARK: - Properties
  
  var address: String? {
    didSet {
      addressLabel.text = address
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
    shelterLabel.textColor = Constants.Colors.darkText
    addressLabel.textColor = Constants.Colors.darkText
  }
}
