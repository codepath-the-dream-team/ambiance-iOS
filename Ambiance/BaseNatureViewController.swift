//
//  BaseNatureViewController.swift
//  Ambiance
//
//  Created by Matthew Carroll on 11/20/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit

class BaseNatureViewController: UIViewController {

    private var blurEffectView: UIVisualEffectView!
    private var blurEffect: UIVisualEffect!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        prepareBlurEffect()
        getModalTopConstraint().constant = self.view.bounds.height
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getContentContainer() -> UIView! {
        return nil
    }
    
    func getContentTopConstraint() -> NSLayoutConstraint! {
        return nil
    }
    
    func getModalContainer() -> UIView! {
        return nil
    }
    
    func getModalTopConstraint() -> NSLayoutConstraint! {
        return nil
    }

    private func prepareBlurEffect() {
        blurEffectView = UIVisualEffectView()
        blurEffectView.frame = getContentContainer().bounds
        //        blurEffectView.alpha = 0.8
        
        blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
    }
    
    func setContent(vc: UIViewController) {
        addChildViewController(vc)
        vc.willMove(toParentViewController: self)
        vc.view.frame = getContentContainer().bounds
        getContentContainer().addSubview(vc.view)
        vc.didMove(toParentViewController: self)
    }

    func setModal(vc: UIViewController) {
        addChildViewController(vc)
        vc.willMove(toParentViewController: self)
        vc.view.frame = getModalContainer().bounds
        getModalContainer().addSubview(vc.view)
        vc.didMove(toParentViewController: self)
    }
    
    func displayModal() {
        NSLog("Displaying modal")
        
        // Add the blur effect view to the layout hierarchy so we can blur the content UI.
        getContentContainer().addSubview(blurEffectView)
        
        // Calculate the final position of the modal UI.
        let finalPosition = self.view.bounds.height - getModalContainer().bounds.height
        
        // Animate the modal UI in while also blurring the content UI.
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5) {
            self.getContentTopConstraint().constant = -100
            self.getModalTopConstraint().constant = finalPosition
            self.view.layoutIfNeeded()
            
            self.blurEffectView.effect = self.blurEffect
        }
    }
    
    func closeModal() {
        NSLog("Hiding modal")
        
        // Calculate the final position of the modal UI.
        let finalPosition = self.view.bounds.height
        
        // Animate the modal UI out while also un-blurring the content UI.
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, animations: {
            self.getContentTopConstraint().constant = 0
            self.getModalTopConstraint().constant = finalPosition
            self.view.layoutIfNeeded()
            
            self.blurEffectView.effect = nil
        }) { (Bool) in
            self.blurEffectView.removeFromSuperview()
        }
    }
}
