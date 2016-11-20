//
//  SleepViewController.swift
//  Ambiance
//
//  Created by Matthew Carroll on 11/20/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit

class SleepViewController: UIViewController, ClearNavBar {

    @IBOutlet var sleepSynopsisView: SleepSynopsisView!
    
    public var delegate: SleepViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        applyPurpleBackground()
        
        clearBackground(forNavBar: navigationController!.navigationBar)
        
        sleepSynopsisView.viewModel = SleepSynopsisViewModel(hours: 2, minutes: 30, alexaCommand: "Alexa, good night", ambianceTitle: "Babbling Brook")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSleepSynopsisTap(_ sender: UITapGestureRecognizer) {
        NSLog("Sleep Synopsis tapped.")
        delegate?.showSleepConfiguration()
    }

    private func applyPurpleBackground() {
        let bkColorTop = Palette.purpleDark
        let bkColorBottom = Palette.purpleLight
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [bkColorTop.cgColor, bkColorBottom.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

protocol SleepViewControllerDelegate {
    
    func showSleepConfiguration()
    
}
