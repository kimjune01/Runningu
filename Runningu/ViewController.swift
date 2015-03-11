//
//  ViewController.swift
//  Runningu
//
//  Created by Camvy Films on 2015-02-09.
//  Copyright (c) 2015 June. All rights reserved.
//

import UIKit

enum LeftOrRight {
  case Left
  case Right
  case Unknown
}

class ViewController: UIViewController {
  var twoFingerTapRecognizer:UITapGestureRecognizer!
  var swipeDownRecognizer:UISwipeGestureRecognizer!
  
  let velocity = VelocityIndicator()
  let jump = JumpIndicator()
  let levelLabel = LevelIndicator(frame: CGRectMake(0, 0, screenWidth, screenHeight/7))
  var lastSwipePoint:CGPoint?
  var lastDirection:LeftOrRight = .Unknown {
    didSet {
      switch lastDirection {
      case .Left:
        println()
      case .Right:
        println()
      case .Unknown:
        stepperView.reset()
        
      }
    }
  }
  var stepperView:StepperView!
  var obstacles:[GapObstacle] = []
  var currentlyPlaying:Bool = false {
    didSet{
      if currentlyPlaying == false {
        NSNotificationCenter.defaultCenter().postNotificationName("notPlaying", object: nil)
        disableObstacleCollisions()
      }
    }
  }
  var firstTime = true
  var currentLevel:Int = 1 {
    didSet{
      levelLabel.text = String(currentLevel)
    }
  }
  var obstacleFrequency:UInt32 = 45
  
