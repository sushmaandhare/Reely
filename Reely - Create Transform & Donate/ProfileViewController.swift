//
//  ProfileViewController.swift
//  Reely - Create Transform & Donate
//
//  Created by MacBook Air on 02/06/1943 Saka.
//

import UIKit

class ProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    let NameArray = ["Profile", "My Orders", "My Wishlist", "My Address", "Refer & Earn", "Settings", "Terms of Use", "Log Out"]
   // let ImageArray : [UIImage]
    
    var first_name:String! = ""
    var last_name:String! = ""
    var email:String! = ""
    var my_id:String! = ""
    var profile_pic:String! = ""
    var signUPType:String! = ""

    @IBOutlet weak var ProfileTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.ProfileTableView.dataSource = self
        self.ProfileTableView.delegate =  self
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NameArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ProfileTableViewCell = self.ProfileTableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell") as! ProfileTableViewCell
        
        cell.ProfileLbl.text = NameArray[indexPath.row]
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0{
           // self.navigationController?.dismiss(animated: true, completion: {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let yourVC: UserProfileViewController = storyboard.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
               self.navigationController?.pushViewController(yourVC, animated: true)
        //    })
       
    }

    }
}

class ProfileTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var ProfileLbl: UILabel!
    @IBOutlet weak var ImgView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
