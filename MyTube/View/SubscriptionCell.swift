//
//  SubscriptionCell.swift
//  MyTube
//
//  Created by Charles Martin Reed on 2/16/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit

class SubscriptionCell: FeedCell {
    override func fetchVideos() {
        APIService.sharedInstance.fetchSubscriptionFeed { (videos: [Video]) in
            self.retrievedVideos = videos
            self.collectionView.reloadData()
        }
    }
}
