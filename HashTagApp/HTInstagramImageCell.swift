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
    
    @IBOutlet weak var caption: UILabel!
    
    var media: InstagramMedia? {
        didSet {
            self.updateUI()
        }
    };
    
    
    public func updateUI() {
        let imageResource = ImageResource.init(downloadURL: media!.standardResolutionImageURL)
        instaImage.kf.setImage(with:imageResource)
    }
    
    
}
