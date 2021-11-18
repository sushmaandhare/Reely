//
//  ProfileViewController.swift
//  Reely - Create Transform & Donate
//
//  Created by MacBook Air on 02/06/1943 Saka.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var ProfileLbl: UILabel!
    @IBOutlet weak var ImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


protocol ProfileViewControllerDelegate : AnyObject{
    func didSelectOption(index: Int)
}

class ProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let nameArray = ["Profile", "My Orders", "My Wishlist", "My Address", "Refer & Earn", "Settings", "Terms of Use", "Privacy Policy", "Log Out"]
    
    var first_name:String! = ""
    var last_name:String! = ""
    var email:String! = ""
    var my_id:String! = ""
    var profile_pic:String! = ""
    var signUPType:String! = ""
    weak var delegate : ProfileViewControllerDelegate?
    @IBOutlet weak var ProfileTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ProfileTableView.dataSource = self
        self.ProfileTableView.delegate =  self
    }
    
    @IBAction func onTapDismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ProfileTableViewCell = self.ProfileTableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell") as! ProfileTableViewCell
        cell.ProfileLbl.text = nameArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) { [weak self] in
            self?.delegate?.didSelectOption(index: indexPath.row)
        }
    }
}

