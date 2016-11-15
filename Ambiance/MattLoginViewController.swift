//
//  ViewController.swift
//  Ambiance
//
//  Created by Matthew Carroll on 11/6/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit

class MattLoginViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSLog("HELLO?")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onGoToMainTap(_ sender: AnyObject) {
        let mainStoryboard = UIStoryboard(name: "Infrastructure", bundle: nil)
        let mainVc = mainStoryboard.instantiateViewController(withIdentifier: "main")
        self.present(mainVc, animated: true, completion: nil)
    }
}

