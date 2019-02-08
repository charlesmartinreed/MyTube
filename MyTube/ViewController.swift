//
//  ViewController.swift
//  MyTube
//
//  Created by Charles Martin Reed on 2/7/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Home"
        collectionView.backgroundColor = UIColor.white
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: "cellId")
    }
    
}

extension HomeController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
        
        return cell
    }
    
    //MARK:- Minimum line spacing for collection cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension HomeController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
}

class VideoCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    //each cell has a thumbnail image
    let thumbnailImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.backgroundColor = UIColor.blue
        
        return imageView
    }()
    
    let seperatorView: UIView = {
        let seperator = UIView()
        seperator.backgroundColor = UIColor.black
        
        return seperator
    }()
    
    let profileImageView: UIView = {
        let profile = UIView()
        profile.backgroundColor = UIColor.green
        
        return profile
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.purple
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let subtitleTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor.red
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    func setupViews() {
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
        addConstraintWithFormat(format: "V:|-16-[v0]-8-[v1(44)]-16-[v2(1)]|", views: thumbnailImageView, profileImageView, seperatorView)
        
        //titleLabel constraints
        titleLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 8).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 0).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        //subtitleTextView constraints
        subtitleTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        subtitleTextView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8).isActive = true
        subtitleTextView.trailingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 0).isActive = true
        subtitleTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Could not initialize new video cell")
    }
}

extension UIView {
    func addConstraintWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    
}
