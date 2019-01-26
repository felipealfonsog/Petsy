//
//  TextField.swift
//  Petsy
//
//  Created by Scott Campbell on 11/10/17.
//  Copyright © 2017 DotConfirmed. All rights reserved.
//

import UIKit

// Subclass for custom textField insets.
class TextField: UITextField {
  
  // MARK: - Overrides
  
  // Returns the drawing rectangle for the text field’s text.
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 5, left: 12, bottom: 5, right: 5))
  }
  
  // Returns the drawing rectangle for the text field’s placeholder text.
  override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 5, left: 12, bottom: 5, right: 5))
  }
  
  // Returns the rectangle in which editable text can be displayed.
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 5, left: 12, bottom: 5, right: 5))
  }
}
