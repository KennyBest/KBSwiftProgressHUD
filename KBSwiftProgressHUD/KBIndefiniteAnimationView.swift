//
//  KBIndefiniteAnimationView.swift
//  KBSwiftProgressHUD
//
//  Created by llj on 2017/5/12.
//  Copyright © 2017年 llj. All rights reserved.
//

import UIKit

class KBIndefiniteAnimationView: UIView {
    
    var radius: CGFloat = 40.0 {
        didSet {
            let point = radius + self.strokeThickness/2 + 5
            let arcCenter = CGPoint(x: point, y: point)
            let smoothedPath = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: CGFloat(Double.pi*3/2), endAngle: CGFloat(Double.pi/2+Double.pi*5), clockwise: true)
            
            self.indefiniteAnimatedLayer.path = smoothedPath.cgPath
            self.layoutAnimatedLayer()
        }
    }
    
    var strokeThickness: CGFloat = 2.0 {
        didSet {
            self.indefiniteAnimatedLayer.lineWidth = strokeThickness
        }
    }
    
    var strokeColor: UIColor = .black {
        didSet {
            self.indefiniteAnimatedLayer.strokeColor = strokeColor.cgColor
        }
    }
    
    lazy var indefiniteAnimatedLayer: CAShapeLayer = {
        let point = self.radius + self.strokeThickness/2 + 5
        let arcCenter = CGPoint(x: point, y: point)
        let smoothedPath = UIBezierPath(arcCenter: arcCenter, radius: self.radius, startAngle: CGFloat(Double.pi*3/2), endAngle: CGFloat(Double.pi/2+Double.pi*5), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.contentsScale = UIScreen.main.scale
        shapeLayer.frame = CGRect(x: 0.0, y: 0.0, width: arcCenter.x*2, height: arcCenter.y*2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = self.strokeColor.cgColor
        shapeLayer.lineWidth = self.strokeThickness
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.lineJoin = kCALineJoinBevel
        shapeLayer.path = smoothedPath.cgPath
        
        self.addAnimationForIndefinteAnimatedLayer(layer: shapeLayer)
        
        if nil == shapeLayer.superlayer {
            self.layer.addSublayer(shapeLayer)
        }
        
        return shapeLayer
    }()
    
    func addAnimationForIndefinteAnimatedLayer(layer: CAShapeLayer) -> Void {
        let maskLayer = CALayer()
        
//        let path = Bundle.main.path(forResource: "angle-mask", ofType: "png")
        let image = UIImage(named: "angle-mask")
        maskLayer.contents = image!.cgImage
        maskLayer.frame = layer.bounds
        layer.mask = maskLayer
        
        let animationDuration: TimeInterval = 1.0
        let linearCurve = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = NSNumber(value: 0)
        animation.toValue = NSNumber(value: Double.pi * 2)
        animation.duration = animationDuration
        animation.timingFunction = linearCurve
        animation.isRemovedOnCompletion = false
        // 无限循环
        animation.repeatCount = Float.infinity
        animation.fillMode = kCAFillModeForwards
        animation.autoreverses = false
        layer.mask?.add(animation, forKey: "rotate")
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = animationDuration
        animationGroup.repeatCount = Float.infinity
        animationGroup.timingFunction = linearCurve
        
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = NSNumber(value: 0.015)
        strokeStartAnimation.toValue = NSNumber(value: 0.515)
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = NSNumber(value: 0.485)
        strokeEndAnimation.toValue = NSNumber(value: 0.985)
        animationGroup.animations = [strokeStartAnimation, strokeEndAnimation]
        layer.add(animationGroup, forKey: "progress")
    }
    
    func layoutAnimatedLayer() -> Void {
        
        let widthDiff = self.bounds.width - layer.bounds.width
        let heightDiff = self.bounds.height - layer.bounds.height
        let x = self.bounds.width - layer.bounds.width / 2 - widthDiff / 2
        let y = self.bounds.height - layer.bounds.height / 2 - heightDiff / 2
        
        self.indefiniteAnimatedLayer.position = CGPoint(x: x, y: y)
        
        //TODO: 设置一个view的layer的position等同于设置view自身的positon
    }
    
    
    override func willMove(toSuperview newSuperview: UIView?) {
        guard let _ = newSuperview else {
            self.indefiniteAnimatedLayer.removeFromSuperlayer()
            return
        }
        self.layoutAnimatedLayer()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let length = (self.radius + self.strokeThickness / 2 + 5) * 2
        return CGSize(width: length, height: length)
    }
    
}

