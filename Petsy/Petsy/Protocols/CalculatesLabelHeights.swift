//
//  CalculatesLabelHeights.swift
//  Petsy
//
//  Created by Scott Campbell on 11/13/17.
//  Copyright © 2017 DotConfirmed. All rights reserved.
//

import UIKit

protocol CalculatesLabelHeights {
  
  /**
   Required: Get the height for the view that will contain a specific label title.
   - Parameter title: title String of the label.
   - Parameter fontName: font family to use for calculation.
   - Parameter fontSize: font family size to use for calculation.
   - Parameter width: width of the view that will contain the label.
   - Returns: height for the containing view of a label.
   */
  func heightForLabel(withTitle title: String,
                      withFont fontName: String,
                      withFontSize fontSize: CGFloat,
                      boundedByWidth width: CGFloat) -> CGFloat
  
  /**
   Required: Calculate the height for the view that will contain a specific label title.
   - Parameter title: title String of the label.
   - Parameter font: UIFont used for label title.
   - Parameter width: width of the view that will contain the label.
   - Returns: height for the containing view of a label.
   */
  func calculateHeightForLabel(withTitle title: String,
                               withFont font: UIFont,
                               boundedByWidth width: CGFloat) -> CGFloat
}

// MARK: - Extension
extension CalculatesLabelHeights {
  
  /**
   Required: Get the height for the view that will contain a specific label title.
   */
  func heightForLabel(withTitle title: String,
                      withFont fontName: String,
                      withFontSize fontSize: CGFloat,
                      boundedByWidth width: CGFloat) -> CGFloat {
    
    guard let font = UIFont(name: fontName, size: fontSize) else { return fontSize }
    return calculateHeightForLabel(withTitle: title, withFont: font, boundedByWidth: width)
  }
  
  /**
   Required: Calculate the height for the view that will contain a specific label title.
   */
  func calculateHeightForLabel(withTitle title: String,
                               withFont font: UIFont,
                               boundedByWidth width: CGFloat) -> CGFloat {
    
    let rect = NSString(string: title).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)),
                                                    options: .usesLineFragmentOrigin,
                                                    attributes: [NSAttributedStringKey.font: font], context: nil)
    return ceil(rect.height)
  }
}
