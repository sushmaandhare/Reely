//
//  HomeHashtagTVC.swift
//  Reely - Create Transform & Donate
//
//  Created by Rahul on 30/08/21.
//

import UIKit
import SDWebImage

class HomeHashtagTVC: UITableViewCell {
    
    @IBOutlet weak var hashTagCollectionView: UICollectionView!
    @IBOutlet weak var lblViews: UILabel!
    @IBOutlet weak var btnViews: UIButton!
    @IBOutlet weak var lblTrending: UILabel!
    @IBOutlet weak var lblHashTag: UILabel!
    @IBOutlet weak var imgHashTag: UIImageView!
    @IBOutlet weak var viewHashHeader: UIView!
    
    var callBack:((Any?)->())?
    
    var videoMsg: VideoMsg? {
        didSet {
            self.lblHashTag.text = "# \(self.videoMsg?.section_name ?? "")"
            self.lblTrending.text = "\(self.videoMsg?.section_views ?? "0")M views"
            self.lblViews.text = "View All"
            
            
           // let str = "\(self.videoMsg?.section_icon ?? "")friendship.png"
           // #warning("temp added becuase URL from response is not completed.")

           // self.imgHashTag.sd_setImage(with: URL(string: str), placeholderImage: UIImage(), options: SDWebImageOptions.continueInBackground, completed: nil)
            
            self.hashTagCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.hashTagCollectionView.delegate = self
        self.hashTagCollectionView.dataSource = self
    }
    
    
    @IBAction func btnViewClick(_ sender: UIButton) {
        self.callBack?("views")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension HomeHashtagTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.videoMsg?.sections_videos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell {
            cell.videos = self.videoMsg?.sections_videos?[indexPath.item]
            return cell
        }
        return UICollectionViewCell(frame: .zero)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        callBack?(("video", self.videoMsg?.sections_videos?[indexPath.item]))
    }
}
