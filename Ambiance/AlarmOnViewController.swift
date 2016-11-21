//
//  AlarmOnViewController.swift
//  Ambiance
//
//  Created by Chihiro Saito on 11/20/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit

class AlarmOnViewController: UIViewController, ClearNavBar {

    @IBOutlet weak var circularView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var amPmLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addCircle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addCircle() {
        
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
