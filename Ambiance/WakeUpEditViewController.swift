//
//  WakeUpEditViewController.swift
//  Ambiance
//
//  Created by Matthew Carroll on 11/19/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit

class WakeUpEditViewController: UIViewController, ClearNavBar {

    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var timePicker: UIDatePicker!
    
    public var delegate: WakeUpEditViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        clearBackground(forNavBar: navBar)
        makeTimePickerGray()
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
    
    private func makeTimePickerGray() {
        timePicker.setValue(Palette.grayLight, forKey: "textColor")
    }
}

protocol WakeUpEditViewControllerDelegate {
    
    // TODO: add configuration model parameter
    func saveEdit()
    
    func cancelEdit()
    
}
