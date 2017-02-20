//
//  HTTwitterAPIManager.swift
//  HashTagApp
//
//  Created by Keith Caffrey on 02/02/2017.
//  Copyright © 2017 Keith Caffrey. All rights reserved.
//
import TwitterKit
import SwiftyJSON

public class HTTwitterAPIManager {
    
    //MARK: Shared Instance
    static let sharedInstance = HTTwitterAPIManager()
    
    // Can't init is singleton
    private init() { }
    
    public func searchTwitter(query:String!) {
        let params = [Constants.TwitterAPI.queryKey: query]
        var clientError : NSError?
        
        //TODO: get the guest session id https://docs.fabric.io/apple/twitter/log-in-with-twitter.html  
        
        let userID = Twitter.sharedInstance().sessionStore.session()?.userID
        let client = TWTRAPIClient(userID: userID)
        let url:String = "\(Constants.TwitterAPI.baseUrl)\(Constants.TwitterAPI.searchPath)"
        let request = client.urlRequest(withMethod: "GET", url: url, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(connectionError)")
            }
            guard let data = data else {
                print("no data to be parsed")
                return
            }
            let json = JSON(data)
            let jsonArray = json[Constants.TwitterAPI.statusesKey].arrayObject
            let tweets = TWTRTweet.tweets(withJSONArray:jsonArray) as! [TWTRTweet]
            NotificationCenter.default.post(name:.tweetsRetrieved, object: tweets)
        }
    }
    
}
