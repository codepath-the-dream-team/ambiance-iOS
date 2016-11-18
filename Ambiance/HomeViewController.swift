//
//  ViewController.swift
//  Ambiance
//
//  Created by Ryan Chee on 11/12/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit
import AFNetworking
import Parse

class HomeViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    var profileImageURL: URL?
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = User.currentUser
        print("\(user)")
        print("\(user?.firstName!)")
        print("\(user?.lastName!)")
        print("\(user?.email!)")
        print("\(user?.profileImageURL!)")
        profileImageView.setImageWith((user?.profileImageURL!)!)
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
