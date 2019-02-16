//
//  SettingsCell.swift
//  MyTube
//
//  Created by Charles Martin Reed on 2/14/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit

class SettingsCell: BaseCell {
    
    override var isHighlighted: Bool {
        didSet {
            //toggled between true and false with each click
            backgroundColor = isHighlighted ? UIColor.darkGray : UIColor.white
            nameLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            imageView.tintColor = isHighlighted ? UIColor.white : UIColor.darkGray
        }
    }
    
    var setting: Setting? {
        didSet {
            guard let name = setting?.name else { return }
            guard let imageName = setting?.imageName else { return }
            
            nameLabel.text = name.rawValue
            imageView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = .darkGray
        }
    }
    
    let nameLabel: UILabel = {
       let label = UILabel()
        label.text = "Setting"
        label.font = UIFont.systemFont(ofSize: 13)
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
