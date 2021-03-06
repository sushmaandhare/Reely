//
//  TeamViewController.swift
//  Reely - Create Transform & Donate
//
//  Created by Mac on 11/08/21.
//

import UIKit
import  Alamofire
import SDWebImage

class TeamViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, CreateTeamVCDelegate, ProfileViewControllerDelegate {
    func successfullTeamCreate() {
        self.TeamListApiCall()
    }
    
    
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
    
    
    @IBAction func CartBtnAction(_ sender: UIButton) {
        
    }
    
    
    @IBAction func NotificationBtnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let yourVC: NotificationsViewController = storyboard.instantiateViewController(withIdentifier: "NotificationsViewController") as! NotificationsViewController
        self.navigationController?.pushViewController(yourVC, animated: true)
    }
    
    
    @IBAction func ProfileBtnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: ProfileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func didSelectOption(index: Int) {
        if index == 0{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let yourVC: UserProfileViewController = storyboard.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
            self.navigationController?.pushViewController(yourVC, animated: true)
        }else if index == 6{
            guard let url = URL(string: "https://reely.world/terms_conditions.html") else { return }
            UIApplication.shared.open(url)
        }else if index == 7{
            guard let url = URL(string: "https://reely.world/privacy-policy.html") else { return }
            UIApplication.shared.open(url)
        }else if index == 8{
            let alert = UIAlertController(title: "Are you sure you want to logout?", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in
                UserDefaults.standard.set("", forKey: "uid")
           //            self.navigationItem.title = "Profile"
           //            self.navigationItem.rightBarButtonItem?.isEnabled = false
                self.performSegue(withIdentifier: "unwindToContainerVC", sender: self)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {_ in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
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
        yourVC.delegate = self
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
                                
                                let obj = TeamList(activity_id: activityId, activity_name: activityName, desc: Description, activity_image: activityImg, joined_members: joinMembers, fundRaise: "", fund_donate: 0, createdBy: "", daysLeft: "", createdPic: "")
                                
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
    

