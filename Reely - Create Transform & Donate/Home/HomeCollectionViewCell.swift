//
//  HomeCollectionViewCell.swift
//  Reely - Create Transform & Donate
//
//  Created by Rahul on 30/08/21.
//

import UIKit
import SDWebImage

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgViewHashTag: UIImageView!
    @IBOutlet weak var viewHashTag: UIView!
    @IBOutlet weak var lblViews: UILabel!
    
    var videos: Sections_videos? {
        didSet {
            let url = URL(string: self.videos?.thum ?? "")
            self.imgViewHashTag.sd_setImage(with: url, placeholderImage: UIImage(), options: SDWebImageOptions.continueInBackground, completed: nil)
            self.lblViews.text = self.videos?.count?.view
            
        }
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
