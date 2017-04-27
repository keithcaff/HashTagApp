//
//  HTSignInViewController.swift
//  HashTagApp
//
//  Created by Keith Caffrey on 28/01/2017.
//  Copyright © 2017 Keith Caffrey. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
import TwitterKit
import SWRevealViewController
class HTSignInViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var signInContainerView: UIView!
    @IBOutlet weak var signInButton: GIDSignInButton!
    var eaRootSWRevealViewController :SWRevealViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(HTSignInViewController.handleSignInNotification(_ :)), name: .firebaseSignInSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HTSignInViewController.handleSignInFailedNotification(_ :)), name: .firebaseSignInFailed, object: nil)
        
        GIDSignIn.sharedInstance().uiDelegate = self
        if let user = FIRAuth.auth()?.currentUser {
            self.signedIn(user)
            enableSignIn(false)
        }
        else {
            GIDSignIn.sharedInstance().signInSilently()
            enableSignIn(false)
        }
        
        //OLD TWITTER SIGN IN CODE
        
//        weak var weakSelf = self
//        let logInButton = TWTRLogInButton { (session, error) in
//            if let unwrappedSession = session {
//                let credential = FIRTwitterAuthProvider.credential(withToken: unwrappedSession.authToken, secret: unwrappedSession.authTokenSecret)
//                    weakSelf?.authenticateWithFirebase(credential)
//            }
//            else {
//                let alert = UIAlertController(title: "Twitter error",
//                                              message: "Login failed",
//                    preferredStyle: UIAlertControllerStyle.alert
//                )
//                weakSelf?.present(alert, animated: true, completion: nil)
//                NSLog("Twitter Login failed: %@", error!.localizedDescription);
//            }
//        }
//        logInButton.center = self.view.center
//        self.view.addSubview(logInButton)
    }
    
    
    func enableSignIn(_ enable:Bool) {
        if(enable) {
            activityIndicator.isHidden = true
            signInContainerView.isUserInteractionEnabled = true
        }
        else {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            signInContainerView.isUserInteractionEnabled = false
        }
    }
    
    
    func authenticateWithFirebase(_ credential:FIRAuthCredential) {
        weak var weakSelf = self
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            if let error = error {
                print ("HTSignInViewController - authenticateWithFirebase failed with error \(error)")
                weakSelf?.signInButton.isEnabled = true;
                return
            }
            else {
                if let user = user, let weakSelf = weakSelf {
                    weakSelf.signedIn(user)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    
    
    //MARK: Sign in notification methods
    func handleSignInFailedNotification(_ notification:NSNotification) {
        self.enableSignIn(true)
    }
    
    func handleSignInNotification(_ notification:NSNotification) {
        if let user = notification.object as? FIRUser {
            self.signedIn(user)
        }
    }
    
    func signedIn(_ user : FIRUser!) {
        weak var weakSelf:HTSignInViewController? = self
        print ("weakself test - \(weakSelf)")
        DispatchQueue.main.async {
            AppState.signedIn(user)
            if let nav = weakSelf?.navigationController {
                
                self.eaRootSWRevealViewController = (self.storyboard?.instantiateViewController(withIdentifier: "RootSWRevealViewController") as! SWRevealViewController)
                if(nav.viewControllers.count < 2) {
                    nav.pushViewController(self.eaRootSWRevealViewController!, animated: true)
                }
                self.enableSignIn(true)
            }
            //let notificationName = Notification.Name(rawValue: Constants.NotificationKeys.SignedIn)
            //NotificationCenter.default.post(name: notificationName, object: nil, userInfo: nil)
        }
    }
}
