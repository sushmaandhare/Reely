//
//  SelfTeamDetailsVC.swift
//  Reely - Create Transform & Donate
//
//  Created by MacBook Air on 13/07/1943 Saka.
//

import UIKit
import Alamofire
import SDWebImage
import MBCircularProgressBar

class SelfTeamDetailsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var progressBar: MBCircularProgressBarView!
    @IBOutlet weak var teamImg: UIImageView!
    @IBOutlet weak var lblTeamName: UILabel!
    @IBOutlet weak var lblTeamDesc: UILabel!
    @IBOutlet weak var lblTeamMember: UILabel!
    @IBOutlet weak var lblCreatedBy: UILabel!
    @IBOutlet weak var lblDaysLeft: UILabel!
    @IBOutlet weak var creatorPic: UIImageView!
    @IBOutlet weak var teamCV: UICollectionView!
    
    
    var activityId : String! = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var TeamMemberArray:[SelfTeamDetails]=[]
    var videos:[Videos]=[]
    var totalVideoCount : String? = "0"
    var totalLikeCount : String? = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.TeamDetailApiCall()
       // self.progressBar.value = 30.0
        // Do any additional setup after loading the view.
    }
    

   
    func TeamDetailApiCall(){
        
            let url : String = self.appDelegate.baseUrl!+self.appDelegate.selfTeamDetails!
        
        let parameter:[String:Any]?  = ["fb_id": UserDefaults.standard.string(forKey: "uid")!,"activity_id": self.activityId,"offset": "0"]
        //let parameter:[String:Any]?  = ["fb_id": "EocGotMQgmZCDVoNU3dXvcw2wG23","activity_id": self.activityId,"offset": "0"]
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
                                
                                let fb_id = Dict["fb_id"] as! String
//                                let total_heart = Dict["total_heart"] as! String
//                                let total_video_count = Dict["total_video_count"] as! String
//                                self.totalVideoCount = total_video_count
//                                let total_like_count = Dict["total_like_count"] as! String
//                                self.totalLikeCount = total_like_count
                                let activity_info = Dict["activity_info"] as! NSDictionary
                               
                                let activity_name = activity_info["activity_name"] as? String
                                let activityDesc = activity_info["description"] as? String
                                let activity_image = activity_info["activity_image"] as? String
                                let fund_raise = activity_info["fund_raise"] as? String
                                let last_date = activity_info["last_date"] as? String
                                let joined_members = activity_info["joined_members"] as? String
                                let is_verified = activity_info["is_verified"] as? String
                               // let fund_donate = activity_info["fund_donate"] as! String
                                let created_by = activity_info["created_by"] as? String
                                let creator_pic = activity_info["creator_pic"] as? String
                                let days_left = activity_info["days_left"] as? String
                              
                               if let user_videos = Dict["user_videos"] as? [[String:Any]]{
                             print(user_videos)
                                if user_videos.isEmpty == true{
                                    let obj = SelfTeamDetails(fb_id: fb_id, activity_name: activity_name, desc: activityDesc, activity_image: activity_image, joined_members: joined_members, fundRaise: fund_raise, last_date: last_date, is_verified: is_verified, total_heart: "", userVideo: [], fund_donate: "", created_by: created_by, creator_pic: creator_pic, days_left: days_left)
                                    
                                    self.TeamMemberArray.append(obj)
                                }
                                    for item in user_videos{
                                        let vid = item["id"] as! String
                                        let video = item["video"] as! String
                                        let thum = item["thum"] as! String
                                        let description = item["description"] as! String
                                        let liked = item["liked"] as! String
                                        let count = item["count"] as! NSDictionary
                                        let userInfo = item["user_info"] as! NSDictionary
                                        
                                        let username = userInfo["username"] as! String
                                        let first_name = userInfo["first_name"] as! String
                                        let last_name = userInfo["last_name"] as! String
                                        let profile_pic = userInfo["profile_pic"] as! String
                                        
                                        let like_count = count["like_count"] as! String
                                        let video_comment_count = count["video_comment_count"] as! String
                                        let view = count["view"] as! String
                                        let share_count = count["share_count"] as! String
                                        
                                        let sound = item["sound"] as! NSDictionary
                                        let sid = sound["id"] as! String
                                        let sound_name = sound["sound_name"] as! String
                                        let audio_path = sound["audio_path"] as! NSDictionary
                                        let acc = audio_path["acc"] as! String
                                        
                                        let videoObj = UserVideo(v_id: vid, video: video, thum: thum, description: description, liked: liked, likeCount: like_count, shareCount: share_count, viewCount: view, commentCount: video_comment_count, soundId: sid, soundName: sound_name, audioPath: acc)
                                        let videoarr = Videos(thum: thum, first_name: first_name, last_name: last_name, profile_pic: profile_pic, v_id: vid, view: view, u_id: fb_id, video: video, desc: description, username: username, shareCount: share_count, likeCount: like_count, liked: liked)
                                        
                                        let obj = SelfTeamDetails(fb_id: fb_id, activity_name: activity_name, desc: activityDesc, activity_image: activity_image, joined_members: joined_members, fundRaise: fund_raise, last_date: last_date, is_verified: is_verified, total_heart: "", userVideo: [videoObj], fund_donate: "", created_by: created_by, creator_pic: creator_pic, days_left: days_left)
                                        self.videos.append(videoarr)
                                        self.TeamMemberArray.append(obj)
                                        print(self.TeamMemberArray)
                                    }
                                
                               }
                               
                               
                            }
                            
                            self.updateUI()
                          //  self.tableview.reloadData()
                        }
                    
                }else{
                    
                    print(dic["msg"] as! String)
            
                    }
                    
                case .failure(let error):
                    
                    print(error.localizedDescription)
                    
               
                
                }
            })

        }

    
    func updateUI(){
        
        self.teamImg.sd_setImage(with: URL(string:TeamMemberArray.first?.activity_image ?? ""), placeholderImage: UIImage(named:"create-1"))
       // self.creatorPic.sd_setImage(with: URL(string:TeamMemberArray.first?.creator_pic ?? ""))
        //self.downloadImage(img: (TeamMemberArray.first?.activity_image)!)
        self.lblTeamName.text = TeamMemberArray.first?.activity_name
        self.lblTeamDesc.text = TeamMemberArray.first?.desc
        self.lblTeamMember.text = TeamMemberArray.first?.joined_members
//        self.lblCreatedBy.text = TeamMemberArray.first?.created_by
//        self.lblDaysLeft.text = TeamMemberArray.first?.days_left
//        progressBar.updateProgress(to: 0.7, animated: true)
//        progressBar.color = UIColor(red: 0, green: 255, blue: 0, alpha: 1)
        
        self.teamImg.layer.cornerRadius = self.teamImg.frame.height/2
        self.teamImg.clipsToBounds = true
        self.teamImg.layer.borderColor = UIColor.white.cgColor
        self.teamImg.layer.borderWidth = 1.0
        
//        self.creatorPic.layer.cornerRadius = self.creatorPic.frame.height/2
//        self.creatorPic.clipsToBounds = true
//        self.creatorPic.layer.borderColor = UIColor.white.cgColor
//        self.creatorPic.layer.borderWidth = 1.0
        
        self.teamCV.dataSource = self
        self.teamCV.delegate = self
        self.teamCV.reloadData()
    }
    
    @IBAction func onTapMember(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let yourVC: TeamMemberListVC = storyboard.instantiateViewController(withIdentifier: "TeamMemberListVC") as! TeamMemberListVC
        yourVC.activityId = self.activityId
        
        self.present(yourVC, animated: true, completion: nil)
    }
    
    @IBAction func onTapRaisedFund(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let yourVC: FundDonateListVC = storyboard.instantiateViewController(withIdentifier: "FundDonateListVC") as! FundDonateListVC
        yourVC.activityId = self.activityId
        yourVC.desc = lblTeamDesc.text ?? ""
        self.navigationController?.pushViewController(yourVC, animated: true)
    }
    
    @IBAction func onTapCreateVideo(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateViewController") as! CreateViewController
        vc.activityId = self.activityId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func downloadImage(img:String) {
        
        Alamofire.request(img).responseData(completionHandler: { response in
            debugPrint(response)
            
            debugPrint(response.result)
            
            if let image1 = response.result.value {
                let image = UIImage(data: image1)
                self.teamImg.image = image
                
            }
        })
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (TeamMemberArray.first?.userVideo.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if indexPath.item == 0{
//            let cell:CreateTeamVideoCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "CreateTeamVideoCVC", for: indexPath) as! CreateTeamVideoCVC
//            cell.btnPlus.addTarget(self, action: #selector(openCreateVideo), for: .touchUpInside)
//
//             return cell
//        }else{
            let cell:TeamVideoCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamVideoCVC", for: indexPath) as! TeamVideoCVC
            cell.videoImg.sd_setImage(with: URL(string:(TeamMemberArray.first?.userVideo[indexPath.row].thum)!), placeholderImage: UIImage(named:"create-1"))
            cell.lblView.text = TeamMemberArray.first?.userVideo[indexPath.row].viewCount
            return cell
  //      }
        
    }
    
//    @objc func openCreateVideo(){
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "CreateViewController") as! CreateViewController
//        vc.activityId = self.activityId
//         self.navigationController?.pushViewController(vc, animated: true)
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if indexPath.item == 0{
//            print("add")
//        }else{
        let obj = self.videos[indexPath.row] 
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: PlayerVC = storyboard.instantiateViewController(withIdentifier: "PlayerVC") as! PlayerVC
        vc.selectedVideo = obj
     
        self.navigationController?.pushViewController(vc, animated: true)
       // }
    }
    
    @IBAction func onTapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

