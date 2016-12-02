//
//  CircularView.swift
//  Ambiance
//
//  Created by Chihiro Saito on 11/20/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit

class CircularView: UIView {
    
    var delegate: CircularViewDelegate?
    
    let animationDuration = 1.5 // 1.5 seconds
    var animationLayer: CAShapeLayer?
    
    let FORWARD_ANIMATION = "forward"
    let REVERSE_ANIMATION = "backword"
    
    var animationColor = UIColor.orange
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //drawRingFittingInsideView()
    }
    
    internal func drawRingFittingInsideView()->() {
        let halfSize:CGFloat = min( bounds.size.width/2, bounds.size.height/2)
        let desiredLineWidth:CGFloat = 1    // your desired value
        
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x:halfSize,y:halfSize),
            radius: CGFloat( halfSize - (desiredLineWidth/2) ),
            startAngle: CGFloat(-M_PI_2),
            endAngle: CGFloat(-M_PI_2) + CGFloat(M_PI * 2),
            clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.darkGray.cgColor
        shapeLayer.lineWidth = 28.0
        
        if (self.animationLayer == nil) {
            self.animationLayer = CAShapeLayer()
            self.animationLayer!.path = circlePath.cgPath
            self.animationLayer!.fillColor = UIColor.clear.cgColor
            self.animationLayer!.lineWidth = 28.0
        }
        self.animationLayer!.isHidden = true
        
        self.layer.backgroundColor = UIColor.clear.cgColor
        if let sublayers = layer.sublayers {
            for sublayer in sublayers {
                sublayer.removeFromSuperlayer()
            }
        }
        layer.addSublayer(shapeLayer)
        layer.addSublayer(self.animationLayer!)
    }
    
    internal func initialize() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: (#selector(self.handleLongPress(_:))))
        longPressRecognizer.minimumPressDuration = 0.1
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(longPressRecognizer)
    }
    
    func handleLongPress(_ longPressRecognizer: UILongPressGestureRecognizer) {
        if longPressRecognizer.state == .began {
            self.animationLayer!.isHidden = false
            self.animationLayer!.strokeColor = self.animationColor.cgColor
            self.startForwardAnimation()
        } else if longPressRecognizer.state == .ended {
            self.startBackwardAnimation()
        }
    }
    
    func startForwardAnimation() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = self.animationDuration
        animation.delegate = self
        animation.setValue(FORWARD_ANIMATION, forKey: "id")
        self.animationLayer!.add(animation, forKey: FORWARD_ANIMATION)
    }
    func startBackwardAnimation() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        let strokeEndPosition = self.animationLayer!.presentation()?.strokeEnd
        if let strokeEndPosition = strokeEndPosition {
            animation.fromValue = strokeEndPosition
            animation.toValue = 0.0
            animation.duration = self.animationDuration * Double(strokeEndPosition)
            animation.delegate = self
            animation.fillMode = kCAFillModeForwards
            animation.isRemovedOnCompletion = false
            animation.setValue(REVERSE_ANIMATION, forKey: "id")
            self.animationLayer!.removeAnimation(forKey: FORWARD_ANIMATION)
            self.animationLayer!.add(animation, forKey: REVERSE_ANIMATION)
        } else {
            self.animationLayer!.isHidden = true
        }
    }
    
}

protocol CircularViewDelegate {
    func selected()
}

extension CircularView : CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if (flag == true) {
            let animationId = anim.value(forKey: "id")
            if let id = animationId as? String {
                if (id == FORWARD_ANIMATION) {
                    self.delegate!.selected()
                } else {
                    self.animationLayer!.removeAnimation(forKey: REVERSE_ANIMATION)
                    self.animationLayer!.isHidden = true
                }
            }
            
        }
    }
}
