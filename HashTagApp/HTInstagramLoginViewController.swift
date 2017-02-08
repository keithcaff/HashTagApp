//
//  HTInstagramLoginViewController.swift
//  HashTagApp
//
//  Created by Keith Caffrey on 08/02/2017.
//  Copyright © 2017 Keith Caffrey. All rights reserved.
//

import Foundation
import InstagramKit


class HTInstagramLoginViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    var user:InstagramUser?
    var result:[AnyObject]?
    var accessToken:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let nav = self.navigationController {
            nav.isNavigationBarHidden = false
        }
//        let scope: InstagramKitLoginScope = [.publicContent]
//        let authUrl:URL = InstagramEngine.shared().authorizationURL(for:scope)
//        webView.scrollView.bounces = false
//        webView.delegate = self
//        self.webView.scrollView.bounces = false;
//        self.webView.loadRequest(URLRequest(url: authUrl))
        
        
        self.navigationItem.leftBarButtonItem?.target = self
    
//        [self.navigationItem.leftBarButtonItem setTarget:self];
//        [self.navigationItem.leftBarButtonItem setAction:@selector(dismissView)];
        
        
        
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(InstagramViewController.reloadData),name:"reloadData", object: nil)
        
    }
}
