//
//  CurvedView.swift
//  Petsy
//
//  Created by Scott Campbell on 11/12/17.
//  Copyright © 2017 DotConfirmed. All rights reserved.
//

import UIKit

class CurvedView: UIView {
  
  // MARK: - Properties
  fileprivate let x: CGFloat = 0
  fileprivate let y: CGFloat = 80
  fileprivate let curveTo: CGFloat = 0
  
  // MARK: - Lifecycle
  
  override func draw(_ rect: CGRect) {
    let myBezier = UIBezierPath()
    myBezier.move(to: CGPoint(x: x, y: y))
    myBezier.addQuadCurve(to: CGPoint(x: rect.width, y: y), controlPoint: CGPoint(x: rect.width / 2, y: curveTo))
    myBezier.addLine(to: CGPoint(x: rect.width, y: rect.height))
    myBezier.addLine(to: CGPoint(x: x, y: rect.height))
    myBezier.close()
    
    let context = UIGraphicsGetCurrentContext()
    context!.setLineWidth(_:4.0)
    UIColor.white.setFill()
    myBezier.fill()
  }
}
