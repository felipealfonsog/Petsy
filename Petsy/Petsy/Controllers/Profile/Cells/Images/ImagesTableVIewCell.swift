//
//  ImagesTableViewCells.swift
//  Petsy
//
//  Created by Mackenzie Kary on 2017-11-10.
//  Copyright © 2017 DotConfirmed. All rights reserved.
//

import UIKit

class ImagesTableViewCell: UITableViewCell {
  
  // MARK: - Outlets
  @IBOutlet weak var pageControl: UIPageControl!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
  
  // MARK: - Properties
  var imageURLs: [URL]! {
    didSet {
      pageControl.numberOfPages = imageURLs.count
      pageControl.currentPageIndicatorTintColor = Constants.Colors.primary
      pageControl.pageIndicatorTintColor = UIColor.lightGray
      pageControl.isHidden = imageURLs.count < Indicator.threshold
    }
  }
  
  // MARK: - Types
  fileprivate enum Reuse: String {
    case image = "ImageCollectionViewCell"
  }
  
  fileprivate struct Indicator {
    static let threshold = 2
  }
  
  fileprivate struct Screen {
    static let dimension = UIScreen.main.bounds.size.width
  }
  
  // MARK: - Lifecycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
    configureCollectionView()
  }
  
  // MARK: - Subview configuration
  
  /**
   Configure the collectionview.
   */
  fileprivate func configureCollectionView() {
    collectionViewHeight.constant = UIScreen.main.bounds.size.width
    collectionView.decelerationRate = UIScrollViewDecelerationRateFast
    collectionView.register(UINib(nibName: Reuse.image.rawValue, bundle: nil),
                            forCellWithReuseIdentifier: Reuse.image.rawValue)
  }
}

// MARK: - UICollectionViewDataSource protocol
extension ImagesTableViewCell: UICollectionViewDataSource {
  
  // Dequeue an ImageCollectionViewCell.
  fileprivate func getImageCell(at indexPath: IndexPath) -> ImageCollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Reuse.image.rawValue,
                                                  for: indexPath) as! ImageCollectionViewCell
    cell.imageURL = imageURLs[indexPath.row]
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int {
    return imageURLs.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return getImageCell(at: indexPath)
  }
}

// MARK: - UICollectionViewDelegateFlowLayout protocol
extension ImagesTableViewCell: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: Screen.dimension, height: Screen.dimension)
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let pageWidth = scrollView.frame.width
    let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
    pageControl.currentPage = currentPage
  }
}
