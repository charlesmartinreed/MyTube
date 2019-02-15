//
//  SettingsCell.swift
//  MyTube
//
//  Created by Charles Martin Reed on 2/14/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit

class SettingsCell: BaseCell {
    
    var setting: Setting? {
        didSet {
            guard let name = setting?.name else { return }
            guard let imageName = setting?.imageName else { return }
            
            nameLabel.text = name
            imageView.image = UIImage(named: imageName)
        }
    }
    
    let nameLabel: UILabel = {
       let label = UILabel()
        label.text = "Setting"
        return label
    }()
    
    let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "settings")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(nameLabel)
        addSubview(imageView)
        
        //image view should always be 30x30
        addConstraintWithFormat(format: "H:|-16-[v0(30)]-8-[v1]|", views: imageView, nameLabel)
        addConstraintWithFormat(format: "V:|[v0]|", views: nameLabel)
        
        //place the image view in the middle of the cell
        addConstraintWithFormat(format: "V:[v0(30)]", views: imageView)
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        
    }
}
