//
//  SleepSynopsisView.swift
//  Ambiance
//
//  Created by Matthew Carroll on 11/20/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit

class SleepSynopsisView: UIView {

    @IBOutlet var hoursLabel: UILabel!
    @IBOutlet var minutesLabel: UILabel!
    @IBOutlet var alexaInstructionsLabel: UILabel!
    @IBOutlet var ambianceTitleLabel: UILabel!
    
    public var viewModel: SleepSynopsisViewModel? {
        didSet {
            if let viewModel = self.viewModel {
                hoursLabel.text = "\(viewModel.hours)"
                minutesLabel.text = "\(viewModel.minutes)"
                alexaInstructionsLabel.attributedText = createAlexaInstructions(withAlexaCommand: viewModel.alexaCommand)
                ambianceTitleLabel.text = viewModel.ambianceTitle
            } else {
                hoursLabel.text = "_"
                minutesLabel.text = "_"
                alexaInstructionsLabel.text = "NO ALEXA INSTRUCTIONS"
                ambianceTitleLabel.text = "NONE"
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
        let nib = UINib(nibName: "SleepSynopsisView", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = self.bounds
        addSubview(view)
        
        self.viewModel = nil
    }

    private func createAlexaInstructions(withAlexaCommand command: String) -> NSAttributedString {
        let mutableAttString = NSMutableAttributedString(string: "Say, \"\(command)\" to begin playback")
        
        // Make the command text white.
        mutableAttString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: mutableAttString.mutableString.range(of: "\"\(command)\""))
        
        return mutableAttString
    }
}

struct SleepSynopsisViewModel {
    
    public let hours: Int
    public let minutes: Int
    public let alexaCommand: String
    public let ambianceTitle: String
    
}
