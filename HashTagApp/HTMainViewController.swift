//
//  HTMainViewController.swift
//  HashTagApp
//
//  Created by Keith Caffrey on 28/01/2017.
//  Copyright © 2017 Keith Caffrey. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
import TwitterKit
import InstagramKit
import Kingfisher


class HTMainViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, HTInstagramLoginDelegate {
    
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    private let searchBar:UISearchBar = UISearchBar()
    var searchTimer:Timer?
    var datasource:[Any] = [Any]()
    var isInstagramConnected: Bool = false;
    var twitterSearchMetaData : [String : Any]?
    var instagramSearchMetaData : [String : Any]?
    var busyCell: HTBusyTableViewCell?
    var instagramLoading: Bool = false
    var twitterLoading: Bool = false
    let instagramMetaDataKey = "instagramMetaDataKey"
    let twitterMetaDataKey = "twitterMetaDataKey"
    
    let tweetCellIdentifer = "tweetCell"
    let busyCellIdentifer = "busyCell"
    let instagramImageCellIdentifer = "instagramImageCell"
    let refreshControlTintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
    
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var searchTwitterViewController:HTSearchTwitterViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(HTMainViewController.handleTweetsRetrievedNotification(_ :)), name: .tweetsRetrieved, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HTMainViewController.handleInstagramMediaRetrievedNotification(_ :)), name: .instagramMediaRetrieved, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HTMainViewController.handleInstagramMediaRetrievalFailedNotification(_ :)), name: .instagramMediaRetrievalFailed, object: nil)
        
        registerXibs()
        
        searchBar.delegate = self
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search a hashtag #HURRYUP!"
        self.navigationItem.titleView = self.searchBar
        
        self.navigationController?.isNavigationBarHidden = false
        tableView.delegate = self;
        tableView.dataSource = self;
        searchTwitterViewController = HTSearchTwitterViewController()
        tableView.estimatedRowHeight = 220
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelection = false
        
        // Configure Refresh Control
        let attributes = [ NSForegroundColorAttributeName : refreshControlTintColor ] as [String: Any]
        refreshControl.tintColor = refreshControlTintColor
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching results ...", attributes: attributes)
        refreshControl.addTarget(self, action: #selector(HTMainViewController.fetchMoreData(sender:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        let instaEngine = InstagramEngine.shared()
        if instaEngine.accessToken != nil {
            isInstagramConnected = true;
            self.instagramButton.isHidden = isInstagramConnected;
        }
    }
    
    func registerXibs() {
        tableView.register(UINib(nibName: "HTBusyTableViewCell", bundle: nil), forCellReuseIdentifier: busyCellIdentifer)
        
        tableView.register(TWTRTweetTableViewCell.self, forCellReuseIdentifier:tweetCellIdentifer)
        tableView.register(UINib(nibName: "HTInstagramImageTableViewCell", bundle: nil), forCellReuseIdentifier: instagramImageCellIdentifer)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if let nav = self.navigationController {
//            nav.isNavigationBarHidden = false
//            nav.navigationItem.titleView = self.searchBar
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    @IBAction func instagramButtonTapped(_ sender: Any) {
        if let nav = self.navigationController {
            let instagramLoginVC = self.storyboard?.instantiateViewController(withIdentifier: "instagramLoginVC") as! HTInstagramLoginViewController
            instagramLoginVC.delegate = self
            nav.pushViewController(instagramLoginVC, animated: true)
        }
    }
    
    @IBAction func signOutButtonTapped(_ sender: Any) {
        do {
            try
                FIRAuth.auth()?.signOut()
                AppState.signedOut()
                if let nav = self.navigationController {
                    nav.popToRootViewController(animated: true)// the root vc is the HTSignInViewController
                }
        }
        catch  {
            let alert = UIAlertController(title: "Logout failed",
                                          message: "Unable to logout",
                                          preferredStyle: UIAlertControllerStyle.alert
            )
            self.present(alert, animated: true, completion: nil)
            print ("signOutButtonTapped - sign out failed with \(sender)")
        }
    }
    
    
    @objc private func fetchMoreData(sender: UIRefreshControl) {
        let searchText = getSearchText()
        let hasMetaData = ((twitterSearchMetaData != nil) || (instagramSearchMetaData != nil))
        if (searchText.characters.count >= 2 && hasMetaData) {
            var searchMetaData: [String: Any?]
            searchMetaData = [twitterMetaDataKey:twitterSearchMetaData, instagramMetaDataKey:nil]
            performSearch(searchText, searchMetaData);
        }
        else {
            refreshControl.endRefreshing()
        }
    }
    
    
    func performSearch(_ searchText:String, _ searchMetaData:[String: Any?]) {
        if let twitterMetaData = searchMetaData[twitterMetaDataKey] {
            HTTwitterAPIManager.sharedInstance.searchTwitter(withMetaData: twitterMetaData as! [String : Any?], andQuery: searchText)
        }
    }
    
    func performSearch(_ searchText:String) {
        //clear old search first
        DispatchQueue.main.async { [unowned self] in
            self.datasource =  [Any]()
            self.tableView.reloadData();
            self.twitterSearchMetaData = nil
        }
        self.refreshControl.beginRefreshing();
        HTTwitterAPIManager.sharedInstance.searchTwitter(query: searchText)
        self.twitterLoading = true;
        if(isInstagramConnected) {
            HTInstagramAPIManager.sharedInstance.searchInstagram(tag: searchText)
            self.instagramLoading = true;
        }
    }
    
    func invalidateSearch() {
        self.searchTimer?.invalidate()
        self.twitterSearchMetaData = nil;
        self.twitterLoading = false;
        self.instagramLoading = false;
        refreshControl.endRefreshing();
    }

    // MARK: UISearchBarDelegate methods
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let text = getSearchText()
        if (text.characters.count < 2) {
            if self.searchTimer != nil {
                self.invalidateSearch()
            }
            return
        }
        twitterSearchMetaData = nil;
        DispatchQueue.main.async { [unowned self] in
            if self.searchTimer != nil {
                self.invalidateSearch()
            }
            self.searchTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { (Timer) in
                self.performSearch(text)
            })
        }
    }
    
    private func hasProcessed(twitterResults results:[TWTRTweet]) -> Bool {
        var processedTweetsAlready = true
        var onlyTweets = self.datasource.filter { $0 is TWTRTweet}
        if(onlyTweets.isEmpty) {
            processedTweetsAlready = false
        }
        if(processedTweetsAlready) {
            let topTweet = onlyTweets[0] as! TWTRTweet
            let latestTweetId = results[0].tweetID
            if(topTweet.tweetID.caseInsensitiveCompare(latestTweetId) != ComparisonResult.orderedSame){
                processedTweetsAlready = false
            }
            else {
                print("Processed these tweets already!!")
            }
        }
        return processedTweetsAlready
    }
    
    // MARK: - Notifications
    public func handleTweetsRetrievedNotification(_ notification:NSNotification) {
        //reload the table view here.....
        DispatchQueue.main.async { [unowned self] in
            if let tweets = notification.object as? [Any] {
                if (!self.hasProcessed(twitterResults: tweets as! [TWTRTweet])) {
                    var tempDatasource:[Any] = [Any]()
                    tempDatasource += tweets
                    tempDatasource += self.datasource
                    self.datasource = tempDatasource
                    self.twitterSearchMetaData = notification.userInfo as! [String : Any]?
                    self.tableView.reloadData()
                    print("got \(tweets.count) tweets from twitter!");
                }
            }
            self.twitterLoading = false
            if (!self.instagramLoading) {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    public func handleInstagramMediaRetrievedNotification(_ notification:NSNotification) {
        let instagramMediaObj = notification.object as! [String:Any]
        let instagramMedia = instagramMediaObj[Constants.InstagramAPI.instagramMediaKey] as! [InstagramMedia]
        let pageInfo = instagramMediaObj[Constants.InstagramAPI.instagramPageInfoKey] as! InstagramPaginationInfo
        self.instagramLoading = false
        print("success get tagged media. nextMaxId: \(pageInfo.nextMaxId)")
        
        for media:InstagramMedia in instagramMedia {
            print("found - caption: \(media.caption)")
        }
        print("before \(datasource.count)")
        self.datasource  += instagramMedia as [Any]
        print("after \(datasource.count)")
        tableView.reloadData()
        if (!self.twitterLoading) {
            self.refreshControl.endRefreshing()
        }
    }
    
    public func handleInstagramMediaRetrievalFailedNotification(_ notification:NSNotification) {
        //TODO: get the error from the notification object and display alert to user.
        print("Instagram media retrieval failed with error: \(notification.object)")
        self.instagramLoading = false
    }
    
    
    func getSearchText() -> String {
        var searchText = ""
        if let text =  searchBar.text {
            searchText = text
            searchText = searchText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        return searchText
    }
    
    func getNextPageOfResults() {
        //TODO: make call to twitter and instagram apis if connected.
        let searchText = getSearchText()
        if (searchText.characters.count >= 2) {
            performSearch(searchText);
        }
        else {
            refreshControl.endRefreshing()
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        if(!datasource.isEmpty) {
            rows = datasource.count
        }
        return rows
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        let dataObj :Any = datasource[indexPath.row]
        if dataObj is InstagramMedia {
            let media:InstagramMedia = dataObj as! InstagramMedia
            let instagramImageCell: HTInstagramImageCell = tableView.dequeueReusableCell(withIdentifier: instagramImageCellIdentifer) as! HTInstagramImageCell
            instagramImageCell.media = media
            if let caption = media.caption {
                instagramImageCell.caption.text = caption.text
            }
            cell = instagramImageCell
        }
        else {
            let tweet:TWTRTweet = datasource[indexPath.row] as! TWTRTweet
            let tweetCell:TWTRTweetTableViewCell! = tableView.dequeueReusableCell(withIdentifier: tweetCellIdentifer) as! TWTRTweetTableViewCell
            
            tweetCell.configure(with: tweet)
            cell = tweetCell;
        }
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    // MARK: - HTInstagramLoginDelegate methods
    func authorizedInstagramSuccessfully(user:InstagramUser!) {
        self.isInstagramConnected = true
        instagramButton.isHidden = true
        if let nav = self.navigationController {
            nav.popViewController(animated:true)
        }
    }
    
    func authorizeInstagramFailed(error: Error?) {
        //TODO: KC show alert to user with error
        print("authorizeInstagramFailed with error: \(error)")
    }
    

}
