//
//  TeamMemberListVC.swift
//  Reely - Create Transform & Donate
//
//  Created by MacBook Air on 13/07/1943 Saka.
//

import UIKit
import Alamofire

class TeamMemberListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    var TeamMemberArray:[TeamMemberList]=[]
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var activityId : String! = ""
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TeamMemberApiCall()
        // Do any additional setup after loading the view.
    }
    
    func Alert(title: String, msg: String){
    let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
    let okalertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: {(alert : UIAlertAction!) in
        self.dismiss(animated: true, completion: nil)
    })
    alertController.addAction(okalertAction)
    present(alertController, animated: true, completion: nil)
    }
    
    func TeamMemberApiCall(){
        
            let url : String = self.appDelegate.baseUrl!+self.appDelegate.activityTeamMember!
            
        let parameter:[String:Any]?  = ["fb_id": UserDefaults.standard.string(forKey: "uid")!,"activity_id": self.activityId, "middle_name":"osd191k3hEZm5PzMfoboJy5l466w7szI","offset": "0"]
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
                        
                        if let myCountry = dic["msg"] as? [[String:Any]]{
                            let total = dic["total_joined_members"] as! NSString
                            guard total != "0" else {
                                self.Alert(title: "No Members", msg: "")
                                return
                            }
                            for Dict in myCountry {
                                
                                let fb_id = Dict["fb_id"] as! String
                                let username = Dict["username"] as! String
                                let verified = Dict["verified"] as! String
                                let first_name = Dict["first_name"] as! String
                                let last_name = Dict["last_name"] as! String
                                let profile_pic = Dict["profile_pic"] as! String
                                let follow_Status = Dict["follow_Status"] as! NSDictionary
                                
                                let status = follow_Status["follow_status_button"] as! String
                                let my_follow_Status = Dict["my_follow_Status"] as! NSDictionary
                                
                                let mystatus = my_follow_Status["my_follow_status_button"] as! String
                                
                                let obj = TeamMemberList(fb_id: fb_id, username: username, verified: verified, first_name: first_name, last_name: last_name, profile_pic: profile_pic, follow_Status: status, my_follow_Status: mystatus)
                                
                                self.TeamMemberArray.append(obj)
                               
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TeamMemberArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TeamMemberListTVC = self.tableview.dequeueReusableCell(withIdentifier: "TeamMemberListTVC") as! TeamMemberListTVC
        let obj = self.TeamMemberArray[indexPath.row]
        cell.TeamImgView.sd_setImage(with: URL(string:obj.profile_pic), placeholderImage: UIImage(named:"create-1"))
        cell.TeamNameLbl.text = obj.first_name + " " + obj.last_name
        cell.TeamDescriptlbl.text = obj.username
        cell.btnFollow.setTitle(obj.follow_Status, for: .normal)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130.0
    }
    
    @IBAction func onTapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}



