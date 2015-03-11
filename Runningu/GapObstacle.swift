//
//  GapObstacle.swift
//  Runningu
//
//  Created by Camvy Films on 2015-02-09.
//  Copyright (c) 2015 June. All rights reserved.
//

import UIKit

protocol GapObstacleDelegate {
  func gapObstacleMovedOutOfScreen(obstacle: GapObstacle)
  func gapObstacleTouchedDown(obstacle: GapObstacle)
}

var obstacleSpeed = 1

class GapObstacle: UIView {

  var displayLink: CADisplayLink!
  var movingDown = false
  
  var isOnScreen = false
  var fading = false
  var collision = true
  var delegate:GapObstacleDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    displayLink = CADisplayLink(target: self, selector: "displayLinkFired:")
    displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
    backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
    //subscribe
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "pause:", name: "pause:", object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "resume:", name: "resume:", object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "nextLevel:", name: "nextLevel", object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "notPlaying:", name: "notPlaying", object: nil)
    
    
  }

  required init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  
  func pause(notification:NSNotification) {
    //PAUSE things.
    fading = true
  }
  
  func resume(notification:NSNotification) {
    
  }
  
  func notPlaying(notification:NSNotification) {
    fading = true
  }
  
  func nextLevel(notification:NSNotification) {
    println("next level from Obstacle!")
    fading = true
  }
    
  func displayLinkFired(link:CADisplayLink) {
    if movingDown {
      self.frame = CGRectMake(frame.origin.x, frame.origin.y + CGFloat(obstacleSpeed), frame.width, frame.height)
      if frame.origin.y > screenHeight {
        movingDown = false
        backgroundColor = UIColor.orangeColor().colorWithAlphaComponent(0.9)
        delegate?.gapObstacleMovedOutOfScreen(self)
      }
    }
    if fading {
      if alpha > 0 {
        alpha *= 0.8
        alpha -= 0.02
      }
    }
    
  }
  
  func moveDown() {
    isOnScreen = true
    movingDown = true
    
  }
  
  func disappear () {
    removeFromSuperview()
    movingDown = false
    isOnScreen = false
    fading = true
    
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  
  
}
