//
//  Video.swift
//  MyTube
//
//  Created by Charles Martin Reed on 2/13/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit

struct Video: Decodable {
    //object that tells the cell view what to render
    var thumbnailImageName: String?
    var title: String?
    var numberOfViews: Int?
    var duration: Int?
    var channel: Channel?
    
    init(thumbnailImageName: String?, title: String?, numberOfViews: Int?, duration: Int?, channel: Channel?) {
        self.thumbnailImageName = thumbnailImageName
        self.title = title
        self.numberOfViews = numberOfViews
        self.duration = duration
        self.channel = channel
    }
    
    
}

//MARK: snake_case to camelCase
private enum CodingKeys: String, CodingKey {
    case numberOfViews = "number_of_views"
    case thumbnailImageName = "thumbnail_image_name"
    case title, duration, channel
}
