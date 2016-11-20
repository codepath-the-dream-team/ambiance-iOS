//
//  DayCheckmarkView.swift
//  Ambiance
//
//  Created by Matthew Carroll on 11/19/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit

class DayCheckmarkView: UIView {

    @IBOutlet var checkmarkImageView: UIImageView!
    @IBOutlet var dayLabel: UILabel!
    
    @IBInspectable var title: String? {
        get {
            return dayLabel.text
        }
        set(title) {
            dayLabel.text = title
        }
    }
    
    private var _isChecked: Bool = false
    @IBInspectable var isChecked: Bool {
        get {
            return _isChecked
        }
        
        set(newIsChecked) {
            if (newIsChecked != _isChecked) {
                _isChecked = newIsChecked
                checkmarkImageView.backgroundColor = isChecked ? UIColor.red : UIColor.clear
                delegate?.onChange(checked: _isChecked)
            }
        }
    }
    
    public var delegate: DayCheckmarkViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initFromNib()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initFromNib()
    }
    
    func initFromNib() {
        let nib = UINib(nibName: "DayCheckmarkView", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = self.bounds
        addSubview(view)
        
        isUserInteractionEnabled = true
    }

    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        isChecked = !isChecked
    }
}

protocol DayCheckmarkViewDelegate {
    
    func onChange(checked: Bool)
    
}
