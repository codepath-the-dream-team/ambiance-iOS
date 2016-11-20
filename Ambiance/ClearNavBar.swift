//
//  ClearNavBar.swift
//  Ambiance
//
//  Created by Matthew Carroll on 11/19/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import Foundation
import UIKit

// Protocol Extension that can be applied to a Class that wants the ability
// to give a UINavigationBar a clear background.
//
// A Protocol Extension was chosen so that a Class could optionally obtain
// this behavior without requiring a specific inheritance hierarchy, and without
// needing to instantiate a special object specifically for this task.
protocol ClearNavBar {
    
}

extension ClearNavBar {
    
    func clearBackground(forNavBar navBar: UINavigationBar) {
        navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navBar.shadowImage = UIImage()
        navBar.backgroundColor = UIColor.clear
    }
    
}
