//
//  VideoCell.swift
//  MyTube
//
//  Created by Charles Martin Reed on 2/11/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Could not initialize new video cell")
    }
    
}

class VideoCell: BaseCell {
    var video: Video? {
        didSet {
            
            if let title = video?.title {
                titleLabel.text = title
            }
            
            if let thumbnailImageName = video?.thumbnailImageName {
                //setupThumbnailImageFrom(url: thumbnailImageName)
                thumbnailImageView.loadImageUsing(urlString: thumbnailImageName)
            }
            
            if let profileImageName = video?.channel?.profileImageName {
                profileImageView.loadImageUsing(urlString: profileImageName)
                //setupProfileImageFrom(url: profileImageName)
            }
            
            if let channelName = video?.channel?.name, let numberOfViews = video?.numberOfViews {
                
                subtitleTextView.text = "\(channelName) • \(numberOfViews.formattedWithSeparator) • 2 years ago"
            }
            
            //MARK:- Sizing fix for title label
            if let videoTitle = video?.title {
                //size of the text minus constraints and paddings
                let size = CGSize(width: frame.width - 16 - 44 - 8 - 16, height: 1000)
                let estimatedRect = NSString(string: videoTitle).boundingRect(with: size, options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
                
                if estimatedRect.size.height > 20 {
                    titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
                } else {
                    titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
                }
            }
        }
    }
    
    //each cell has a thumbnail image
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "taylor_swift_blank_space")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let seperatorView: UIView = {
        let seperator = UIView()
        seperator.backgroundColor = UIColor(red: 230.0/255, green: 230.0/255, blue: 230.0/255, alpha: 1)
        
        return seperator
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "profile_image")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        imageView.layer.cornerRadius = 22 //half of width/height of frame
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Taylor Swift - Blank Space"
        label.numberOfLines = 0
        
        return label
    }()
    
    let subtitleTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "TaylorSwiftVEVO • 1,604,684,507 views • 2 years"
        //Subtitle label inset fix
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        textView.textColor = UIColor.lightGray
        
        return textView
    }()
    
    //OLD: Fix for line wrap in VideoCell title
    //var titleLabelHeightConstraint: NSLayoutConstraint?
    
    override func setupViews() {
        addSubview(thumbnailImageView)
        addSubview(seperatorView)
        addSubview(profileImageView)
        addSubview(titleLabel)
        addSubview(subtitleTextView)
        
        //MARK:- Horizontal constraints
        addConstraintWithFormat(format: "H:|-16-[v0]-16-|", views: thumbnailImageView)
        addConstraintWithFormat(format: "H:|[v0]|", views: seperatorView)
        addConstraintWithFormat(format: "H:|-16-[v0(44)]", views: profileImageView)
        
        //MARK:- Vertical constraints
        addConstraintWithFormat(format: "V:|-16-[v0]-8-[v1(44)]-36-[v2(1)]|", views: thumbnailImageView, profileImageView, seperatorView)
        
        //titleLabel constraints
        titleLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 8).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 0).isActive = true
        
        
        //subtitleTextView constraints
        subtitleTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2).isActive = true
        subtitleTextView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8).isActive = true
        subtitleTextView.trailingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 0).isActive = true
        subtitleTextView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
    }

}
