//
//  KBProgressAnimatedView.swift
//  KBProgressHUD
//
//  Created by llj on 2017/5/10.
//  Copyright © 2017年 llj. All rights reserved.
//

import UIKit

class KBProgressAnimatedView: UIView {
    override var frame: CGRect {
        didSet {
            if frame == super.frame {
                super.frame = frame
                self.layoutAnimatedLayer()
            }
        }
    }
    
    //TODO: 这里ringAnimatedLayer想置为nil时该如何设置，因为像OC中直接设置nil的时候会报错。
    var radius: CGFloat = 40.0 {
        didSet {
//            self.ringAnimatedLayer.removeFromSuperlayer()
            if let _ = self.superview {
                self.layoutAnimatedLayer()
            }
        }
    }
    
    var strokeThickness: CGFloat = 0.00 {
        didSet {
            self.ringAnimatedLayer.lineWidth = strokeThickness
        }
    }
    
    var strokeColor: UIColor = .black {
        didSet {
            self.ringAnimatedLayer.strokeColor = strokeColor.cgColor
        }
    }
    var strokeEnd: CGFloat = 0.00 {
        didSet {
            self.ringAnimatedLayer.strokeEnd = strokeEnd
        }
    }
    
    fileprivate lazy var ringAnimatedLayer: CAShapeLayer = {
        let point = self.radius + self.strokeThickness/2 + 5
        let arcCenter = CGPoint(x: point, y: point)
        
        let smootedPath = UIBezierPath(arcCenter: arcCenter, radius: self.radius, startAngle: CGFloat(-Double.pi/2), endAngle: CGFloat(Double.pi + Double.pi/2.0), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.contentsScale = UIScreen.main.scale
        shapeLayer.frame = CGRect(x: 0.0, y: 0.0, width: arcCenter.x * 2, height: arcCenter.y * 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = self.strokeColor.cgColor
        shapeLayer.lineWidth = self.strokeThickness
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.lineJoin = kCALineJoinBevel
        shapeLayer.path = smootedPath.cgPath
        
        return shapeLayer
    }()
    
    func layoutAnimatedLayer() -> Void {
        let layer = self.ringAnimatedLayer
        self.layer.addSublayer(layer)
        
        let widthDiff = self.bounds.width - layer.bounds.width
        let heightDiff = self.bounds.height - layer.bounds.height
        let x = self.bounds.width - layer.bounds.width / 2 - widthDiff / 2
        let y = self.bounds.height - layer.bounds.height / 2 - heightDiff / 2
        layer.position = CGPoint(x: x, y: y)
    }
    
}

func ==(lhs: CGRect, rhs: CGRect) -> Bool {
    return __CGSizeEqualToSize(lhs.size, rhs.size) && __CGPointEqualToPoint(lhs.origin, rhs.origin)
}

