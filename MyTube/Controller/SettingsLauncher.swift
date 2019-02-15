//
//  SettingsLauncher.swift
//  MyTube
//
//  Created by Charles Martin Reed on 2/14/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit

class SettingsLauncher: NSObject {
    
    var homeController: HomeController?
    
    let blackView = UIView()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        
        return cv
    }()
    
    
    let cellId = "cellId"
    let cellHeight: CGFloat = 50
    
    let settingOptions: [Setting] = {
        let setting = Setting(name: "Settings", imageName: "settings")
        let privacy = Setting(name: "Terms and Privacy Policy", imageName: "privacy")
        let feedback = Setting(name: "Send Feedback", imageName: "feedback")
        let help = Setting(name: "Help", imageName: "help")
        let switchAccount = Setting(name: "Switch Account", imageName: "switch_account")
        let cancel = Setting(name: "Cancel", imageName: "cancel")
        
        return [setting, privacy, feedback, help, switchAccount, cancel]
    }()
    
    
    
    func showSettings() {
        //dimming view - adding on the entire window
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            //dismiss the black view when tapped by adding a gesture recognizer
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            window.addSubview(collectionView) //add collection view after blackView since otherwise it'll be BEHIND the black view
            
            let collectionViewHeight: CGFloat = CGFloat(settingOptions.count) * cellHeight
            let y = window.frame.height - collectionViewHeight
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: collectionViewHeight)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            //animate in the transparency layer and the collection view
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }, completion: nil)
        }
    }
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
            
        }
    }
    
    
    override init() {
        super.init()
        
        //custom stuff goes here
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //register the cell
        collectionView.register(SettingsCell.self, forCellWithReuseIdentifier: cellId)
    }
    
}

extension SettingsLauncher: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settingOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingsCell
        cell.setting = settingOptions[indexPath.item]
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            UIView.animate(withDuration: 0.5, animations: {
                self.blackView.alpha = 0
                if let window = UIApplication.shared.keyWindow {
                    self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                }
            }, completion: { (_) in
                //transition to proper settings VC
                let setting = self.settingOptions[indexPath.item]
                self.homeController?.showControllerFor(setting: setting)
            })
        })
    }
}

extension SettingsLauncher: UICollectionViewDelegateFlowLayout {
    
}
