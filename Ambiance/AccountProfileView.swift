//
//  AccountProfileView.swift
//  Ambiance
//
//  Created by Ryan Chee on 11/21/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit
import AFNetworking

class AccountProfileView: UIView {

    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    public var viewModel: AccountProfileViewModel? {
        didSet {
            if let viewModel = self.viewModel {
                nameLabel.text = viewModel.name
                profileImage.setImageWith(viewModel.profileImageURL)
            } else {
                nameLabel.text = ""
                profileImage.tintColor = .orange
//                profileImage.image = some default image here
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
        let nib = UINib(nibName: "AccountProfileView", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = self.bounds
        addSubview(view)
        
        self.viewModel = nil
    }
    
}

struct AccountProfileViewModel {
    
    public let profileImageURL: URL
    public let name: String
    
}

