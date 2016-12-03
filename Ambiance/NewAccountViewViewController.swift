//
//  NewAccountViewViewController.swift
//  Ambiance
//
//  Created by Matthew Carroll on 12/3/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit

class NewAccountViewController: UIViewController, ClearNavBar {

    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    public var delegate: NewAccountViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        avatarImageView.makeCircular()
        
        clearBackground(forNavBar: navigationController!.navigationBar)
        
        updateDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutTap(_ sender: AnyObject) {
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        delegate?.showLoginController()
    }
    
    @IBAction func onEnabledChange(_ sender: UISwitch) {
        let user = UserSession.shared.loggedInUser!
        user.updateSettings(alarmEnabled: sender.isOn)
    }
    
    private func updateDisplay() {
        let user = UserSession.shared.loggedInUser!
        
        let url:URL? = user.profileImageUrl
        if let imageURL = url {
            avatarImageView.setImageWith(imageURL)
        }
        
        nameLabel.text = user.firstName
    }

}

protocol NewAccountViewControllerDelegate {
    func showLoginController()
}
