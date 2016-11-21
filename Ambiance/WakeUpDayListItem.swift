//
//  WakeUpDayListItem.swift
//  Ambiance
//
//  Created by Matthew Carroll on 11/16/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit

class WakeUpDayListItem: UIView {

    @IBOutlet var dayNameLabel: UILabel!
    @IBOutlet var startRiseTimeLabel: UILabel!
    @IBOutlet var startRiseIcon: UIImageView!
    @IBOutlet var finishRiseTimeLabel: UILabel!
    @IBOutlet var finishRiseIcon: UIImageView!
    @IBOutlet var disabledLabel: UILabel!
    
    public var viewModel: WakeUpDayListItemViewModel? {
        didSet {
            if let viewModel = self.viewModel {
                dayNameLabel.text = viewModel.dayName
                
                if (viewModel.isEnabled) {
                    startRiseIcon.isHidden = false
                    startRiseTimeLabel.text = viewModel.startRiseTime
                    startRiseTimeLabel.isHidden = false
                    
                    finishRiseIcon.isHidden = false
                    finishRiseTimeLabel.text = viewModel.finishRiseTime
                    finishRiseTimeLabel.isHidden = false
                    
                    disabledLabel.isHidden = true
                } else {
                    startRiseIcon.isHidden = true
                    startRiseTimeLabel.isHidden = true
                    
                    finishRiseIcon.isHidden = true
                    finishRiseTimeLabel.isHidden = true
                    
                    disabledLabel.isHidden = false
                }
            } else {
                dayNameLabel.text = ""
                startRiseIcon.isHidden = true
                startRiseTimeLabel.text = ""
                finishRiseIcon.isHidden = true
                finishRiseTimeLabel.text = ""
                disabledLabel.isHidden = true
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
        let nib = UINib(nibName: "WakeUpDayListItem", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = self.bounds
        addSubview(view)
        
        self.viewModel = nil
    }

}

struct WakeUpDayListItemViewModel {
    
    public let dayName: String
    public let isEnabled: Bool
    public let startRiseTime: String
    public let finishRiseTime: String
    
}
