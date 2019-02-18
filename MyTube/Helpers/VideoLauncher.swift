//
//  VideoLauncher.swift
//  MyTube
//
//  Created by Charles Martin Reed on 2/17/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        let urlString = "https://firebasestorage.googleapis.com/v0/b/gameofchats-762ca.appspot.com/o/message_movies%2F12323439-9729-4941-BA07-2BAE970967C7.mov?alt=media&token=3e37a093-3bc8-410f-84d3-38332af9c726"
        if let url = URL(string: urlString) {
            //make URL out of string, create a player using that URL, add a playerLayer for rendering video, add that layer to the VideoPlayerView.
            let player = AVPlayer(url: url)
            let playerLayer = AVPlayerLayer(player: player)
            self.layer.addSublayer(playerLayer)
            
            //set the playerLayer's frame to make it visible and start the player
            playerLayer.frame = self.frame
            player.play()
        }
        
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

class VideoLauncher {
    let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
    
    func showVideoPlayer() {
        print("Displaying video player")
        
        //add view inside the app's key window to grab
        if let keyWindow = UIApplication.shared.keyWindow {
            let view = UIView(frame: keyWindow.frame)
            view.backgroundColor = .white
            
            //add the player view into the keyWindowFrame
            let frameHeight = keyWindow.frame.width * (9/16) //aspect ratio for HD videos
            let videoPlayerFrame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: frameHeight)
            let videoPlayerView = VideoPlayerView(frame: videoPlayerFrame)
            view.addSubview(videoPlayerView)
            
            
            //animate from lower right to top left by specifying a beginning and ending frame for our animation
            view.frame = CGRect(x: keyWindow.frame.width - 10, y: keyWindow.frame.height - 10, width: 10, height: 10)
            keyWindow.addSubview(view)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                view.frame = keyWindow.frame
            }) { (completedAnimation) in
                //hide the status bar
                self.statusBar.isHidden = true
            }
        }
    }
    
    
    
}
