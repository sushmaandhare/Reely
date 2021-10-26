//
//  DonateViewController.swift
//  Reely - Create Transform & Donate
//
//  Created by Mac on 11/08/21.
//

import UIKit
import Alamofire
import SDWebImage

class DonateViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var DonateArray:[DonateList]=[]
    
    
    @IBOutlet weak var DonateTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.DonateListApiCall()
    }

    func DonateListApiCall(){
        
            let url : String = self.appDelegate.baseUrl!+self.appDelegate.donateTeamList!
            
            let parameter:[String:Any]?  = ["fb_id": UserDefaults.standard.string(forKey: "uid")!,"middle_name":"osd191k3hEZm5PzMfoboJy5l466w7szI","offset": "0","keyword":""]
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
                            
                            for Dict in myCountry {
                                
                                let activityId = Dict["activity_id"] as! String
                                let activityName = Dict["activity_name"] as! String
                                let Description = Dict["description"] as! String
                                let activityImg = Dict["activity_image"] as! String
                                let joinMembers = Dict["joined_members"] as! String
                                let fund_raise = Dict["fund_raise"] as! String
                                let fund_donate = Dict["fund_donate"] as? String
                                let created_by = Dict["created_by"] as! String
                                let creator_pic = Dict["creator_pic"] as! String
                                let days_left = Dict["days_left"] as! String


                                let obj = DonateList(activity_id: activityId, activity_name: activityName, desc: Description, activity_image: activityImg, joined_members: joinMembers, fundRaise: fund_raise, fund_donate: fund_donate, createdby: created_by, creatorPic: creator_pic, daysLeft: days_left)
                                
                                self.DonateArray.append(obj)
                              
                            }
                            self.DonateTableView.reloadData()
                        }
                    
                 }else{
                    
                    print(dic["msg"] as! String)
            
                    }
                    
                case .failure(let error):
                    
                    print(error.localizedDescription)
                    
            
                }
            })
            
     }
    
    
    // Tableview Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.DonateArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:DonateTableViewCell = self.DonateTableView.dequeueReusableCell(withIdentifier: "DonateTableViewCell") as! DonateTableViewCell
        
        let obj = self.DonateArray[indexPath.row]
        
        cell.mainLbl.text = obj.activity_name
//        cell.TeamDescriptlbl.text = obj.desc
        cell.createdByLbl.text = obj.created_by
        cell.backgroundImg.sd_setImage(with: URL(string:obj.activity_image), placeholderImage: UIImage(named:"create-1"))
        cell.donateImgView.sd_setImage(with: URL(string:obj.creator_pic), placeholderImage: UIImage(named:"create-1"))
        cell.btnReadMore.tag = indexPath.row
        cell.viewReadMore.tag = indexPath.row
        cell.btnReadMore.addTarget(self, action: #selector(DonateViewController.connected(_:)), for:.touchUpInside)
        
        return cell
        
    }
    
    @objc func connected(_ sender : UIButton) {
        print(sender.tag)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let yourVC: DonateDetailViewController = storyboard.instantiateViewController(withIdentifier: "DonateDetailViewController") as! DonateDetailViewController
        yourVC.donateDetail = self.DonateArray[sender.tag]
        self.navigationController?.pushViewController(yourVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 315
    }
        
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let yourVC: SelfTeamDetailsVC = storyboard.instantiateViewController(withIdentifier: "SelfTeamDetailsVC") as! SelfTeamDetailsVC
//        yourVC.activityId = self.DonateArray[indexPath.row].activity_id
//        self.navigationController?.pushViewController(yourVC, animated: true)
//    }
    
    
    
    
}
