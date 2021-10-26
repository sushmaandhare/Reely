//
//  FundDonateListVC.swift
//  Reely - Create Transform & Donate
//
//  Created by MacBook Air on 14/07/1943 Saka.
//

import UIKit
import Alamofire

class FundDonateListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var fundArr : [fundDonateMemberList] = []
    var totalJoinedMember = "0"
    var totalPoints = "0"
    var activityId : String! = ""
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        apiCall()
        
    }
    
    func apiCall(){
        
        let url : String = self.appDelegate.baseUrl!+self.appDelegate.fundDonateMember!
        
        let parameter:[String:Any]?  = ["activity_id":self.activityId, "middle_name":"osd191k3hEZm5PzMfoboJy5l466w7szI","offset": "0"]
        print(url)
        print(parameter!)
        
        let headers: HTTPHeaders = [
            "api-key": "4444-3333-2222-1111"
            
        ]
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers).validate().responseJSON(completionHandler: {
            
            respones in
            print(String.init(data: respones.data!, encoding: .utf8))
            switch respones.result {
            
            case .success( let value):
                
                let json  = value
                
                print(json)
                
                let dic = json as! NSDictionary
                let code = dic["code"] as! NSString
                let total = dic["total_joined_members"] as! NSString
                guard total != "0" else {
                    self.Alert(title: "No Members", msg: "")
                    return
                }
                if(code == "200"){
                    
                    if let myCountry = dic["msg"] as? [[String:Any]]{
                        
                        for Dict in myCountry {
                            
                            let fb_id = Dict["fb_id"] as! String
                            let username = Dict["username"] as! String
                            let verified = Dict["verified"] as! String
                            let first_name = Dict["first_name"] as! String
                            let last_name = Dict["last_name"] as! String
                            let fund = Dict["profile_pic"] as! String
                            
                            let obj = fundDonateMemberList(fb_id: fb_id, username: username, verified: verified, first_name: first_name, last_name: last_name, profile_pic: fund)
                            
                            self.fundArr.append(obj)
                            
                        }
                        self.tableview.reloadData()
                    }
                    
                }else{
                    
                    print(dic["msg"] as! String)
                    
                }
                
            case .failure(let error):
                
                print(error.localizedDescription)
                
            }
        })
       
    }
    
    func Alert(title: String, msg: String){
    let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
    let okalertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: {(alert : UIAlertAction!) in
        self.dismiss(animated: true, completion: {
            self.navigationController?.popViewController(animated: true)
        })
    })
    alertController.addAction(okalertAction)
    present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func onTapDonate(_ sender: UIButton) {
        let url : String = self.appDelegate.baseUrl!+self.appDelegate.get_userPoints!
        
        let parameter:[String:Any]?  = ["fb_id":UserDefaults.standard.string(forKey: "uid")!]
        print(url)
        print(parameter!)
        
        let headers: HTTPHeaders = [
            "api-key": "4444-3333-2222-1111"
            
        ]
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers).validate().responseJSON(completionHandler: {
            
            respones in
            print(String.init(data: respones.data!, encoding: .utf8))
            switch respones.result {
            
            case .success( let value):
                
                let json  = value
                
                print(json)
                
                let dic = json as! NSDictionary
                let code = dic["code"] as! NSString
                
                if(code == "200"){
                    
                    if let myCountry = dic["msg"] as? [String:Any]{
                        
                        
                            let points = myCountry["total_points"] as! String
                        
                            
                            self.totalPoints = points
                            
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let yourVC: FundDonateListVC = storyboard.instantiateViewController(withIdentifier: "FundDonateListVC") as! FundDonateListVC
                        yourVC.totalPoints = self.totalPoints
                        yourVC.activityId = self.activityId
                        self.navigationController?.pushViewController(yourVC, animated: true)
                        
                    }
                    
                }else{
                    
                    print(dic["msg"] as! String)
                    
                }
                
            case .failure(let error):
                
                print(error.localizedDescription)
                
            }
        })
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fundArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FundDonateMemberTVC = self.tableview.dequeueReusableCell(withIdentifier: "FundDonateMemberTVC") as! FundDonateMemberTVC
        let obj = self.fundArr[indexPath.row]
        
        cell.lblMember.text = obj.first_name! + " " +  obj.last_name!
        cell.lblUsername.text = obj.username
        cell.profilePic.sd_setImage(with: URL(string:obj.profile_pic ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130.0
    }
    
    @IBAction func onTapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}


class FundDonateMemberTVC: UITableViewCell {
    
    
    @IBOutlet weak var lblMember: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.profilePic.layer.cornerRadius = self.profilePic.frame.height/2
        self.profilePic.clipsToBounds = true
        self.profilePic.layer.borderColor = UIColor.white.cgColor
        self.profilePic.layer.borderWidth = 1.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
