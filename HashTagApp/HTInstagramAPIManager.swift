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
    
    
//    public func retrieveImageForMedia(media:InstagramMedia) {
//        //https://github.com/kean/Nuke
//       // https://github.com/kean/Nuke/blob/master/Documentation/Migrations/Nuke%204%20Migration%20Guide.md
//        
//        var url = URLRequest(url: media.standardResolutionImageURL)
//        url.cachePolicy = .returnCacheDataElseLoad
//        url.timeoutInterval = 30
//
//        let request = Request(urlRequest:url)
//        let cache = Cache.shared
//        if let image = cache[request] {
//            print("this image is in the cache already \(image)")
//        }
//        else {
//            
////            Manager.shared.loadImage(with: url, token: nil) {
////                print("image \($0.value)")
////            }
//        }
//
//    }
    
}
