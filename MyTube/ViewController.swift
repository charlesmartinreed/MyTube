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
    
    func setupViews() {
        addSubview(thumbnailImageView)
        addSubview(seperatorView)
        
        //MARK:- Example of using Apple's Visual Format
        //16 px left and right, content spans across
        //16 px top and bottom, content spans across
        //separator spans the entire width, should be 1 px tall and touch bottom edge
        
        addConstraintWithFormat(format: "H:|-16-[v0]-16-|", views: thumbnailImageView)
        addConstraintWithFormat(format: "V:|-16-[v0]-16-[v1(1)]|", views: thumbnailImageView, seperatorView)
        addConstraintWithFormat(format: "H:|[v0]|", views: seperatorView)
        //thumbnailImageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
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
