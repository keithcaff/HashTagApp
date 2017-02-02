//
//  HTTwitterAPIManager.swift
//  HashTagApp
//
//  Created by Keith Caffrey on 02/02/2017.
//  Copyright © 2017 Keith Caffrey. All rights reserved.
//

import Alamofire

public class HTTwitterAPIManager {
    
    static let twitterSearchAPIURL:String! = "https://api.twitter.com/1.1/search/tweets.json";
    static let consumerKey:String = "";
    static let consumerSecret:String = "";
    
    
    
    //MARK: Shared Instance
    static let sharedInstance = HTTwitterAPIManager()
    
    // Can't init is singleton
    private init() { }
    
    func searchTwitter(query:String) {
        //https://grokswift.com/rest-with-alamofire-swiftyjson/
        //https://grokswift.com/router/
        //https://grokswift.com/how-alamofire-router/
        //https://dev.twitter.com/rest/public/search
        //https://dev.twitter.com/rest/reference/get/search/tweets
        //https://github.com/Alamofire/Alamofire/blob/master/Documentation/Alamofire%204.0%20Migration%20Guide.md -> using alamofire 4
        var params: [String:Any]
        params = ["query": "query"]

        Alamofire.request(HTTwitterAPIManager.twitterSearchAPIURL, method: .get, parameters:params, encoding: JSONEncoding.default)
            .responseJSON { response in
                // ...
        }

    }
    
}
