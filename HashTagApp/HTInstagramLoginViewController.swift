//
//  HTInstagramLoginViewController.swift
//  HashTagApp
//
//  Created by Keith Caffrey on 08/02/2017.
//  Copyright © 2017 Keith Caffrey. All rights reserved.
//

import Foundation
import InstagramKit

protocol HTInstagramLoginDelegate :class {
    func authorizedInstagramSuccessfully(user:InstagramUser!)
    func authorizeInstagramFailed(error: Error?)
    
}

class HTInstagramLoginViewController: UIViewController, UIWebViewDelegate {
    
    
    @IBOutlet weak var webView: UIWebView!
    weak var delegate: HTInstagramLoginDelegate?
    var user:InstagramUser?
    var result:[AnyObject]?
    var accessToken:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let nav = self.navigationController {
            nav.isNavigationBarHidden = false
        }
        self.title = "Connect Instagram"
        let authUrl:URL = InstagramEngine.shared().authorizationURL()
        webView.scrollView.bounces = false
        webView.delegate = self
        self.webView.scrollView.bounces = false;
        self.webView.loadRequest(URLRequest(url: authUrl))
    }
    
    //MARK: WebViewDelegate
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let engine = InstagramEngine.shared()
        do {
            if let url = request.url {
                try engine.receivedValidAccessToken(from: url)
                engine.getSelfUserDetails(success: {[weak self] (instaUser:InstagramUser) -> Void in
                    print("success - \(instaUser.fullName)")
                    if let d = self?.delegate {
                        DispatchQueue.main.async {
                            
                            d.authorizedInstagramSuccessfully(user:instaUser)
                        }
                    }
                    
                },
                failure: {(error, int) -> Void in
                    if let d = self.delegate {
                        DispatchQueue.main.async {
                            d.authorizeInstagramFailed(error:error)
                        }
                    }
                })
            }
        }
        catch {
        
        }
        return true
    }
    
}
