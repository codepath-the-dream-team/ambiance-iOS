//
//  SleepConfigureViewController.swift
//  Ambiance
//
//  Created by Matthew Carroll on 11/20/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit

class SleepConfigureViewController: UIViewController, ClearNavBar {

    @IBOutlet var navBar: UINavigationBar!
    
    public var delegate: SleepConfigureViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        clearBackground(forNavBar: navBar)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onDoneTap(_ sender: AnyObject) {
        delegate?.doneWithSleepConfiguration()
    }
    
}

protocol SleepConfigureViewControllerDelegate {
    
    // TODO: pass configuration back
    func doneWithSleepConfiguration()
    
}
