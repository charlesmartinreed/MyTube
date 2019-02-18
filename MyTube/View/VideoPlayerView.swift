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
    
    let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var videoSlider: UISlider = {
       let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = .white
        slider.setThumbImage(#imageLiteral(resourceName: "thumb"), for: .normal)
        
        //used to scrub video
        slider.addTarget(self, action: #selector(handleSliderChanged), for: .valueChanged)
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

        setupGradientLayer()
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
            
            //MARK:- Observers for video player
            
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
            
            //track progress of playback
            let interval = CMTime(value: 1, timescale: 2)
            player?.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: { (progressTime) in
                //use progressTime to determine value of our labels
                let seconds = CMTimeGetSeconds(progressTime)
                let secondsString = String(format: "%02d", Int(seconds.truncatingRemainder(dividingBy: 60)))
                let minutesString = String(format: "%02d", Int(seconds / 60))
                self.currentTimeLabel.text = "\(minutesString):\(secondsString)"
                
                //move slider thumb to reflect updated seconds
                //slider value = current Play time / duration of clip
                if let duration = self.player?.currentItem?.duration {
                    let durationSeconds = CMTimeGetSeconds(duration)
                    self.videoSlider.value = Float(seconds / durationSeconds)
                }
                
            })
        }
    }
    
    private func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        //need a frame to reveal the gradient
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.clear, UIColor.black].map({$0.cgColor})
        gradientLayer.locations = [0.7, 1.2] //black layer should start near the bottom
        
        //add to the container view for controls
        controlsContainerView.layer.addSublayer(gradientLayer)
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
            let minutesText = String(format: "%02d", Int(seconds / 60))
        
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
        controlsContainerView.addSubview(currentTimeLabel)
        
        let currentLabelConstraints: [NSLayoutConstraint] = [
            currentTimeLabel.leadingAnchor.constraint(equalTo: controlsContainerView.leadingAnchor, constant: 8),
            currentTimeLabel.bottomAnchor.constraint(equalTo: controlsContainerView.bottomAnchor),
            currentTimeLabel.widthAnchor.constraint(equalToConstant: 50),
            currentTimeLabel.heightAnchor.constraint(equalToConstant: 24),
            currentTimeLabel.centerYAnchor.constraint(equalTo: videoLengthLabel.centerYAnchor)
        ]
        
        let lengthLabelConstraints: [NSLayoutConstraint] = [
            videoLengthLabel.trailingAnchor.constraint(equalTo: controlsContainerView.trailingAnchor, constant: -8),
            videoLengthLabel.bottomAnchor.constraint(equalTo: controlsContainerView.bottomAnchor),
            videoLengthLabel.widthAnchor.constraint(equalToConstant: 50),
            videoLengthLabel.heightAnchor.constraint(equalToConstant: 60),
        ]
        
        NSLayoutConstraint.activate(currentLabelConstraints)
        NSLayoutConstraint.activate(lengthLabelConstraints)
    }
    
    private func setupSliderConstraints() {
        controlsContainerView.addSubview(videoSlider)
        
        let constraints: [NSLayoutConstraint] = [
            videoSlider.trailingAnchor.constraint(equalTo: videoLengthLabel.leadingAnchor, constant: -4),
            videoSlider.bottomAnchor.constraint(equalTo: controlsContainerView.bottomAnchor),
            videoSlider.leadingAnchor.constraint(equalTo: currentTimeLabel.trailingAnchor, constant: 4),
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
    
    @objc func handleSliderChanged() {
        
        //timescale is the base, value is the multiplier. value: 10, timescale: 1 would scrub to 10 seconds.
        //value for our use case is based on slider value
        
        if let duration = player?.currentItem?.duration {
            
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(videoSlider.value) * totalSeconds
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            
            player?.seek(to: seekTime, completionHandler: { (completedSeek) in
                //later
            
            })
        }
        
//        if let currentTime = player?.currentItem?.currentTime() {
//            let elapsedSeconds = CMTimeGetSeconds(currentTime)
//            let value = Float64(videoSlider.value)
//        }
        
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
