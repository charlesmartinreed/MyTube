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
    let cellId = "cellId"
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Home"
        navigationController?.navigationBar.isTranslucent = false
        
        //MARK: Title label for nav
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)) //top left 
        titleLabel.text = "  Home"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
     
        setupCollectionView()
        setupMenuBar()
        setupNavBarButtons()
        fetchVideos()
        
    }
    
    func setupCollectionView() {
        //setting up horizontal scroll for collectionView
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0 //fix scroll gap
        }
        
        collectionView.backgroundColor = UIColor.white
//        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        //fixes for menu bar collectionView bar being placed behind the nav and content scrolling behind them
        collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
        //MARK:- Snap view when scrolling
        collectionView.isPagingEnabled = true
    }
    
    func fetchVideos() {
        APIService.sharedInstance.fetchVideos { (videos: [Video]) in
            self.retrievedVideos = videos
            self.collectionView.reloadData()
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
        dummySettingsViewController.navigationItem.title = setting.name.rawValue
        dummySettingsViewController.view.backgroundColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor.white
        
        let navTitleTextAtributes: [NSAttributedString.Key : Any] = [
            .foregroundColor : UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = navTitleTextAtributes
        
        navigationController?.pushViewController(dummySettingsViewController, animated: true)
    }
    
    //here, lazy var allows us to use self
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.homeController = self
        return mb
    }()
    
    //MARK:- Setup methods
    private func setupMenuBar() {
        navigationController?.hidesBarsOnSwipe = true
        
        //redView is a shim to prevent a visible gap when the menu bar shifts upward as the nav is hidden on swipe
        let redView = UIView()
        redView.backgroundColor = UIColor.rgb(red: 230, green: 32, blue: 31, alpha: 1)
        view.addSubview(redView)
        view.addConstraintWithFormat(format: "H:|[v0]|", views: redView)
        view.addConstraintWithFormat(format: "V:[v0(50)]", views: redView)
        
        view.addSubview(menuBar)
        view.addConstraintWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintWithFormat(format: "V:[v0(50)]", views: menuBar)
        
        //since the menu bar is being hidden on scroll, this will move the bar up beneath the status bar
        menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    //MARK:- Nav bar handler methods
    @objc func handleSearch() {
        scrollToMenuIndex(2)
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
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return retrievedVideos?.count ?? 0
//    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        let colors: [UIColor] = [.blue, .orange, .yellow, .green]
        cell.backgroundColor = colors[indexPath.item]
        
        return cell
    }
    
    func scrollToMenuIndex(_ menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
       collectionView.scrollToItem(at: indexPath, at: [], animated: true)
    }
    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! VideoCell
//
//        cell.video = retrievedVideos?[indexPath.item]
//
//        return cell
//    }
    
    //MARK:- Minimum line spacing for collection cells
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
}

extension HomeController : UICollectionViewDelegateFlowLayout {
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        //to maintain a 16:9 ratio, we'll take the frame width, minus the padding constraints on either side and multiply by the 16:9 ratio
//        //height + 16 (top constraint) + 68 (aggregate padding, labels, etc)
//        let height = (view.frame.width - 16 - 16) * ( 9 / 16)
//        return CGSize(width: view.frame.width, height: height + 16 + 88)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //MARK:- Translate the x value for cell
        menuBar.horizontalBarLeadingConstraint?.constant = scrollView.contentOffset.x / 4
    }
    
}


