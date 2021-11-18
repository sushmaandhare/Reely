//
//  UserProfileViewController.swift
//  Reely - Create Transform & Donate
//
//  Created by MacBook Air on 02/06/1943 Saka.
//

import UIKit
import Alamofire
import SDWebImage

class UserProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var profileImgView: UIView!
    @IBOutlet weak var verifyImgView: UIImageView!
    @IBOutlet weak var createVdCollectionView: UICollectionView!
    @IBOutlet weak var CoinLbl: UILabel!
    @IBOutlet weak var UserTypeLbl: UILabel!
    @IBOutlet weak var UserNameLbl: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var allVideos: [Videos] = []
    var likeVideoCount : Int = 0
    var totalVideoCount = 0
    
    var profileModel: ProfileModel?
    var myVideo = [Sections_videos]()
    var teamVideo = [Sections_videos]()
    
    var isMyVideo = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getVideos(offset: 0)
        profileImgView.layer.masksToBounds = false
        profileImgView.layer.cornerRadius = profileImgView.frame.height/2
        profileImgView.clipsToBounds = true
        profileImgView.layer.borderWidth = 2.0
        profileImgView.layer.borderColor = UIColor.white.cgColor
    }
    
    @IBAction func onTapMyVideos(_ sender: UIButton) {
        isMyVideo = true
        self.createVdCollectionView.reloadData()
    }
    
    @IBAction func onTapTeamVideos(_ sender: UIButton) {
        isMyVideo = false
        self.createVdCollectionView.reloadData()
    }
    
    func getVideos(offset: Int) {
        let url : String = self.appDelegate.baseUrl!+self.appDelegate.showMyAllVideos!
        
        let parameter :[String:Any]? = ["my_fb_id": UserDefaults.standard.string(forKey: "uid")!,"fb_id": UserDefaults.standard.string(forKey: "uid")!,"offset":"0"]
        let headers: HTTPHeaders = ["api-key": "4444-3333-2222-1111"]
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers).validate().responseData { [weak self] (responseData) in
            print(String.init(data: responseData.data!, encoding: .utf8))
            switch responseData.result {
            case .success(let json):
                do {
                    self?.profileModel = try JSONDecoder().decode(ProfileModel.self, from: json)
                    if let code = self?.profileModel?.code, (code == "200") {
                        DispatchQueue.main.async {
                            
                            //this is userinfo
                            let userName = self?.profileModel?.msg?.first?.user_info
                            let name = (userName?.first_name ?? "") + " " + (userName?.last_name ?? "")
                            self?.UserTypeLbl.text = userName?.username ?? ""
                            self?.UserNameLbl.text = name
                            //self?.CoinLbl.text = name
                            
                            let str = "\(userName?.profile_pic ?? "")friendship.png"
#warning("temp added becuase URL from response is not completed.")
                            
                            self?.userImg.sd_setImage(with: URL(string: str), placeholderImage: UIImage(named:"create-1"), options: SDWebImageOptions.continueInBackground, completed: nil)
                            
                            
                            
                            //this is myVideo
                            self?.myVideo = self?.profileModel?.msg?.first?.user_videos ?? []
                            
                            //this is team video
                            self?.teamVideo = self?.profileModel?.msg?.first?.team_videos ?? []
                            
                            self?.createVdCollectionView.reloadData()
                        }
                    }
                } catch let error {
                    print(error)
                }
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    @IBAction func FollowersBtnAction(_ sender: Any) {
    }
    
    @IBAction func FollowingBtnAction(_ sender: Any) {
    }
    
    @IBAction func PostBtnAction(_ sender: Any) {
    }
    
    @IBAction func CoinStatusBtnAction(_ sender: Any) {
    }
    
    @IBAction func AchievmntBtnActn(_ sender: Any) {
    }
    
    @IBAction func SettingBtnAction(_ sender: Any) {
        //           UserDefaults.standard.set("", forKey: "uid")
        //            self.navigationItem.title = "Profile"
        //            self.navigationItem.rightBarButtonItem?.isEnabled = false
        //        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func onTapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isMyVideo ? myVideo.count : teamVideo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ProfileCVC = self.createVdCollectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCVC", for: indexPath) as! ProfileCVC
        let obj = isMyVideo ? self.myVideo[indexPath.item] : self.teamVideo[indexPath.item]
        
        //        cell.lblSeen.text = obj.view
        
        let url = URL(string: obj.thum ?? "")
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                cell.videoImg.image = UIImage(data: data!)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width/3.0
        let yourHeight = yourWidth
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //         if indexPath.row >= allVideos.count {  //numberofitem count
        //             updateNextSet()
        //         }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllHorizontalCollectionVC") as? ViewAllHorizontalCollectionVC {
            controller.sections_videos = isMyVideo ? self.myVideo : self.teamVideo
            controller.selectedIndex = indexPath.item
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

