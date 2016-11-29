//
//  AccountProfileViewCell.swift
//  Ambiance
//
//  Created by Ryan Chee on 11/26/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit
import AFNetworking

class AccountProfileViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var profileName: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
        self.profileImageView.makeCircular()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

struct AccountProfileViewModel {
    
    public let profileImageURL: URL
    public let name: String
    
}

// Extend UIView to make image circular
extension UIView {
    func makeCircular() {
        self.layer.cornerRadius = self.frame.size.width/2
        self.layer.masksToBounds = true
    }
}


   
