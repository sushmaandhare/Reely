//
//  HashTagCollectionViewCell.swift
//  Reely - Create Transform & Donate
//
//  Created by MacBook Air on 20/07/1943 Saka.
//

import UIKit
import SDWebImage

class HashTagCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgViewBackgroundView: UIImageView!
    @IBOutlet weak var imgViewPlayView: UIImageView!
    @IBOutlet weak var lblViews: UILabel!
    @IBOutlet weak var imgViewEyeView: UIImageView!
    
    
    var callBack:(()->())?
    
    var videos: Sections_videos? {
        didSet {
            let url = URL(string: self.videos?.thum ?? "")
            self.imgViewBackgroundView.sd_setImage(with: url, placeholderImage: UIImage(), options: SDWebImageOptions.continueInBackground, completed: nil)
            
            self.lblViews.text = self.videos?.count?.view ?? "0"
        }
    }
}
