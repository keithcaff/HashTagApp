//
//  HTTwitterAPIManager.swift
//  HashTagApp
//
//  Created by Keith Caffrey on 02/02/2017.
//  Copyright © 2017 Keith Caffrey. All rights reserved.
//
import Alamofire
import TwitterKit
import SwiftyJSON

public class HTTwitterAPIManager {
    
    static let twitterSearchAPIURL:String! = "https://api.twitter.com/1.1/search/tweets.json";
    static let consumerKey:String = "";
    static let consumerSecret:String = "";
    
    
    
    //MARK: Shared Instance
    static let sharedInstance = HTTwitterAPIManager()
    
    // Can't init is singleton
    private init() { }
    
    public func searchTwitter(query:String!) {
        print ("kctest called - twitterRequestTest")
        let params = ["q": query,"result_type":"popular"]
        var clientError : NSError?
        let userID = Twitter.sharedInstance().sessionStore.session()?.userID
        let client = TWTRAPIClient(userID: userID)
        
        let request = client.urlRequest(withMethod: "GET", url: HTTwitterAPIManager.twitterSearchAPIURL, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(connectionError)")
            }
            
            guard let data = data else {
                print("no data to be parsed")
                return
            }
            let json = JSON(data)
            print("json: \(json)")
            //fire off notification that results have been retrieved now
        }
    }
    
}
