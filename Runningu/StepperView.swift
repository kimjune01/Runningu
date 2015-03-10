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
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    originalFrame = frame
    setup()
  }

  required init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  func setup() {
    backgroundColor = UIColor.brownColor().colorWithAlphaComponent(0.6)
    displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
    
  }
  
  func displayLinkFired(link:CADisplayLink) {
    if alpha > 0 {
      alpha *= 0.85
      alpha -= 0.02
    }
  }
  
  func stepLeft() {
    alpha = 1
    frame = CGRectMake(frame.origin.x - stepWidth, frame.origin.y, frame.width, frame.height)
  }
  
  func stepRight() {
    alpha = 1
    frame = CGRectMake(frame.origin.x + stepWidth, frame.origin.y, frame.width, frame.height)
  }
  
  func reset() {
    frame = originalFrame
  }
  
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
