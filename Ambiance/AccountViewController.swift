//
//  AccountViewController.swift
//  Ambiance
//
//  Created by Matthew Carroll on 11/8/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit
import AFNetworking

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var settingsTableview: UITableView!
    
    public var delegate: AccountViewControllerDelegate?

    private var alarmEnabled: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        alarmEnabled = UserSession.shared.loggedInUser?.alarmEnabled
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = UserSession.shared.loggedInUser!
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "accountProfileViewCell", for: indexPath) as! AccountProfileViewCell
            let url:URL? = user.profileImageUrl
            if let imageURL = url {
                cell.profileImageView.setImageWith(imageURL)
            } else {
                //set profile image with default image
            }
            cell.profileName.text = user.firstName
            cell.isUserInteractionEnabled = false
            return cell
        } else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "accountSettingsToggleCell", for: indexPath) as! AccountSettingsToggleCell
            cell = setCellValues(forCell: cell, isEchoLabelHidden: true, isSwitchHidden: false, index: indexPath.row)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    // Function that sets the values for each cell depending on index
    func setCellValues(forCell: AccountSettingsToggleCell, isEchoLabelHidden: Bool, isSwitchHidden: Bool, index: Int) -> AccountSettingsToggleCell {
        let user = UserSession.shared.loggedInUser!
        switch index {
        case 1:
            forCell.settingsLabel.text = "Wake Enabled"
            forCell.switchLabel.isOn = user.alarmEnabled
            forCell.switchLabel.isHidden = isSwitchHidden
            forCell.echoSerialLabel.isHidden = isEchoLabelHidden
            forCell.switchLabel.tag = index
            break
        default:
            return forCell
        }
        forCell.switchLabel.addTarget(self, action: #selector(saveSettings), for: .valueChanged)
        return forCell
    }
    
    func saveSettings(sender: UISwitch) {
        let tag = sender.tag
        let user = UserSession.shared.loggedInUser!
        NSLog("saving the updated user settings")
        switch tag {
        case 1:
            //"Wake Enabled"
            user.updateSettings(alarmEnabled: sender.isOn)
            break
        default:
            return
        }
        return
    }
    
    // Function to setup necessary table view settings
    func setupTableView() {
        settingsTableview.delegate = self
        settingsTableview.dataSource = self
        settingsTableview.estimatedRowHeight = 100
        settingsTableview.rowHeight = UITableViewAutomaticDimension
        settingsTableview.alwaysBounceVertical = false
        settingsTableview.register(UINib(nibName: "AccountProfileViewCell", bundle: nil), forCellReuseIdentifier: "accountProfileViewCell")
        settingsTableview.register(UINib(nibName: "AccountSettingsToggleCell", bundle: nil), forCellReuseIdentifier: "accountSettingsToggleCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logoutTapped(_ sender: AnyObject) {
        NSLog("logout tapped")
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        delegate?.showLoginController()
    }
}

protocol AccountViewControllerDelegate {
    func showLoginController()
    
}
