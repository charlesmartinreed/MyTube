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
    var videos: [Video] = {
        var kanyeChannel = Channel()
        kanyeChannel.name = "KanyeIsTheGOATChannel"
        kanyeChannel.profileImageName = "kanye_profile"
        
       var blankSpaceVideo = Video()
        blankSpaceVideo.title = "Taylor Swift - Blank Space"
        blankSpaceVideo.thumbnailImageName = "taylor_swift_blank_space"
        blankSpaceVideo.channel = kanyeChannel
        blankSpaceVideo.numberOfViews = 2_398_430_125
        
        var badBloodVideo = Video()
        badBloodVideo.title = "Taylor Swift ft. Kendrick Lamar - Bad Blood"
        badBloodVideo.thumbnailImageName = "taylor_swift_bad_blood"
        badBloodVideo.channel = kanyeChannel
        badBloodVideo.numberOfViews = 1_502_295_391
        
        
        return [blankSpaceVideo, badBloodVideo]
    }()
    
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
    }
    
    func setupNavBarButtons() {
        let searchImage = #imageLiteral(resourceName: "search_icon").withRenderingMode(.alwaysOriginal)
        let searchBarButton = UIBarButtonItem(image: searchImage, landscapeImagePhone: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        
        let moreImage = #imageLiteral(resourceName: "nav_more_icon").withRenderingMode(.alwaysOriginal)
        let moreBarButton = UIBarButtonItem(image: moreImage, landscapeImagePhone: moreImage, style: .plain, target: self, action: #selector(handleMore))
        
        //interestingly enough, to get moreBarButton behind searchBarButton, it has to have an earlier index
        navigationItem.rightBarButtonItems = [moreBarButton, searchBarButton]
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
    
    //MARK:- Nav bar methods
    @objc func handleSearch() {
    
    }
    
    @objc func handleMore() {
        
    }
}



extension HomeController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! VideoCell
        
        cell.video = videos[indexPath.item]
        
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
        return CGSize(width: view.frame.width, height: height + 16 + 68)
    }
}


