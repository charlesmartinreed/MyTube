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
    let cellId = "cellId"
    let trendingCellId = "trendingCellId"
    let subscriptionCellId = "subscriptionCellId"
    let titles = ["Home", "Trending", "Subscriptions", "Account"]
    
    //here, lazy var allows us to use self
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.homeController = self
        return mb
    }()
    
    //using lazy var means the code is executed only once, when the variable is nil.
    lazy var settingsLauncher: SettingsLauncher = {
        let launcher = SettingsLauncher()
        launcher.homeController = self
        return launcher
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
        titleLabel.text = "  Home"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
     
        setupCollectionView()
        setupMenuBar()
        setupNavBarButtons()
    }
    
    func setupCollectionView() {
        //setting up horizontal scroll for collectionView
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0 //fix scroll gap
        }
        
        collectionView.backgroundColor = .white
        
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(TrendingCell.self, forCellWithReuseIdentifier: trendingCellId)
        collectionView.register(SubscriptionCell.self, forCellWithReuseIdentifier: subscriptionCellId)
        
        //fixes for menu bar collectionView bar being placed behind the nav and content scrolling behind them
        collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
        //MARK:- Snap view when scrolling
        collectionView.isPagingEnabled = true
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
        dummySettingsViewController.view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .white
        
        let navTitleTextAtributes: [NSAttributedString.Key : Any] = [
            .foregroundColor : UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = navTitleTextAtributes
        
        navigationController?.pushViewController(dummySettingsViewController, animated: true)
    }
    

    
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
        
    }
    
    @objc func handleMore() {
        settingsLauncher.showSettings()
    }
    
    private func setTitleForIndex(index: Int) {
        if let titleLabel = navigationItem.titleView as? UILabel {
            titleLabel.text = "  \(titles[index])"
        }
    }
  
}

extension HomeController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.item {
        case 1:
            return collectionView.dequeueReusableCell(withReuseIdentifier: trendingCellId, for: indexPath)
        case 2:
            return collectionView.dequeueReusableCell(withReuseIdentifier: subscriptionCellId, for: indexPath)
        default:
            return collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        }
    }
    
    func scrollToMenuIndex(_ menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
       collectionView.scrollToItem(at: indexPath, at: [], animated: true)
        
        //set the title label
       setTitleForIndex(index: menuIndex)
    }
}

extension HomeController : UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 50)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //MARK:- Translate the x value for cell
        menuBar.horizontalBarLeadingConstraint?.constant = scrollView.contentOffset.x / 4
        
    }
    
    //MARK:- Highlighting the proper menu icon upon scroll
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        //with width and target, we can figure out which menu bar item should be selected
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        
        //MARK:- Change title for section during scroll
        setTitleForIndex(index: Int(index))
    }
    
}


