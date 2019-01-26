//
//  SavedCollectionViewCell.swift
//  Petsy
//
//  Created by Scott Campbell on 11/13/17.
//  Copyright © 2017 DotConfirmed. All rights reserved.
//

import UIKit
import AlamofireImage

class SavedCollectionViewCell: UICollectionViewCell {
  
  // MARK: - Outlets
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var animalLabel: UILabel!
  @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
  
  // MARK: - Properties
  
  var imageURL: URL? {
    didSet {
      guard let imageURL = imageURL else { return }
      configureImage(fromURL: imageURL)
    }
  }
  
  var name: String? {
    didSet {
      nameLabel.text = name
    }
  }
  
  var animal: String? {
    didSet {
      animalLabel.text = animal
    }
  }
  
  // MARK: - Types
  fileprivate struct Dimension {
    static let cornerRadius: CGFloat = 6.0
  }
  
  // MARK: - Lifecycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
    configureSubviews()
    imageViewHeight.constant = floor((UIScreen.main.bounds.size.width - 76) / 2)
  }
  
  /**
   Prepares a reusable cell for reuse by the table view's delegate.
   */
  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.layer.removeAllAnimations()
    imageView.image = nil
  }
  
  // MARK: - Configuration
  
  /**
   Configure the subviews.
   */
  fileprivate func configureSubviews() {
    imageView.layer.cornerRadius = Dimension.cornerRadius
    nameLabel.textColor = Constants.Colors.darkText
    animalLabel.textColor = Constants.Colors.darkText
  }
  
  /**
   Use Alamofire to filter and set the image.
   - Parameter url: imageURL to the image to load.
   */
  fileprivate func configureImage(fromURL url: URL) {
    let size = CGSize(width: imageView.frame.width, height: imageView.frame.width)
    let imageFilter = AspectScaledToFillSizeWithRoundedCornersFilter(size: size, radius: Dimension.cornerRadius)
    
    imageView.af_setImage(withURL: url,
                          placeholderImage: nil,
                          filter: imageFilter,
                          imageTransition: .crossDissolve(0.2)
    )
  }
}
