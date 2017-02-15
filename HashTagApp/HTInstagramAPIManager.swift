//
//  HTInstagramAPIManager.swift
//  HashTagApp
//
//  Created by Keith Caffrey on 14/02/2017.
//  Copyright © 2017 Keith Caffrey. All rights reserved.
//

import Foundation
import InstagramKit

public class HTInstagramAPIManager {
    
    
    //MARK: Shared Instance
    static let sharedInstance = HTInstagramAPIManager()
    
     // Can't init is singleton
    private init() {}
    
    public func searchInstagram(tag:String) {
        let engine = InstagramEngine.shared()
        engine.getMediaWithTagName("dublin", count:5, maxId: nil, withSuccess: {media, paginationInfo in
            let instagramMediaObj: [String : Any] = [Constants.InstagramAPI.instagramPageInfoKey : paginationInfo, Constants.InstagramAPI.instagramMediaKey : media]
            NotificationCenter.default.post(name:.instagramMediaRetrieved, object:instagramMediaObj)
        },failure:{ error in
            NotificationCenter.default.post(name:.instagramMediaRetrieved, object:error)
        })
    }
}
