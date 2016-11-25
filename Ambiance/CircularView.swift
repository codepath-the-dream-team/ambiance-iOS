//
//  CircularView.swift
//  Ambiance
//
//  Created by Chihiro Saito on 11/20/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit

class CircularView: UIView {
    
    var isPressed = false
    var delegate: CircularViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    override func draw(_ rect: CGRect) {
        drawRingFittingInsideView()
    }
    
    internal func drawRingFittingInsideView()->() {
        let halfSize:CGFloat = min( bounds.size.width/2, bounds.size.height/2)
        let desiredLineWidth:CGFloat = 1    // your desired value
        
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x:halfSize,y:halfSize),
            radius: CGFloat( halfSize - (desiredLineWidth/2) ),
            startAngle: CGFloat(0),
            endAngle:CGFloat(M_PI * 2),
            clockwise: true)
        
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        //change the fill color
        shapeLayer.fillColor = self.isPressed ? UIColor.lightGray.cgColor : UIColor.clear.cgColor
        //you can change the stroke color
        shapeLayer.strokeColor = UIColor.darkGray.cgColor
        //you can change the line width
        shapeLayer.lineWidth = 28.0
        
        self.layer.backgroundColor = UIColor.clear.cgColor
        if let sublayers = layer.sublayers {
            for sublayer in sublayers {
                sublayer.removeFromSuperlayer()
            }
        }
        layer.addSublayer(shapeLayer)
    }
    
    internal func initialize() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: (#selector(self.handleLongPress(_:))))
        longPressRecognizer.minimumPressDuration = 1.0
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(longPressRecognizer)
    }
    
    func handleLongPress(_ longPressRecognizer: UILongPressGestureRecognizer) {
        if longPressRecognizer.state == .began {
            self.isPressed = true
            self.setNeedsDisplay()
        } else if longPressRecognizer.state == .ended {
            self.isPressed = false
            self.setNeedsDisplay()
            self.delegate?.selected()
        }
    }

}

protocol CircularViewDelegate {
    func selected()
}
