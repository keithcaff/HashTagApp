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
    static let instagramMediaRetrieved = Notification.Name("notification.ht.instagram.media.retrieved")
    static let instagramMediaRetrievalFailed = Notification.Name("notification.ht.instagram.media.retrieval.failed")
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
        static let baseUrl = "https://api.twitter.com/1.1/"
        static let searchPath = "search/tweets.json"
        static let signatureMethod = "HMAC-SHA1"
        static let queryKey = "q"
        static let max_id = "max_id"
        static let next_results = "next_results"
        static let since_id = "since_id"
        static let countKey = "count"
        static let resultTypeKey = "result_type"
        static let statusesKey = "statuses"
        static let searchMetaDataKey = "search_metadata"
    }
    
    struct InstagramAPI {
        static let clientId = "0b1d776027f946bf9ef445e6e95e431c"
        static let instagramMediaKey = "InstagramMedia"
        static let instagramPageInfoKey = "InstagramPageInfo"
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
