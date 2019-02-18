//
//  APIService.swift
//  MyTube
//
//  Created by Charles Martin Reed on 2/15/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit

class APIService: NSObject {
    
    static let sharedInstance = APIService()
    private let baseURL = "https://s3-us-west-2.amazonaws.com/youtubeassets"
    
    func fetchVideos(completion: @escaping ([Video]) -> ()) {
        fetchFeedFor(urlString: "\(baseURL)/home.json", completion: completion)
    }
    
    func fetchTrendingFeed(completion: @escaping ([Video]) -> ()) {
        fetchFeedFor(urlString: "\(baseURL)/trending.json", completion: completion)
    }
    
    func fetchSubscriptionFeed(completion: @escaping ([Video]) -> ()) {
        fetchFeedFor(urlString: "\(baseURL)/subscriptions.json", completion: completion)
    }
    
    fileprivate func fetchFeedFor(urlString: String, completion: @escaping ([Video]) -> ()) {
        guard let url = URL(string: urlString) else { return }
        
        var videos = [Video]()
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let err = error {
                print(err.localizedDescription)
            }
            
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let retrievedVideos = try decoder.decode([Video].self, from: data)
                for video in retrievedVideos {
                    if let title = video.title, let views = video.numberOfViews, let image = video.thumbnailImageName, let channel = video.channel, let duration = video.duration {
                        let vid = Video(thumbnailImageName: image, title: title, numberOfViews: views, duration: duration, channel: channel)
                        videos.append(vid)
                    }
                }
                
                DispatchQueue.main.async {
                    //self.collectionView.reloadData()
                    completion(videos)
                }
            } catch let jsonError {
                print("Serialization error", jsonError)
            }
            }.resume()
    }
}
