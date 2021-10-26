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
    
    var videoModel: HomeModel?
    var videoMsg: HomeMsg?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getVideos(offset: 0)
        profileImgView.layer.masksToBounds = false
        profileImgView.layer.cornerRadius = profileImgView.frame.height/2
        profileImgView.clipsToBounds = true
        profileImgView.layer.borderWidth = 2.0
        profileImgView.layer.borderColor = UIColor.white.cgColor
    }
    
    //MARK: Get all videos api
    func getVideos(offset: Int) {
        let url : String = self.appDelegate.baseUrl!+self.appDelegate.showMyAllVideos!

        let parameter :[String:Any]? = ["my_fb_id":UserDefaults.standard.string(forKey: "uid")!,"fb_id":UserDefaults.standard.string(forKey: "uid")!,"offset":"0"]
        let headers: HTTPHeaders = ["api-key": "4444-3333-2222-1111"]
        
        //https://realtynextt.com/API/index.php?p=discover_new
        Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers).validate().responseData { [weak self] (responseData) in
            switch responseData.result {
            case .success(let json):
                do {
                    self?.videoModel = try JSONDecoder().decode(HomeModel.self, from: json)
                    if let code = self?.videoModel?.code, (code == "200") {
                        DispatchQueue.main.async {
                            let name = (self?.videoMsg?.user_info?.first_name ?? "") + " " + (self?.videoMsg?.user_info?.last_name ?? "")
                            self?.UserTypeLbl.text = self?.videoMsg?.user_info?.username ?? ""
                            self?.UserNameLbl.text = name
                            //self?.CoinLbl.text = name
                            
                            let str = "\(self?.videoMsg?.user_info?.profile_pic ?? "")friendship.png"
                            #warning("temp added becuase URL from response is not completed.")

                            self?.userImg.sd_setImage(with: URL(string: str), placeholderImage: UIImage(), options: SDWebImageOptions.continueInBackground, completed: nil)
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
    
    func getAllVideos(offset1: Int){
//        viewMyVideos.isHidden = true
//        viewLikeVideo.isHidden = true
//        flagforMyVideo = true

        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.isTranslucent = true

        let url : String = self.appDelegate.baseUrl!+self.appDelegate.showMyAllVideos!
       // let  sv = HomeViewController.displaySpinner(onView: self.view)

          let parameter :[String:Any]? = ["my_fb_id":UserDefaults.standard.string(forKey: "uid")!,"fb_id":UserDefaults.standard.string(forKey: "uid")!,"offset":"0"]
      //  let parameter :[String:Any]? = ["my_fb_id":"117825544243100354284","fb_id":"117825544243100354284","offset":"0"]
    //    let parameter :[String:Any]? = ["my_fb_id":"10158924645617150","fb_id":"10158924645617150", "middle_name": self.appDelegate.middle_name,"offset":0]

//        print(url)
//        print(parameter!)

        let headers: HTTPHeaders = [
            "api-key": "4444-3333-2222-1111"
        ]

        Alamofire.request(url, method: .post, parameters:parameter, encoding:JSONEncoding.default, headers:headers).validate().responseJSON(completionHandler: {

            respones in
            print(respones)
            switch respones.result {
            case .success( let value):

                let json  = value

              //  HomeViewController.removeSpinner(spinner: sv)
              //  self.collectionview.bottomRefreshControl?.endRefreshing()

//                self.allVideos = []
                  print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! NSString
                if(code == "200"){

                    if let myCountry = dic["msg"] as? NSArray{

                        if  let sectionData = myCountry[0] as? NSDictionary{
//
                            self.totalVideoCount = sectionData["total_video_count"] as? Int ?? 0
                            self.likeVideoCount = sectionData["total_like_count"] as? Int ?? 0
//
                            let user_info = sectionData["user_info"] as? NSDictionary
                            let str1:String! = (user_info!["first_name"] as! String)
                            let str2:String! = (user_info!["last_name"] as! String)
//                          //  self.navigationItem.title = str1+" "+str2
                            self.UserNameLbl.text = str1 + str2
                            self.UserTypeLbl.text = (user_info!["username"] as! String)

                            var tempProductList = ItemVideo()
//
                            if let  myCountry1 = (sectionData["user_videos"] as? [[String:Any]]){
                                if myCountry1.count == 0 || myCountry1.isEmpty || myCountry1 == nil{
//
                                }else if myCountry1.count == 1{
//
                                    let count = myCountry1[0]["count"] as! NSDictionary

                                    let view = count["view"] as! String
                                     tempProductList.view_count = count["view"] as? String
                                    let thum = myCountry1[0]["thum"] as! String
                                    let v_id = myCountry1[0]["id"] as! String
                                    let video = myCountry1[0]["video"] as! String
                                    let desc = myCountry1[0]["description"] as! String
                                    let first_name = user_info?["first_name"] as! String
                                    let last_name = user_info?["last_name"] as! String
                                    let profile_pic = user_info?["profile_pic"] as! String
                                    let liked = myCountry1[0]["liked"] as! String
                                    let u_id = user_info?["fb_id"] as! String
                                    let share = count["share_count"] as! String
                                    let like = count["like_count"] as! String
                                    let obj = Videos(thum: thum, first_name: first_name, last_name: last_name, profile_pic: profile_pic, v_id: v_id, view: view,u_id:u_id, video: video, desc: desc, username: self.UserTypeLbl.text, shareCount: share, likeCount: like, liked: liked)
                                    
//                                    if self.totalVideoCount == self.allVideos.count{
//
//                                    }else{
                                        self.allVideos.append(obj)
//                                    }
//
//
                                }else{
//
                                    for Dict in myCountry1 {
//
                                        let count = Dict["count"] as! NSDictionary
                                        let view = count["view"] as! String
                                        tempProductList.view_count = count["view"] as? String
                                        let thum = Dict["thum"] as! String
                                        let v_id = Dict["id"] as! String
                                        let video = Dict["video"] as! String
                                        let desc = Dict["description"] as! String
                                        let first_name = user_info?["first_name"] as! String
                                        let last_name = user_info?["last_name"] as! String
                                      let profile_pic = user_info?["profile_pic"] as! String
                                        let username = user_info?["username"] as! String
                                        let u_id = user_info?["fb_id"] as! String
                                        let share = count["share_count"] as! String
                                        let like = count["like_count"] as! String
                                        let liked = Dict["liked"] as! String
                                        let obj = Videos(thum: thum, first_name: first_name, last_name: last_name, profile_pic: profile_pic, v_id: v_id, view: view,u_id:u_id, video: video, desc: desc, username: username,shareCount: share,likeCount: like, liked: liked)
//
//                                        if self.totalVideoCount == self.allVideos.count{
//
//
//                                        }else{
//
                                            self.allVideos.append(obj)
//                                        }
                                    }
//
                                }
//                            }
//
                        }
                    }


//                    if(self.allVideos.count == 0){
//
//                        self.btnMyVideos.setTitle("My Videos (0)", for: .normal)
//                        self.btnLikeVideos.setTitle("Like Videos (\(String(self.likeVideoCount)))", for: .normal)
//                        self.outer_view.alpha = 1
//
//                        self.collectionview.delegate = self
//                        self.collectionview.dataSource = self
//                        self.collectionview.reloadData()
//
//                    }else{
//
//                        self.btnMyVideos.setTitle("My Videos (\(String(self.totalVideoCount)))", for: .normal)
//                        self.btnLikeVideos.setTitle("Like Videos (\(String(self.likeVideoCount)))", for: .normal)
//                        self.outer_view.alpha = 0
//
                        self.createVdCollectionView.delegate = self
                        self.createVdCollectionView.dataSource = self
                        self.createVdCollectionView.reloadData()
                    }


                }else{

                //    self.alertModule(title:"Error", msg:dic["msg"] as! String)

                    print(dic["msg"] as! String)
                }

            case .failure(let error):
                print(error)
//                HomeViewController.removeSpinner(spinner: sv)
//                self.alertModule(title:"Error",msg:error.localizedDescription)
            }
        })


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
    
    //MARK: Collectionview Deleagte methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allVideos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        var cell = UICollectionViewCell()
//        if indexPath.item == 0{
//            let cell1:CreateVideoTableViewCell = self.collectionview.dequeueReusableCell(withReuseIdentifier: "CreateVideoTableViewCell", for: indexPath) as! CreateVideoTableViewCell
//            // let obj = self.allVideos[indexPath.item] as! Videos
//            // cell.lbl_seen.text = obj.view
//            let colors = [UIColor(red: 255/255, green: 81/255, blue: 47/255, alpha: 1.0), UIColor(red: 221/255, green: 36/255, blue: 181/255, alpha: 1.0)]
//            cell1.btnView.setGradientBackgroundColors(colors, direction: .toBottom, for: .normal)
//            //  cell.video_image.sd_setImage(with: URL(string:obj.thum), placeholderImage: UIImage(named:“placeholderImg”))
//            cell = cell1
//        }else {
            let cell1:ProfileCVC = self.createVdCollectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCVC", for: indexPath) as! ProfileCVC
            let obj = self.allVideos[indexPath.item]
            cell1.lblSeen.text = obj.view
    
        let url = URL(string: obj.thum)

        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                cell1.videoImg.image = UIImage(data: data!)
            }
        }
      //  cell1.videoImg.image = downloadImage(from: URL(string: obj.thum)!)

//            cell = cell1
//        }
        return cell1
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
        let obj = self.allVideos[indexPath.row] 
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: PlayerVC = storyboard.instantiateViewController(withIdentifier: "PlayerVC") as! PlayerVC
        vc.selectedVideo = obj
        //vc.myVideoURL = URL(string: obj.video)
       // vc.videoId = obj.v_id
//        if indexPath.row > 0{
//            let range = 0...(indexPath.row - 1)
//            self.allVideos.removeSubrange(range)
//        }
//        vc.friends_array = self.allVideos
        self.navigationController?.pushViewController(vc, animated: true)

    }
}

