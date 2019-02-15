//
//  SettingsLauncher.swift
//  MyTube
//
//  Created by Charles Martin Reed on 2/14/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit

class SettingsLauncher: NSObject {
    
    let blackView = UIView()
    func showSettings() {
        //dimming view - adding on the entire window
        if let window = UIApplication.shared.keyWindow {
            
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            //dismiss the black view when tapped by adding a gesture recognizer
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5) {
                self.blackView.alpha = 1
            }
        }
    }
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
        }
    }
    
    
    override init() {
        super.init()
        //custom stuff goes here
    }
    
}
