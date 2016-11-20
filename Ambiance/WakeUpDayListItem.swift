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
    @IBOutlet var finishRiseTimeLabel: UILabel!
    
    public var viewModel: WakeUpDayListItemViewModel? {
        didSet {
            if let viewModel = self.viewModel {
                dayNameLabel.text = viewModel.dayName
                startRiseTimeLabel.text = viewModel.startRiseTime
                finishRiseTimeLabel.text = viewModel.finishRiseTime
            } else {
                dayNameLabel.text = ""
                startRiseTimeLabel.text = ""
                finishRiseTimeLabel.text = ""
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
    public let startRiseTime: String
    public let finishRiseTime: String
    
}
