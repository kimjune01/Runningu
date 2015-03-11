//
//  StepperView.swift
//  Runningu
//
//  Created by Camvy Films on 2015-02-10.
//  Copyright (c) 2015 June. All rights reserved.
//

import UIKit

class StepperView: UIView {

  lazy var displayLink:CADisplayLink = {
    return CADisplayLink(target: self, selector: "displayLinkFired:")
    }()
  
  let stepWidth:CGFloat = 40
  var originalFrame:CGRect!
  let leftFoot = UIImageView(image: UIImage(named: "leftFoot.png"))
  let rightFoot = UIImageView(image: UIImage(named: "rightFoot.png"))

  override init(frame: CGRect) {
    super.init(frame: frame)
    originalFrame = frame
    setup()
  }

  required init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  func setup() {
    //backgroundColor = UIColor.brownColor().colorWithAlphaComponent(0.6)
    addSubview(leftFoot)
    leftFoot.hidden = true
    addSubview(rightFoot)
    rightFoot.hidden = true
    displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
    
  }
  
  func displayLinkFired(link:CADisplayLink) {
    if alpha > 0 {
      alpha *= 0.85
      alpha -= 0.02
    }
  }
  
  func stepLeft(point:CGPoint) {
    alpha = 1
    frame = CGRectMake(point.x - frame.width - 10, point.y, frame.width, frame.height)
    leftFoot.hidden = false
    rightFoot.hidden = true
  }
  
  func stepRight(point:CGPoint) {
    alpha = 1
    frame = CGRectMake(point.x - frame.width - 10, point.y, frame.width, frame.height)
    leftFoot.hidden = true
    rightFoot.hidden = false
  }
  
  func reset() {
    frame = originalFrame
  }
  
  
}

