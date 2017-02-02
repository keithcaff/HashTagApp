//
//  HTSearchTwitterViewController.swift
//  HashTagApp
//
//  Created by Keith Caffrey on 31/01/2017.
//  Copyright © 2017 Keith Caffrey. All rights reserved.
//

import UIKit
import TwitterKit

class HTSearchTwitterViewController: TWTRTimelineViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        super.viewDidLoad()
        let userID = Twitter.sharedInstance().sessionStore.session()?.userID
        let client = TWTRAPIClient(userID: userID)
        self.dataSource = TWTRSearchTimelineDataSource.init(searchQuery: "#mufc", apiClient: client)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
