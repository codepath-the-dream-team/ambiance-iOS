//
//  WakeUpConfigureViewController.swift
//  Ambiance
//
//  Created by Matthew Carroll on 11/19/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit

class WakeUpConfigureViewController: UIViewController {

    public var delegate: WakeUpConfigureViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onDoneTap(_ sender: AnyObject) {
        delegate?.saveConfiguration()
    }

    @IBAction func onCancelTap(_ sender: AnyObject) {
        delegate?.cancelConfiguration()
    }
    
}

protocol WakeUpConfigureViewControllerDelegate {
    
    // TODO: add configuration model parameter
    func saveConfiguration()
    
    func cancelConfiguration()
    
}
