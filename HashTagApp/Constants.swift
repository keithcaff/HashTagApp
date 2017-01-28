//
//  Constants.swift
//  HashTagApp
//
//  Created by Keith Caffrey on 28/01/2017.
//  Copyright © 2017 Keith Caffrey. All rights reserved.
//

import NotificationCenter

extension Notification.Name {
    static let firebaseSignInSuccess = Notification.Name("notification.firebase.signIn.success")
}

struct Constants {

  struct Segues {
    static let SignInToMain = "SignInToMain"
    static let MainToSignIn = "MainToSignIn"
  }

  struct MessageFields {
    static let name = "name"
    static let text = "text"
    static let photoURL = "photoURL"
    static let imageURL = "imageURL"
  }
}
