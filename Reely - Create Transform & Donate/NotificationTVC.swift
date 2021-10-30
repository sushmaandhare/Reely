//
//  NotificationTVC.swift
//  Reely - Create Transform & Donate
//
//  Created by MacBook Air on 06/08/1943 Saka.
//

import UIKit

class NotificationTVC: UITableViewCell {
    

    @IBOutlet weak var notificationLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var activityImg: UIImageView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var NotificationImgView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.profileImgView.layer.cornerRadius = self.profileImgView.frame.height/2
        self.profileImgView.clipsToBounds = true
        self.profileImgView.layer.borderColor = UIColor.white.cgColor
        self.profileImgView.layer.borderWidth = 1.0
        
        self.activityImg.layer.cornerRadius = self.activityImg.frame.height/2
        self.activityImg.clipsToBounds = true
        self.activityImg.layer.borderColor = UIColor.white.cgColor
        self.activityImg.layer.borderWidth = 1.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }

}
