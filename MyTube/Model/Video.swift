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
    //title, number_of_views, thumbnail_image_name, channel, duration
    var thumbnailImageName: String?
    //var thumbnail_image_name: String?
    var title: String?
    var numberOfViews: Int?
    //var number_of_views: Int?
    //var uploadDate: Date?
    var duration: Int?
    
    var channel: Channel?
}

//MARK: snake_case to camelCase
private enum CodingKeys: String, CodingKey {
    case numberOfViews = "number_of_views"
    case thumbnailImageName = "thumbnail_image_name"
    case title, duration, channel
}
