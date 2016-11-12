//
//  ViewController.swift
//  Ambiance
//
//  Created by Ryan Chee on 11/12/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit
import AFNetworking

class ViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    var profileImageURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let profileImageURL = profileImageURL {
            profileImageView.setImageWith(profileImageURL)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutTapped(_ sender: AnyObject) {
        Utils.logout()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
