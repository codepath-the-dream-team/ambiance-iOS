//
//  ExtUIColor.swift
//  Ambiance
//
//  Created by Matthew Carroll on 11/19/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static func fromHex(rgb: Int) -> UIColor {
        return UIColor(colorLiteralRed: ((Float)((rgb & 0xFF0000) >> 16)) / 255.0, green: ((Float)((rgb & 0x00FF00) >> 8)) / 255.0, blue: ((Float)((rgb & 0x0000FF) >> 0)) / 255.0, alpha: 1.0)
    }
    
}
