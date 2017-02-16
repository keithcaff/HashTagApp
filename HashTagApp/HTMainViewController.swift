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
    
    var searchTimer:Timer?
    var datasource:[Any] = [Any]()
    var isInstagramConnected: Bool = false;
    static let tweetCellIdentifer = "tweetCell"
    static let instagramImageCellIdentifer = "instagramImageCell"
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var searchTwitterViewController:HTSearchTwitterViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(HTMainViewController.handleTweetsRetrievedNotification(_ :)), name: .tweetsRetrieved, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HTMainViewController.handleInstagramMediaRetrievedNotification(_ :)), name: .instagramMediaRetrieved, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HTMainViewController.handleInstagramMediaRetrievalFailedNotification(_ :)), name: .instagramMediaRetrievalFailed, object: nil)
        searchBar.delegate = self
        tableView.delegate = self;
        tableView.dataSource = self;
        searchTwitterViewController = HTSearchTwitterViewController()
        tableView.register(TWTRTweetTableViewCell.self, forCellReuseIdentifier:HTMainViewController.tweetCellIdentifer)
        tableView.register(UINib(nibName: "HTInstagramImageTableViewCell", bundle: nil), forCellReuseIdentifier: HTMainViewController.instagramImageCellIdentifer)
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelection = false
        let instaEngine = InstagramEngine.shared()
        if instaEngine.accessToken != nil {
            isInstagramConnected = true;
            self.instagramButton.isHidden = isInstagramConnected;
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let nav = self.navigationController {
            nav.isNavigationBarHidden = true
        }
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
    
    
    func performSearch() {
        if let searchTimer = self.searchTimer {
            let query:String = searchTimer.userInfo as! String
            HTTwitterAPIManager.sharedInstance.searchTwitter(query: query)
            if(isInstagramConnected) {
                HTInstagramAPIManager.sharedInstance.searchInstagram(tag: query)
            }
        }
    }

    // MARK: UISearchBarDelegate methods
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let text = searchText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if (text.characters.count < 2) {
            if let searchTimer = self.searchTimer {
                searchTimer.invalidate()
            }
            return
        }
        
        DispatchQueue.main.async { [unowned self] in
            if let searchTimer = self.searchTimer {
                searchTimer.invalidate()
            }
            self.searchTimer = Timer.scheduledTimer(timeInterval:1.0, target: self, selector: #selector(self.performSearch), userInfo: text, repeats:false)
        }
    }
    // MARK: - Notifications
    public func handleTweetsRetrievedNotification(_ notification:NSNotification) {
        //reload the table view here.....
        DispatchQueue.main.async { [unowned self] in
            if let tweets = notification.object as? [Any] {
                self.datasource += tweets
                self.tableView.reloadData()
                print("got \(tweets.count) tweets from twitter!");
            }
        }

    }
    
    
    public func handleInstagramMediaRetrievedNotification(_ notification:NSNotification) {
        let instagramMediaObj = notification.object as! [String:Any]
        let instagramMedia = instagramMediaObj[Constants.InstagramAPI.instagramMediaKey] as! [InstagramMedia]
        let pageInfo = instagramMediaObj[Constants.InstagramAPI.instagramPageInfoKey] as! InstagramPaginationInfo
        
        print("success get tagged media. nextMaxId: \(pageInfo.nextMaxId)")
        
        for media:InstagramMedia in instagramMedia {
            print("found - caption: \(media.caption)")
        }
        print("before \(datasource.count)")
        self.datasource  += instagramMedia as [Any]
        print("after \(datasource.count)")
        tableView.reloadData()
    }
    
    public func handleInstagramMediaRetrievalFailedNotification(_ notification:NSNotification) {
        //TODO: get the error from the notification object and display alert to user.
    }
    
    
    // MARK: - Table view delegate methods
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell = UITableViewCell()
        
        let dataObj :Any = datasource[indexPath.row]
        if dataObj is InstagramMedia {
            let media:InstagramMedia = dataObj as! InstagramMedia
            let instagramImageCell: HTInstagramImageCell = tableView.dequeueReusableCell(withIdentifier: HTMainViewController.instagramImageCellIdentifer) as! HTInstagramImageCell
            instagramImageCell.media = media
            if let caption = media.caption {
                instagramImageCell.caption.text = caption.text
            }
            cell = instagramImageCell
        }
        else {
            let tweet:TWTRTweet = datasource[indexPath.row] as! TWTRTweet
            let tweetCell:TWTRTweetTableViewCell! = tableView.dequeueReusableCell(withIdentifier: HTMainViewController.tweetCellIdentifer) as! TWTRTweetTableViewCell
            
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
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}
