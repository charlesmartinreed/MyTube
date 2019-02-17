//
//  TrendingCell.swift
//  MyTube
//
//  Created by Charles Martin Reed on 2/16/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit

class TrendingCell: FeedCell {
    override func fetchVideos() {
        APIService.sharedInstance.fetchTrendingFeed { (videos: [Video]) in
            self.retrievedVideos = videos
            self.collectionView.reloadData()
        }
    }
}
