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
    
    
    func signedIn(_ user : FIRUser?) {
        AppState.sharedInstance.displayName = user?.displayName ?? user?.email
        AppState.sharedInstance.photoURL = user?.photoURL
        AppState.sharedInstance.signedIn = true
        //let notificationName = Notification.Name(rawValue: Constants.NotificationKeys.SignedIn)
        //NotificationCenter.default.post(name: notificationName, object: nil, userInfo: nil)
        
        performSegue(withIdentifier: Constants.Segues.SignInToMain, sender: nil)
        
    }

    
    
    
}
