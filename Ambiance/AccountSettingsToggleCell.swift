//
//  AccountSettingsToggleCell.swift
//  Ambiance
//
//  Created by Ryan Chee on 11/26/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit

class AccountSettingsToggleCell: UITableViewCell {

    
    @IBOutlet var settingsLabel: UILabel!
    @IBOutlet var switchLabel: UISwitch!
    @IBOutlet weak var echoSerialLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    deinit {
        self.switchLabel.removeTarget(self.switchLabel, action: "saveSettings", for: .allEvents)
    }
    
}

struct AccountSettingsToggleViewModel {
    public let settingsLabel: String
    public let switchValue: Bool
}
