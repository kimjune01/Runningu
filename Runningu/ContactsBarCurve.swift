//
//  ContactsBarCurve.swift
//
//  Code generated using QuartzCode on 2015-02-20.
//  www.quartzcodeapp.com
//

import UIKit

class ContactsBarCurve: UIView {
	var bezierpath : CAShapeLayer!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupLayers()
	}
	
	required init(coder aDecoder: NSCoder)
	{
		super.init(coder: aDecoder)
		setupLayers()
	}
	
	override var frame: CGRect {
		didSet{
			setupLayerFrames()
		}
	}
	
	func setupLayers(){
		bezierpath = CAShapeLayer()
		self.layer.addSublayer(bezierpath)
		bezierpath.fillColor     = nil
		bezierpath.strokeColor   = UIColor.whiteColor().CGColor
		bezierpath.shadowColor   = UIColor.blackColor().CGColor
		bezierpath.shadowOpacity = 1
		bezierpath.shadowOffset  = CGSizeMake(0, 0)
		bezierpath.shadowRadius  = 5
		
		setupLayerFrames()
	}
	
	
	func setupLayerFrames(){
		if bezierpath != nil{
			bezierpath.frame = CGRectMake(-0.00469 * bezierpath.superlayer.bounds.width, 0.87046 * bezierpath.superlayer.bounds.height, 1.00488 * bezierpath.superlayer.bounds.width, 0.12866 * bezierpath.superlayer.bounds.height)
			bezierpath.path  = bezierpathPathWithBounds(bezierpath.bounds).CGPath;
		}
	}
	
	
	@IBAction func startAllAnimations(sender: AnyObject!){
		bezierpath?.addAnimation(bezierpathAnimation(), forKey:"bezierpathAnimation")
	}
	
	func bezierpathAnimation() -> CABasicAnimation{
		var strokeEndAnim            = CABasicAnimation(keyPath:"strokeEnd")
		strokeEndAnim.fromValue      = 0;
		strokeEndAnim.duration       = 1
		strokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn)
		strokeEndAnim.fillMode = kCAFillModeForwards
		strokeEndAnim.removedOnCompletion = false
		
		return strokeEndAnim;
	}
	
	//MARK: - Bezier Path
	
	func bezierpathPathWithBounds(bound: CGRect) -> UIBezierPath{
		var bezierpathPath = UIBezierPath()
		var minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
		
		bezierpathPath.moveToPoint(CGPointMake(minX, minY + 0.9995 * h))
		bezierpathPath.addCurveToPoint(CGPointMake(minX + 0.49418 * w, minY + 0.58397 * h), controlPoint1:CGPointMake(minX + 0.00495 * w, minY + 0.99352 * h), controlPoint2:CGPointMake(minX + 0.197 * w, minY + 1.06317 * h))
		bezierpathPath.addCurveToPoint(CGPointMake(minX + w, minY), controlPoint1:CGPointMake(minX + 0.79135 * w, minY + 0.10477 * h), controlPoint2:CGPointMake(minX + 0.90324 * w, minY + 0.00118 * h))
		
		return bezierpathPath;
	}

}