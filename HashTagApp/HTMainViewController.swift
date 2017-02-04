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


class HTMainViewController: UIViewController, UISearchBarDelegate {

    var searchTimer:Timer?
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var twitterView: UIView!
    var searchTwitterViewController:HTSearchTwitterViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchTwitterViewController = HTSearchTwitterViewController()
        self.setUpTwitterView()
    }
    
    func setUpTwitterView() {
        twitterView.translatesAutoresizingMaskIntoConstraints = false;
        if let searchView =  searchTwitterViewController?.view {
            searchTwitterViewController?.willMove(toParentViewController: self)
            self.addChildViewController(searchTwitterViewController!)
            twitterView.addSubview(searchView)
            searchTwitterViewController?.didMove(toParentViewController: self)
            searchView.translatesAutoresizingMaskIntoConstraints = false;
            let topConstraint = NSLayoutConstraint(
                item: searchView,
                attribute: .top,
                relatedBy: .equal,
                toItem: twitterView,
                attribute: .top,
                multiplier: 1,
                constant: 0)
            twitterView.addConstraint(topConstraint)
            
            let bottomConstraint = NSLayoutConstraint(
                item: searchView,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: twitterView,
                attribute: .bottom,
                multiplier: 1,
                constant: 0)
            twitterView.addConstraint(bottomConstraint)
            
            
            let leadingConstraint = NSLayoutConstraint(
                item: searchView,
                attribute: .leading,
                relatedBy: .equal,
                toItem: twitterView,
                attribute: .leading,
                multiplier: 1,
                constant: 0)
            twitterView.addConstraint(leadingConstraint)
            
            
            let trailingConstraint = NSLayoutConstraint(
                item: searchView,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: twitterView,
                attribute: .trailing,
                multiplier: 1,
                constant: 0)
            twitterView.addConstraint(trailingConstraint)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        }
    }

    // MARK: UISearchBarDelegate methods
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let text = searchText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if (text.characters.count < 2) {
            return
        }
        //weakSelf
        DispatchQueue.main.async { [unowned self] in
            if let searchTimer = self.searchTimer {
                searchTimer.invalidate()
            }
            self.searchTimer = Timer.scheduledTimer(timeInterval:1.0, target: self, selector: #selector(self.performSearch), userInfo: text, repeats:false)
        }
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
