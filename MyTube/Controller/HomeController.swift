//
//  ViewController.swift
//  MyTube
//
//  Created by Charles Martin Reed on 2/7/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController {
    
    //MARK:- Properties
    var retrievedVideos: [Video]?
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.title = "Home"
        navigationController?.navigationBar.isTranslucent = false
        
        //MARK: Title label for nav
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)) //top left 
        titleLabel.text = "Home"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
     
        collectionView.backgroundColor = UIColor.white
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: "cellId")
        
        //fixes for menu bar collectionView bar being placed behind the nav and content scrolling behind them
        collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        setupMenuBar()
        setupNavBarButtons()
        fetchVideos()
        
    }
    
    func fetchVideos() {
        let jsonURLString = "https://s3-us-west-2.amazonaws.com/youtubeassets/home.json"
        guard let url = URL(string: jsonURLString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let err = error {
                print(err.localizedDescription)
            }
            
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let videos = try decoder.decode([Video].self, from: data)
                self.initializeVideoCollection(videos: videos)
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch let jsonError {
                print("Serialization error", jsonError)
            }
        }.resume()
    }
    
    func initializeVideoCollection(videos: [Video]) {
        retrievedVideos = [Video]()
        
        for video in videos {
            //title, number_of_views, thumbnail_image_name, channel, duration
            if let title = video.title, let views = video.numberOfViews, let image = video.thumbnailImageName, let channel = video.channel, let duration = video.duration {
                let vid = Video(thumbnailImageName: image, title: title, numberOfViews: views, duration: duration, channel: channel)
                retrievedVideos?.append(vid)
            }
        }
    }
   
    
    func setupNavBarButtons() {
        let searchImage = #imageLiteral(resourceName: "search_icon").withRenderingMode(.alwaysOriginal)
        let searchBarButton = UIBarButtonItem(image: searchImage, landscapeImagePhone: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        
        let moreImage = #imageLiteral(resourceName: "nav_more_icon").withRenderingMode(.alwaysOriginal)
        let moreBarButton = UIBarButtonItem(image: moreImage, landscapeImagePhone: moreImage, style: .plain, target: self, action: #selector(handleMore))
        
        //interestingly enough, to get moreBarButton behind searchBarButton, it has to have an earlier index
        navigationItem.rightBarButtonItems = [moreBarButton, searchBarButton]
    }
    
    //MARK: Transition to settings screens
    func showControllerFor(setting: Setting) {
        
        let dummySettingsViewController = UIViewController()
        dummySettingsViewController.navigationItem.title = setting.name
        dummySettingsViewController.view.backgroundColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor.white
        
        let navTitleTextAtributes: [NSAttributedString.Key : Any] = [
            .foregroundColor : UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = navTitleTextAtributes
        
        navigationController?.pushViewController(dummySettingsViewController, animated: true)
    }
    
    let menuBar: MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    
    //MARK:- Setup methods
    private func setupMenuBar() {
        view.addSubview(menuBar)
        view.addConstraintWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintWithFormat(format: "V:|[v0(50)]", views: menuBar)
    }
    
    //MARK:- Nav bar handler methods
    @objc func handleSearch() {
    
    }
    
    //using lazy var means the code is executed only once, when the variable is nil.
    lazy var settingsLauncher: SettingsLauncher = {
        let launcher = SettingsLauncher()
        launcher.homeController = self
        return launcher
    }()
    
    @objc func handleMore() {
        settingsLauncher.showSettings()
    }
  
}

extension HomeController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return retrievedVideos?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! VideoCell
        
        cell.video = retrievedVideos?[indexPath.item]
        
        return cell
    }
    
    //MARK:- Minimum line spacing for collection cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension HomeController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //to maintain a 16:9 ratio, we'll take the frame width, minus the padding constraints on either side and multiply by the 16:9 ratio
        //height + 16 (top constraint) + 68 (aggregate padding, labels, etc)
        let height = (view.frame.width - 16 - 16) * ( 9 / 16)
        return CGSize(width: view.frame.width, height: height + 16 + 88)
    }
}


