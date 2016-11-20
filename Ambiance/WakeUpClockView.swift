//
//  WakeUpClockView.swift
//  Ambiance
//
//  Created by Matthew Carroll on 11/16/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit

class WakeUpClockView: UIView {

    @IBOutlet var clockLabel: UILabel!
    @IBOutlet var amPmLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    public var viewModel: WakeUpClockViewModel? {
        didSet {
            if let viewModel = self.viewModel {
                clockLabel.text = viewModel.time
                amPmLabel.text = viewModel.amPm.toString()
                descriptionLabel.attributedText = viewModel.message
            } else {
                clockLabel.text = ""
                amPmLabel.text = ""
                descriptionLabel.text = ""
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initFromNib()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initFromNib()
    }
    
    func initFromNib() {
        let nib = UINib(nibName: "WakeUpClockView", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = self.bounds
        addSubview(view)
        
        self.viewModel = nil
    }

}

struct WakeUpClockViewModel {
    
    public let time: String
    public let amPm: AmPm
    public let message: NSAttributedString
    
}

enum AmPm {
    case am
    case pm
    
    public func toString() -> String {
        if (.am == self) {
            return "AM"
        } else {
            return "PM"
        }
    }
}
