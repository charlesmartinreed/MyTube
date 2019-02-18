//
//  VideoLauncher.swift
//  MyTube
//
//  Created by Charles Martin Reed on 2/17/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit

class VideoLauncher {
    func showVideoPlayer() {
        print("Displaying video player")
        
        //add view inside the app's key window to grab
        if let keyWindow = UIApplication.shared.keyWindow {
            let view = UIView(frame: keyWindow.frame)
            view.backgroundColor = .white
            
            
            //animate from lower right to top left by specifying a beginning and ending frame for our animation
            view.frame = CGRect(x: keyWindow.frame.width - 10, y: keyWindow.frame.height - 10, width: 10, height: 10)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                view.frame = keyWindow.frame
            }) { (completedAnimation) in
                //useful?
            }
            
            
            keyWindow.addSubview(view)
            
            
        }
        
    }
}
