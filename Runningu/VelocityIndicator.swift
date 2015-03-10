//
//  VelocityIndicator.swift
//  Runningu
//
//  Created by Camvy Films on 2015-02-09.
//  Copyright (c) 2015 June. All rights reserved.
//

import UIKit

protocol VelocityIndicatorDelegate {
  func velocityIndicatorReachedBottom(indicator:VelocityIndicator)
  func velocityIndicatorReachedTop(indicator:VelocityIndicator)
  
}

class VelocityIndicator: UIView {

  lazy var displayLink:CADisplayLink = {
    return CADisplayLink(target: self, selector: "displayLinkFired:")
  }()
  var velocityBar = UIView(frame: CGRectMake(0, 0, screenWidth, 0))
  var delegate: VelocityIndicatorDelegate?
  
  var didTick:Bool = false
  var velocity:Int = 0
  var speedThreshold = 50
  var tickCounter:Int = 0
  
  override init() {
    super.init()
    setup()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "pause:", name: "pause", object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "resume:", name: "resume", object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "nextLevel:", name: "nextLevel", object: nil)
  }
  
  func pause(notification:NSNotification) {
    //PAUSE things. reset bar.
    velocity = 0
    tickCounter = 0
    stopMoving()
  }
  
  func resume(notification:NSNotification) {
    startMoving()
  }
  
  func nextLevel(notification:NSNotification) {
    println("next level from Velocity!")
  }
  
  func stopMoving() {
    displayLink.paused = true
  }
  
  func startMoving() {
    displayLink.paused = false
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
  }

  required init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  func setup() {
    backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.3)
    velocityBar.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.9)
    addSubview(velocityBar)
    clipsToBounds = true
    startMoving()
  }
  
  func displayLinkFired(link:CADisplayLink) {
    if didTick {
      velocity += speedThreshold
    }
    didTick = false
    if velocity > 0 {
      velocity--;
    }
    if tickCounter > 8 && velocity == 0 {
      //game over
      delegate?.velocityIndicatorReachedBottom(self)
      stopMoving()
    }
    if CGFloat(velocity) >= screenHeight {
      delegate?.velocityIndicatorReachedTop(self)
      stopMoving()
    }
    velocityBar.frame = CGRectMake(0, screenHeight - CGFloat(velocity), screenWidth, screenHeight*2)
    
  }
  
  func tick() {
    didTick = true
    tickCounter++
    //to get inverse of intervals.
    
  }

  deinit{
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
}
