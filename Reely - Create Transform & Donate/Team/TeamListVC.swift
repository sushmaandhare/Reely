//
//  TeamListVC.swift
//  Reely - Create Transform & Donate
//
//  Created by MacBook Air on 13/07/1943 Saka.
//

import UIKit
import Alamofire
import SDWebImage

class TeamListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var TeamArray:[TeamList]=[]
    
    @IBOutlet weak var TeamTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TeamListApiCall()
    }

    func TeamListApiCall(){
        
        self.TeamArray.removeAll()
            let url : String = self.appDelegate.baseUrl!+self.appDelegate.allTeamListing!
            
            let parameter:[String:Any]?  = ["fb_id": UserDefaults.standard.string(forKey: "uid")!,"middle_name":"osd191k3hEZm5PzMfoboJy5l466w7szI","offset": "0", "keyword":""]
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
                                let fund = Dict["fund_raise"] as! String
                                let fundDonate = Dict["fund_donate"] as? Int
                                let creator = Dict["created_by"] as! String
                                let days = Dict["days_left"] as! String
                                let creatorPic = Dict["creator_pic"] as! String
                                
                                let obj = TeamList(activity_id: activityId, activity_name: activityName, desc: Description, activity_image: activityImg, joined_members: joinMembers, fundRaise: fund, fund_donate: fundDonate, createdBy: creator, daysLeft: days, createdPic: creatorPic)
                                
                                self.TeamArray.append(obj)
                            
                            }
                            self.TeamTableView.reloadData()
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
        
        return self.TeamArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:TeamListTableViewCell = self.TeamTableView.dequeueReusableCell(withIdentifier: "TeamListTableViewCell") as! TeamListTableViewCell
        
        let obj = self.TeamArray[indexPath.row]
        
        cell.TeamNameLbl.text = obj.activity_name
        cell.TeamDescriptlbl.text = obj.desc
        cell.lblMember.text = obj.joined_members
        cell.TeamImgView.sd_setImage(with: URL(string:obj.activity_image), placeholderImage: UIImage(named:"create-1"))
        cell.lblFundRaised.text = obj.fundRaise
       // cell.progressBar.value = 30.0
       
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 265
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let yourVC: TeamDetailsVC = storyboard.instantiateViewController(withIdentifier: "TeamDetailsVC") as! TeamDetailsVC
        yourVC.teamDetail = self.TeamArray[indexPath.row]
        self.navigationController?.pushViewController(yourVC, animated: true)
    }
    
    @IBAction func onTapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
