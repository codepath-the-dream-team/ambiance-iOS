//
//  ExtUIImageView.swift
//  Ambiance
//
//  Created by Matthew Carroll on 11/19/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    @IBInspectable var imageRenderingMode: Int {
        get {
            let renderingMode = image?.renderingMode
            
            if let renderingMode = renderingMode {
                switch (renderingMode) {
                case .automatic:
                    return 0
                case .alwaysOriginal:
                    return 1
                case .alwaysTemplate:
                    return 2
                }
            } else {
                return 0
            }
        }
        set {
            var renderingMode: UIImageRenderingMode = UIImageRenderingMode.automatic
            switch (newValue) {
            case 0:
                renderingMode = UIImageRenderingMode.automatic
                break
            case 1:
                renderingMode = UIImageRenderingMode.alwaysOriginal
                break
            case 2:
                renderingMode = UIImageRenderingMode.alwaysTemplate
                break
            default:
                renderingMode = UIImageRenderingMode.automatic
                break
            }
            
            image = image?.withRenderingMode(renderingMode)
        }
    }
    
}
