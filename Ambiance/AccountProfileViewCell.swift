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

//extension UIImage {
//    var circleMask: UIImage {
//        let square = CGSize(width: min(size.width, size.height), height: min(size.width, size.height))
//        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
//        imageView.contentMode = UIViewContentMode.scaleAspectFill
//        imageView.image = self
//        imageView.layer.cornerRadius = square.width/2
////        imageView.layer.borderWidth = 5
//        imageView.clipsToBounds = true
//        UIGraphicsBeginImageContext(imageView.bounds.size)
//        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
//        let result = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return result!
//    }
//}

extension UIView {
    func makeCircular() {
//        self.layer.cornerRadius = min(self.frame.size.height, self.frame.size.width) / 2.0
        self.layer.cornerRadius = self.frame.size.width/2
        self.layer.masksToBounds = true
//        self.clipsToBounds = true
    }
}


   
