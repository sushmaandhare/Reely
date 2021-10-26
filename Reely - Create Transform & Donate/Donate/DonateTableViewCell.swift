//
//  DonateTableViewCell.swift
//  Reely - Create Transform & Donate
//
//  Created by MacBook Air on 27/07/1943 Saka.
//

import UIKit

class DonateTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var btnReadMore: UIButton!
    @IBOutlet weak var viewReadMore: UIView!
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var mainLbl: UILabel!
    @IBOutlet weak var createdByLbl: UILabel!
    @IBOutlet weak var subscriptLbl: UILabel!
    @IBOutlet weak var leftDaysLbl: UILabel!
    @IBOutlet weak var donateImgView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.donateImgView.layer.cornerRadius = self.donateImgView.frame.height/2
        self.donateImgView.clipsToBounds = true
        self.donateImgView.layer.borderColor = UIColor.white.cgColor
        self.donateImgView.layer.borderWidth = 1.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }

}
