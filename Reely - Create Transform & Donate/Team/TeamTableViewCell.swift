//
//  TeamTableViewCell.swift
//  Reely - Create Transform & Donate
//
//  Created by MacBook Air on 13/07/1943 Saka.
//

import UIKit
import Alamofire
import MBCircularProgressBar

class TeamTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var TeamImgView: UIImageView!
    @IBOutlet weak var TeamCountLbl: UILabel!
    @IBOutlet weak var TeamDescriptlbl: UILabel!
    @IBOutlet weak var TeamNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.TeamImgView.layer.cornerRadius = self.TeamImgView.frame.height/2
        self.TeamImgView.clipsToBounds = true
        self.TeamImgView.layer.borderColor = UIColor.white.cgColor
        self.TeamImgView.layer.borderWidth = 1.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func downloadImage(img:String) {
        
        Alamofire.request(img).responseData(completionHandler: { response in
            debugPrint(response)
            
            debugPrint(response.result)
            
            if let image1 = response.result.value {
                let image = UIImage(data: image1)
                self.TeamImgView.image = image
                
            }
        })
        
        
        
    }

}

class TeamListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var progressBar: MBCircularProgressBarView!
    @IBOutlet weak var lblMember: UILabel!
    @IBOutlet weak var lblFundRaised: UILabel!
    @IBOutlet weak var TeamImgView: UIImageView!
    @IBOutlet weak var TeamDescriptlbl: UILabel!
    @IBOutlet weak var TeamNameLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class TeamMemberListTVC: UITableViewCell {
    
    
    @IBOutlet weak var TeamImgView: UIImageView!
    @IBOutlet weak var btnFollow: UIButton!
    @IBOutlet weak var TeamDescriptlbl: UILabel!
    @IBOutlet weak var TeamNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.TeamImgView.layer.cornerRadius = self.TeamImgView.frame.height/2
        self.TeamImgView.clipsToBounds = true
        self.TeamImgView.layer.borderColor = UIColor.white.cgColor
        self.TeamImgView.layer.borderWidth = 1.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func downloadImage(img:String) {
        
        Alamofire.request(img).responseData(completionHandler: { response in
            debugPrint(response)
            
            debugPrint(response.result)
            
            if let image1 = response.result.value {
                let image = UIImage(data: image1)
                self.TeamImgView.image = image
                
            }
        })
        
        
        
    }

}
