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
import Kingfisher
public class HTInstagramImageCell : UITableViewCell {
    
    
    
    @IBOutlet weak var instaImage: UIImageView!
    
    
    var media: InstagramMedia? {
        didSet {
            self.updateUI()
        }
    };
    
    
    public func updateUI() {
        
        let imageResource = ImageResource.init(downloadURL: media!.standardResolutionImageURL)
//        let request = Request(urlRequest:url)
        //let url = URL(string: media!.standardResolutionImageURL)!
        instaImage.kf.setImage(with:imageResource)
        
        
//        let cache = Cache.shared
//        if let image = cache[request] {
//            print("this image is in the cache already \(image)")
//        }
//        else {
//            HTInstagramAPIManager.sharedInstance.retrieveImageForMedia(media:media!)
//        }
        
    }
    
    
}
