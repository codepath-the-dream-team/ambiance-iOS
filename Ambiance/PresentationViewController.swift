//
//  PresentationViewController.swift
//  Ambiance
//
//  Created by Matthew Carroll on 12/6/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit
import EZSwipeController

class PresentationViewController: EZSwipeController, EZSwipeControllerDataSource, ClearNavBar {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        clearBackground(forNavBar: navigationController!.navigationBar)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // From EZSwipeController
    override func setupView() {
        self.datasource = self
        self.navigationBarShouldNotExist = true
    }
    
    // From EZSwipeControllerDataSource
    func viewControllerData() -> [UIViewController] {
        let storyboard = UIStoryboard(name: "Presentation", bundle: nil)
        
        let slide1Vc = storyboard.instantiateViewController(withIdentifier: "slide1")
        
        let slide2Vc = storyboard.instantiateViewController(withIdentifier: "slide2")
        
        let slide3Vc = storyboard.instantiateViewController(withIdentifier: "slide3")
        
        return [slide1Vc, slide2Vc, slide3Vc]
    }
    

}
