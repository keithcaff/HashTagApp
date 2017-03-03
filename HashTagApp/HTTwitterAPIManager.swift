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
        //https://dev.twitter.com/rest/reference/get/search/tweets api documentation
        let params = [Constants.TwitterAPI.queryKey: query, Constants.TwitterAPI.countKey:"5"]
        var clientError : NSError?
        let client = TWTRAPIClient(userID: nil) //passing nil to TWTRAPIClient init will use guest client.
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
            let searchMetaData : [String:Any]? = json[Constants.TwitterAPI.searchMetaDataKey].dictionaryObject
            let tweets = TWTRTweet.tweets(withJSONArray:jsonArray) as! [TWTRTweet]
            NotificationCenter.default.post(name:.tweetsRetrieved, object: tweets, userInfo: searchMetaData)
        }
    }
}
