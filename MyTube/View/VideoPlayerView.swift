//
//  VideoPlayerView.swift
//  MyTube
//
//  Created by Charles Martin Reed on 2/17/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    //MARK:- Properties
    let activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    let controlsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        return view
    }()
    
    let videoLengthLabel: UILabel = {
       let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let videoSlider: UISlider = {
       let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = .white
        slider.setThumbImage(#imageLiteral(resourceName: "thumb"), for: .normal)
        return slider
    }()
    
    lazy var pausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        let image = #imageLiteral(resourceName: "pause")
        button.setImage(image, for: .normal)
        button.isHidden = true
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        
        return button
    }()
    
    var player: AVPlayer?
    var videoIsPlaying = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupPlayerView()
        
        //place controls in the view
        controlsContainerView.frame = frame
        addSubview(controlsContainerView)
        
        setupActivityViewConstraints()
        setupPauseButtonConstraints()
        setupVideoLabelConstraints()
        setupSliderConstraints()
        
        backgroundColor = .black
    }
    
    private func setupPlayerView() {
        let urlString = "https://firebasestorage.googleapis.com/v0/b/gameofchats-762ca.appspot.com/o/message_movies%2F12323439-9729-4941-BA07-2BAE970967C7.mov?alt=media&token=3e37a093-3bc8-410f-84d3-38332af9c726"
        if let url = URL(string: urlString) {
            //make URL out of string, create a player using that URL, add a playerLayer for rendering video, add that layer to the VideoPlayerView.
            player = AVPlayer(url: url)
            let playerLayer = AVPlayerLayer(player: player)
            self.layer.addSublayer(playerLayer)
            
            //set the playerLayer's frame to make it visible and start the player
            playerLayer.frame = self.frame
            player?.play()
            
            //MARK:- Observer for video player
            //keyPath
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //if the currentItem has a loaded time range, we know it has loaded and player is ready/rendering frames
        if keyPath == "currentItem.loadedTimeRanges" {
            videoIsPlaying = true
            //this automatically hides the spinner
            activityIndicatorView.stopAnimating()
            //this hides our controls and has the benefit of also obscuring the spinner view in the milliseconds before it is hidden by the stopAnimating call
            controlsContainerView.backgroundColor = .clear
            pausePlayButton.isHidden = false
            
            //MARK:-Get position/duration of video, update labels
            guard let duration = player?.currentItem?.duration else { return }
            let seconds = CMTimeGetSeconds(duration)
            
            let secondsText = Int(seconds.truncatingRemainder(dividingBy: 60))
            let minutesText = Int(seconds / 60)
            videoLengthLabel.text = "\(minutesText):\(secondsText)"
        }
    }
    
    //MARK:- Constraint functions
    private func setupActivityViewConstraints() {
        controlsContainerView.addSubview(activityIndicatorView)
        
        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        activityIndicatorView.startAnimating()
    }
    
    private func setupPauseButtonConstraints() {
        controlsContainerView.addSubview(pausePlayButton)
        
        let constraints: [NSLayoutConstraint] = [
            pausePlayButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            pausePlayButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            pausePlayButton.widthAnchor.constraint(equalToConstant: 50),
            pausePlayButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupVideoLabelConstraints() {
        controlsContainerView.addSubview(videoLengthLabel)
        
        let constraints: [NSLayoutConstraint] = [
            videoLengthLabel.trailingAnchor.constraint(equalTo: controlsContainerView.trailingAnchor, constant: -8),
            videoLengthLabel.bottomAnchor.constraint(equalTo: controlsContainerView.bottomAnchor),
            videoLengthLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 60),
            videoLengthLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 24)
            ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupSliderConstraints() {
        controlsContainerView.addSubview(videoSlider)
        
        let constraints: [NSLayoutConstraint] = [
            videoSlider.trailingAnchor.constraint(equalTo: videoLengthLabel.leadingAnchor, constant: -8),
            videoSlider.bottomAnchor.constraint(equalTo: controlsContainerView.bottomAnchor),
            videoSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            videoSlider.heightAnchor.constraint(equalToConstant: 30),
            videoSlider.centerYAnchor.constraint(equalTo: videoLengthLabel.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    //MARK:- Action Handler function
    @objc func handlePause() {
        if videoIsPlaying {
            player?.pause()
            pausePlayButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        } else {
            player?.play()
            pausePlayButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }
        
        videoIsPlaying.toggle()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