  var nextLevelView:UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupRunningu()
    //mockAddObstacle()
  }


  func mockAddObstacle() {
    let obstacleSize:CGFloat = 20
    let obstacle = GapObstacle(frame: CGRectMake(0, 100, screenWidth, obstacleSize))
    obstacles.append(obstacle)
    obstacle.delegate = self
    view.addSubview(obstacle)
//    obstacle.moveDown()
    
  }
  
  func setupRunningu(){
    addGestureRecognizers()
    addIndicators()
    addStartView()
    addStepperView()

  }
  
  func addStartView() {
    
  }
  
  func addGestureRecognizers() {
    twoFingerTapRecognizer = UITapGestureRecognizer(target: self, action: "twoFingerTapped:")
    twoFingerTapRecognizer.numberOfTouchesRequired = 2
    twoFingerTapRecognizer.enabled = true
    twoFingerTapRecognizer.delegate = self
    view.addGestureRecognizer(twoFingerTapRecognizer)
    
    swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: "swipedDown:")
    swipeDownRecognizer.direction = .Down
    swipeDownRecognizer.delegate = self
    view.addGestureRecognizer(swipeDownRecognizer)

  }
  
  func addIndicators() {
    velocity.frame = CGRectMake(0, 0, 20, screenHeight)
    velocity.delegate = self
    view.addSubview(velocity)
    jump.frame = CGRectMake(screenWidth/3, screenHeight/3, screenWidth/3, screenWidth/3)
    view.addSubview(jump)
    levelLabel.textColor = UIColor.blackColor()
    levelLabel.font = UIFont(name: "Helvetica", size: 30)
    levelLabel.text = String(currentLevel)
    levelLabel.textAlignment = NSTextAlignment.Center
    view.addSubview(levelLabel)
  }
  
  func addStepperView() {
    let stepperWidth:CGFloat = 10
    let stepperHeight:CGFloat = 50
    stepperView = StepperView(frame: CGRectMake(
      screenWidth * 0.5 - stepperWidth,
      screenHeight * 0.6 - stepperHeight,
      stepperWidth, stepperHeight))
    stepperView.alpha = 0
    view.addSubview(stepperView)
  }

  func startAddingObstacles() {
    fireTimer(2)
  }
  
  func fireTimer(interval:NSTimeInterval) {
    if currentlyPlaying {
      NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: "obstacleTimerFired:", userInfo: nil, repeats: false)
    }
  }
  
  func obstacleTimerFired(timer:NSTimer) {
    timer.invalidate()
    let randomInt = 6 + arc4random()%obstacleFrequency
    let randomTime:Float = Float(randomInt) / 10
    println("obstacleTimerFired! randomTime: \(randomTime)")
    fireTimer(NSTimeInterval(randomTime))
    releaseAnObstacle()
  }

  func releaseAnObstacle() {
    let obstacleSize:CGFloat = 20
    let obstacle = GapObstacle(frame: CGRectMake(0, -obstacleSize, screenWidth, obstacleSize))
    obstacles.append(obstacle)
    obstacle.delegate = self
    view.addSubview(obstacle)
    obstacle.moveDown()
  }
  
  func twoFingerTapped(recognizer:UITapGestureRecognizer) {
    
    //first time only
    startLevels()
    for eachObstacle in obstacles {
      if eachObstacle.isOnScreen {
        eachObstacle.disappear()
        break
      }
    }
    
  }
  
  func startLevels() {
    currentlyPlaying = true
    if firstTime {
      startAddingObstacles()
      firstTime = false
    }
  }
  
  func swipedDown(recognizer:UISwipeGestureRecognizer) {
    startLevels()

    let currentSwipePoint = recognizer.locationInView(view)
    
    var validSwipe = false
    if let swipePoint = lastSwipePoint {
      if lastDirection == .Left || lastDirection == .Unknown { //must go right
        if swipePoint.x < currentSwipePoint.x { //to the right
          validSwipe = true
          lastDirection = .Right
          stepperView.stepRight(currentSwipePoint)
        }
      } else if lastDirection == .Right || lastDirection == .Unknown { //must go left
        if swipePoint.x > currentSwipePoint.x {
          validSwipe = true
          lastDirection = .Left
          stepperView.stepLeft(currentSwipePoint)
        }
      }
    } else { //first time, do not validate.
      validSwipe = true
      lastDirection = .Unknown
      stepperView.stepLeft(currentSwipePoint)
    }
    
    if validSwipe {
      velocity.tick()
    }
    lastSwipePoint = currentSwipePoint
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func showGameOver() {
    if !currentlyPlaying {return}
    view.userInteractionEnabled = false
    let gameOverView = UIView(frame: CGRectMake(screenWidth/7, screenHeight/7, screenWidth*5/7, screenHeight*5/7))
    gameOverView.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.3)
    let gameOverLabel = UILabel(frame: CGRectMake(screenWidth/7, screenHeight/2 - 20, screenWidth*3/7, screenWidth*3/7))
    gameOverLabel.text = "Game Over"
    gameOverLabel.textColor = UIColor.whiteColor()
    gameOverLabel.font = UIFont(name: "Helvetica", size: 25)
    gameOverView.addSubview(gameOverLabel)
    
    view.addSubview(gameOverView)
    pause()
  }
  
  func showNextLevel() {
    pause()
    
    nextLevelView = UIView(frame: CGRectMake(screenWidth/7, screenHeight/7, screenWidth*5/7, screenHeight*5/7))
    nextLevelView.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(0.3)
    let nextLevelLabel = UILabel(frame: CGRectMake(screenWidth/7, screenHeight/2 - 20, screenWidth*3/7, screenWidth*3/7))
    nextLevelLabel.text = "Get Ready"
    nextLevelLabel.textColor = UIColor.whiteColor()
    nextLevelLabel.font = UIFont(name: "Helvetica", size: 25)
    nextLevelView.addSubview(nextLevelLabel)
    view.addSubview(nextLevelView)
    
    lastDirection = .Unknown
    
    let tapRecognizer = UITapGestureRecognizer(target: self, action: "nextLevelTapped:")
    tapRecognizer.numberOfTouchesRequired = 2
    swipeDownRecognizer.enabled = false
    twoFingerTapRecognizer.enabled = false
    nextLevelView.addGestureRecognizer(tapRecognizer)
    currentLevel++
    obstacleFrequency--
    velocity.speedThreshold--
    obstacleSpeed++
    
    
    //increase obstacle frequency
  }
  
  func pause() {
    NSNotificationCenter.defaultCenter().postNotificationName("pause", object: nil)
    currentlyPlaying = false
    disableObstacleCollisions()
  }
  
  func resume() {
    NSNotificationCenter.defaultCenter().postNotificationName("resume", object: nil)
    currentlyPlaying = true
    startAddingObstacles()
  }
  
  func nextLevelTapped(recognizer: UITapGestureRecognizer) {
    recognizer.removeTarget(self, action: "nextLevelTapped:")
    swipeDownRecognizer.enabled = true
    twoFingerTapRecognizer.enabled = true
    nextLevelView.removeFromSuperview()
    disableObstacleCollisions()
    resume()
    
    NSNotificationCenter.defaultCenter().postNotificationName("nextLevel", object: nil)
  }
  
  func disableObstacleCollisions() {
    for eachObstacle in obstacles {
      eachObstacle.collision = false
    }
  }
  
}

extension ViewController: GapObstacleDelegate {
  func gapObstacleMovedOutOfScreen(obstacle: GapObstacle) {
    //Game does not end upon gap obstacle moving out of screen. Instead, touching down ends game.
//    if ( currentlyPlaying && obstacle.collision == true ){
//      showGameOver()
//    }
    
  }
  
}

extension ViewController: VelocityIndicatorDelegate {
  func velocityIndicatorReachedTop(indicator: VelocityIndicator) {
    //go to next level.
    showNextLevel()
  }
  
  func velocityIndicatorReachedBottom(indicator: VelocityIndicator) {
    if currentlyPlaying {
      showGameOver()
    }
  }
}

extension ViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
    // if touch.view == an obstacle then return false. else return true
    var touchingAnObstacle = false
    for eachObstacle in obstacles {
      if touch.view == eachObstacle {
        touchingAnObstacle = true
        showGameOver()
      }
    }
    
    return !touchingAnObstacle
  }
}



