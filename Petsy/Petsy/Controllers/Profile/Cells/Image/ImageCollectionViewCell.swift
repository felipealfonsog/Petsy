//
//  ImageCollectionViewCell.swift
//  Petsy
//
//  Created by Mackenzie Kary on 2017-11-10.
//  Copyright © 2017 DotConfirmed. All rights reserved.
//

import UIKit
import AlamofireImage

class ImageCollectionViewCell: UICollectionViewCell {
  
  // MARK: - Outlets
  @IBOutlet weak var imageView: UIImageView!
  
  // MARK: - Properties
  var imageURL: URL? {
    didSet {
      guard let imageURL = imageURL else { return }
      configureImage(withURL: imageURL)
    }
  }
  
  // MARK: - Lifecycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  // MARK: - Subview configuration
  
  /**
   Use AlamofireImage to filter and set the imageView.
   - Parameter url: ImageURL.
   */
  fileprivate func configureImage(withURL url: URL) {
    let size = CGSize(width: imageView.frame.width, height: imageView.frame.height)
    let imageFilter = AspectScaledToFillSizeFilter(size: size)
    
    imageView.af_setImage(withURL: url,
                          placeholderImage: nil,
                          filter: imageFilter,
                          imageTransition: .crossDissolve(0.2)
    )
  }
}
