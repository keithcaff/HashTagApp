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
class HTSignInViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(HTSignInViewController.handleSignInNotification(_ :)), name: .firebaseSignInSuccess, object: nil)
        
        GIDSignIn.sharedInstance().uiDelegate = self
        if let user = FIRAuth.auth()?.currentUser {
            self.signedIn(user)
        }
        else {
            GIDSignIn.sharedInstance().signInSilently()
        }
        weak var weakSelf = self
        let logInButton = TWTRLogInButton { (session, error) in
            if let unwrappedSession = session {
                let credential = FIRTwitterAuthProvider.credential(withToken: unwrappedSession.authToken, secret: unwrappedSession.authTokenSecret)
                    weakSelf?.authenticateWithFirebase(credential)
            }
            else {
                let alert = UIAlertController(title: "Twitter error",
                                              message: "Login failed",
                    preferredStyle: UIAlertControllerStyle.alert
                )
                weakSelf?.present(alert, animated: true, completion: nil)
                NSLog("Twitter Login failed: %@", error!.localizedDescription);
            }
        }
        logInButton.center = self.view.center
        self.view.addSubview(logInButton)
    }
    
    
    func authenticateWithFirebase(_ credential:FIRAuthCredential) {
        weak var weakSelf = self
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            if let error = error {
                print ("HTSignInViewController - authenticateWithFirebase failed with error \(error)")
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
    
    
    
    // MARK: GIDSignInUIDelegate methods
    
    // The sign-in flow has finished selecting how to proceed, and the UI should no longer display
    public func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        print ("GIDSignInUIDelegate (HTSignInViewController) - sign in failed with error \(error)")
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
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainVc") as! HTMainViewController
                nav.pushViewController(secondViewController, animated: true)
            }
            //let notificationName = Notification.Name(rawValue: Constants.NotificationKeys.SignedIn)
            //NotificationCenter.default.post(name: notificationName, object: nil, userInfo: nil)
        }
    }
}
