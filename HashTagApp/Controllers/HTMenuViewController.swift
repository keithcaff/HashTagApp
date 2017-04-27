//
//  HTMenuViewController.swift
//  HashTagApp
//
//  Created by Keith Caffrey on 25/04/2017.
//  Copyright © 2017 Keith Caffrey. All rights reserved.
//

import UIKit
import SWRevealViewController
import GoogleSignIn
import Firebase

class HTMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let menuItemCellIdentifier = "HTMenuItemCell"
    private let sectionHeaderCellIdentifier = "HTMenuHeaderCell"
    private let menuItemImageTag = 101
    private let menuItemLabelTag = 102
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: UIView!
    let menuItems = ["Trending Tags","History","Settings"];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        registerXibs()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerXibs() {
//        tableView.register(HTMenuTableViewCell.self, forCellReuseIdentifier:menuItemCellIdentifier)
    }
    
    
    //MARK: UITableViewDelegate delegate methods
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { // custom view for header. will be adjusted to default or specified {
        let headerView = self.tableView.dequeueReusableCell(withIdentifier: sectionHeaderCellIdentifier)
        return headerView
    }

    //MARK: UITableViewDataSource delegate methods
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count;
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuItemCell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: menuItemCellIdentifier)
        let menuItemLabel:UILabel = menuItemCell?.viewWithTag(menuItemLabelTag) as! UILabel
        menuItemLabel.text = menuItems[indexPath.row];
        return menuItemCell
    }
    
    @IBAction func signOutButtonTapped(_ sender: Any) {
        do {
            try
                FIRAuth.auth()?.signOut()
                AppState.signedOut()
            
                if let nav = revealViewController().frontViewController.navigationController {
                    revealViewController().revealToggle(animated: true)
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
}
