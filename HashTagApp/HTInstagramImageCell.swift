//
//  HTInstagramImageCell.swift
//  HashTagApp
//
//  Created by Keith Caffrey on 15/02/2017.
//  Copyright © 2017 Keith Caffrey. All rights reserved.
//

import Foundation
import UIKit
import InstagramKit
import Nuke
public class HTInstagramImageCell : UITableViewCell {
    
    
    
    @IBOutlet weak var instaImage: UIImageView!
    
    
    var media: InstagramMedia? {
        didSet {
            self.updateUI()
        }
    };
    
    
    public func updateUI() {
        let url = URLRequest(url: media!.standardResolutionImageURL)
        let request = Request(urlRequest:url)
        let cache = Cache.shared
        if let image = cache[request] {
            print("this image is in the cache already \(image)")
        }
        else {
            HTInstagramAPIManager.sharedInstance.retrieveImageForMedia(media:media!)
        }
        
    }
    
    
}
