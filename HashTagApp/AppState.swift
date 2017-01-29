//
//  AppState.swift
//  HashTagApp
//
//  Created by Keith Caffrey on 28/01/2017.
//  Copyright © 2017 Keith Caffrey. All rights reserved.
//
import Foundation
import Firebase

class AppState: NSObject {
    
    static let sharedInstance = AppState()
    
    var signedIn = false
    var displayName: String?
    var photoURL: URL?
    var uid : String?
    
    
    static func signedIn(_ user:FIRUser!) {
        AppState.sharedInstance.signedIn = true
        AppState.sharedInstance.displayName = user.displayName
        AppState.sharedInstance.photoURL = user.photoURL
        AppState.sharedInstance.uid = user.uid
    }
    static func signedOut() {
        AppState.sharedInstance.signedIn = false
        AppState.sharedInstance.displayName = nil
        AppState.sharedInstance.photoURL = nil
        AppState.sharedInstance.uid = nil
    }
    
}
