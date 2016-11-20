//
//  WakeUpEditViewController.swift
//  Ambiance
//
//  Created by Matthew Carroll on 11/19/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit

class WakeUpEditViewController: UIViewController {

    public var delegate: WakeUpEditViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onDoneTap(_ sender: AnyObject) {
        delegate?.saveEdit()
    }
    
    @IBAction func onCancelTap(_ sender: AnyObject) {
        delegate?.cancelEdit()
    }
}

protocol WakeUpEditViewControllerDelegate {
    
    // TODO: add configuration model parameter
    func saveEdit()
    
    func cancelEdit()
    
}
