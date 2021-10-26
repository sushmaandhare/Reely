//
//  TeamViewController.swift
//  Reely - Create Transform & Donate
//
//  Created by Mac on 11/08/21.
//

import UIKit
import  Alamofire
import SDWebImage

class TeamViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var TeamArray:[TeamList]=[]
    
    @IBOutlet weak var TeamTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
        self.TeamListApiCall()
    }
    
    @IBAction func JoinTeamBtnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let yourVC: TeamListVC = storyboard.instantiateViewController(withIdentifier: "TeamListVC") as! TeamListVC
        self.navigationController?.pushViewController(yourVC, animated: true)
    }
    
    
    @IBAction func CreateTeamBtnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let yourVC: CreateTeamVC = storyboard.instantiateViewController(withIdentifier: "CreateTeamVC") as! CreateTeamVC
        yourVC.modalPresentationStyle = .overCurrentContext
        self.present(yourVC, animated: true, completion: nil)
    }
   
    func TeamListApiCall(){
        
        self.TeamArray.removeAll()
            let url : String = self.appDelegate.baseUrl!+self.appDelegate.myTeamListing!
            
            let parameter:[String:Any]?  = ["fb_id": UserDefaults.standard.string(forKey: "uid")!,"middle_name":"osd191k3hEZm5PzMfoboJy5l466w7szI","offset": "0"]
        
      //  let parameter:[String:Any]?  = ["fb_id": "EocGotMQgmZCDVoNU3dXvcw2wG23","middle_name":"osd191k3hEZm5PzMfoboJy5l466w7szI","offset": "0"]
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
                                
                                let obj = TeamList(activity_id: activityId, activity_name: activityName, desc: Description, activity_image: activityImg, joined_members: joinMembers, fundRaise: "", fund_donate: 0)
                                
                                self.TeamArray.append(obj)
                               self.TeamTableView.reloadData()
                            }
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
        
        let cell:TeamTableViewCell = self.TeamTableView.dequeueReusableCell(withIdentifier: "TeamTableViewCell") as! TeamTableViewCell
        
        let obj = self.TeamArray[indexPath.row] 
        
        cell.TeamNameLbl.text = obj.activity_name
        cell.TeamDescriptlbl.text = obj.desc
        cell.TeamCountLbl.text = obj.joined_members
        cell.TeamImgView.sd_setImage(with: URL(string:obj.activity_image), placeholderImage: UIImage(named:"create-1"))
        
        
        return cell
        
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let yourVC: SelfTeamDetailsVC = storyboard.instantiateViewController(withIdentifier: "SelfTeamDetailsVC") as! SelfTeamDetailsVC
        yourVC.activityId = self.TeamArray[indexPath.row].activity_id
        self.navigationController?.pushViewController(yourVC, animated: true)
    }
    }
    

