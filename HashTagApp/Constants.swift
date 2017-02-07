//
//  Constants.swift
//  HashTagApp
//
//  Created by Keith Caffrey on 28/01/2017.
//  Copyright © 2017 Keith Caffrey. All rights reserved.
//

import NotificationCenter

extension Notification.Name {
    static let firebaseSignInSuccess = Notification.Name("notification.ht.firebase.signIn.success")
    static let tweetsRetrieved = Notification.Name("notification.ht.twitter.tweets.retrieved")
}

struct Constants {
    
    struct TwitterAPI {
        static let oAuthConsumerKeyHeaderKey = "oauth_consumer_key"
        static let oAuthNOnceHeaderKey = "oauth_nonce"
        static let oAuthSignatureHeaderKey = "oauth_signature"
        static let oAuthSignatureMethodHeaderKey = "oauth_signature_method"
        static let oAuthTimestampHeaderKey = "oauth_timestamp"
        static let oAuthTokenHeaderKey = "oauth_token"
        static let oAuthVersionHeaderKey = "oauth_version"
        static let oAuthVersion = "1.0"
        static let signatureMethod = "HMAC-SHA1"
        static let statusesKey = "statuses"
    }

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
