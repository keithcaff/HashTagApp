//
//  HTMenuViewController.swift
//  HashTagApp
//
//  Created by Keith Caffrey on 25/04/2017.
//  Copyright © 2017 Keith Caffrey. All rights reserved.
//

import UIKit

class HTMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let sectionHeaderCellIdentifier = "MenuHeaderCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var footerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITableViewDelegate delegate methods
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { // custom view for header. will be adjusted to default or specified {
        let headerView = self.tableView.dequeueReusableCell(withIdentifier: sectionHeaderCellIdentifier)
        return headerView
    }

    //MARK: UITableViewDataSource delegate methods
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //TODO: create custom cell for prototpe cells and return it here.
        let cell =  UITableViewCell.init(style: .default, reuseIdentifier: "test")
        cell.textLabel?.text = "testing 123"
        return cell
    }
    
    
    

}
