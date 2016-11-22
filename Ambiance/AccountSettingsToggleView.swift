//
//  AccountSettingsToggleView.swift
//  Ambiance
//
//  Created by Ryan Chee on 11/21/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit

class AccountSettingsToggleView: UIView {

    @IBOutlet var settingsLabel: UILabel!
    @IBOutlet var switchLabel: UISwitch!
    
    public var viewModel: AccountSettingsToggleViewModel? {
        didSet {
            if let viewModel = self.viewModel {
                settingsLabel.text = viewModel.settingsLabel
                switchLabel.setOn(viewModel.switchValue, animated: false)
            } else {
                settingsLabel.text = ""
                switchLabel.setOn(true, animated: false)
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
        let nib = UINib(nibName: "AccountSettingsToggleView", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = self.bounds
        addSubview(view)
        
        self.viewModel = nil
    }

}

struct AccountSettingsToggleViewModel {
    public let settingsLabel: String
    public let switchValue: Bool
}
