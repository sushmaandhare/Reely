//
//  NotificationsViewController.swift
//  Reely - Create Transform & Donate
//
//  Created by Rahul on 28/10/21.
//

import UIKit
import Alamofire

class NotificationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var notificationTblView: UITableView!
    @IBOutlet weak var allImg: UIImageView!
    @IBOutlet weak var followImg: UIImageView!
    @IBOutlet weak var shopImg: UIImageView!
    @IBOutlet weak var teamImg: UIImageView!
    @IBOutlet weak var donateImg: UIImageView!
    
    var totalCount: String? = ""
    var notificationArray:[Notificaton]=[]
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        apiCall(type: "ALL")
    }
    
    func apiCall(type:String){
        self.notificationArray.removeAll()
        let url : String = self.appDelegate.baseUrl!+self.appDelegate.getNotifications!
        
        let parameter:[String:Any]?  = ["fb_id": UserDefaults.standard.string(forKey: "uid")!,"offset": "0","type":type]
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
                let total_count = dic["total_count"] as! String
                self.totalCount = total_count
                
                if(code == "200"){
                    
                    if let myCountry = dic["msg"] as? [[String:Any]]{
                        
                        for Dict in myCountry {
                            
                            let fb_id = Dict["fb_id"] as? String
                            let fb_id_details = Dict["fb_id_details"] as! NSDictionary
                            
                            let effected_fb_id = Dict["effected_fb_id"] as? String
                            let type = Dict["type"] as? String
                            let value = Dict["value"] as? String
                            let value_data = Dict["value_data"] as! NSDictionary
                           
                            let first_name = fb_id_details["first_name"] as? String
                            let last_name = fb_id_details["last_name"] as? String
                            let profile_pic = fb_id_details["profile_pic"] as? String
                            let username = fb_id_details["username"] as? String
                            let verified = fb_id_details["verified"] as? String
                            
                            let video_id = value_data["video_id"] as? String
//                            let video = value_data["video"] as! String
//                            let thum = value_data["thum"] as! String
                            let activity_id = value_data["activity_id"] as? String
                            let activity_name = value_data["activity_name"] as? String
                            let activity_image = value_data["activity_image"] as? String
                            let donate_points = value_data["donate_points"] as? String
                            

                            
                            let obj = Notificaton(fb_id: fb_id, first_name: first_name, last_name: last_name, profile_pic: profile_pic, username: username, verified: verified, effected_fb_id: effected_fb_id, type: type, value: value, video_id: video_id, activity_id: activity_id, activity_name: activity_name, activity_image: activity_image, donate_points: donate_points)
                            
                            self.notificationArray.append(obj)
                          
                        }
                        self.notificationTblView.reloadData()
                    }
                
             }else{
                
                print(dic["msg"] as! String)
        
                }
                
            case .failure(let error):
                
                print(error.localizedDescription)
                
        
            }
        })
        
 }
    
    @IBAction func DonateBtnAction(_ sender: UIButton) {
        self.donateImg.image = UIImage(named: "Donate active")
        self.allImg.image = UIImage(named: "All inactive")
        self.followImg.image = UIImage(named: "Follow inactive")
        self.shopImg.image = UIImage(named: "Shop inactive")
        self.teamImg.image = UIImage(named: "Team inactive")
        self.apiCall(type: "Donate")
    }
    
    @IBAction func TeamBtnAction(_ sender: UIButton) {
        self.donateImg.image = UIImage(named: "Donate inactive")
        self.allImg.image = UIImage(named: "All inactive")
        self.followImg.image = UIImage(named: "Follow inactive")
        self.shopImg.image = UIImage(named: "Shop inactive")
        self.teamImg.image = UIImage(named: "Team active")
        self.apiCall(type: "Team")
    }
    
    @IBAction func ShopBtnAction(_ sender: UIButton) {
        self.donateImg.image = UIImage(named: "Donate inactive")
        self.allImg.image = UIImage(named: "All inactive")
        self.followImg.image = UIImage(named: "Follow inactive")
        self.shopImg.image = UIImage(named: "Shop active")
        self.teamImg.image = UIImage(named: "Team inactive")
        self.apiCall(type: "ALL")
    }
    @IBAction func FollowBtnAction(_ sender: UIButton) {
        self.donateImg.image = UIImage(named: "Donate inactive")
        self.allImg.image = UIImage(named: "All inactive")
        self.followImg.image = UIImage(named: "Follow active")
        self.shopImg.image = UIImage(named: "Shop inactive")
        self.teamImg.image = UIImage(named: "Team inactive")
        self.apiCall(type: "Follow")
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func AllBtnAction(_ sender: UIButton) {
        self.donateImg.image = UIImage(named: "Donate inactive")
        self.allImg.image = UIImage(named: "All active")
        self.followImg.image = UIImage(named: "Follow inactive")
        self.shopImg.image = UIImage(named: "Shop inactive")
        self.teamImg.image = UIImage(named: "Team inactive")
        self.apiCall(type: "ALL")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return notificationArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:NotificationTVC = self.notificationTblView.dequeueReusableCell(withIdentifier: "NotificationTVC") as! NotificationTVC
        
        let obj = self.notificationArray[indexPath.row]
        
        let name = (obj.first_name ?? "") + " " + (obj.last_name ?? "")
        cell.nameLbl.text = name
        if obj.type == "following_you"{
            cell.notificationLbl.text = name + " Followed you"
            cell.NotificationImgView.image = UIImage(named: "Follow inactive")
        }else if obj.type == "joined_you"{
            cell.notificationLbl.text = name + " Joined your team"
            cell.activityImg.sd_setImage(with: URL(string:obj.activity_image ?? ""), placeholderImage: UIImage(named:"create-1"))
            cell.NotificationImgView.image = UIImage(named: "Team inactive")
        }else if obj.type == "donate_you"{
            cell.notificationLbl.text = name + " donate" + obj.donate_points!
            cell.NotificationImgView.image = UIImage(named: "Donate inactive")
        }else if obj.type == "video_like"{
            cell.notificationLbl.text = name + " Liked your video"
            cell.NotificationImgView.image = UIImage(named: "ic_like_fill")
        }
        
        cell.profileImgView.sd_setImage(with: URL(string:obj.profile_pic ?? ""), placeholderImage: UIImage(named:"create-1"))
       
       
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114
    }
}
