//
//  HomeViewController.swift
//  Reely - Create Transform & Donate
//
//  Created by Mac on 11/08/21.
//

import UIKit
import Alamofire
import AVKit
import AVFoundation
import SDWebImage

class HomeViewController: UIViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var totalVideoCount = 0
   // var homeArr : [Home] = []
    var index:Int! = 0
    var Newssection:NSMutableArray = []
  //  var video_array =  [Discover]()
    
    var homeModel: HomeModel? //upper view // video
    var videoModel: VideoModel? //lower view //discover
    
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var homeVideoCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.isTranslucent = true
        self.homeTableView.delegate = self
        self.homeTableView.dataSource = self
        
        self.homeVideoCollectionView.delegate = self
        self.homeVideoCollectionView.dataSource = self
        callHomeAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false

    }
    
    private func callHomeAPI() {
        HomeVideoApi(offset: 0)
        getDiscoverVideos()
    }
    
    @IBAction func CartBtnAction(_ sender: Any) {
    }
    
    @IBAction func NotificationBtnAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let yourVC: NotificationsViewController = storyboard.instantiateViewController(withIdentifier: "NotificationsViewController") as! NotificationsViewController
        self.navigationController?.pushViewController(yourVC, animated: true)
    }
    
    @IBAction func MsgBtnAction(_ sender: Any) {
    }
    
    
    @IBAction func ProfileBtnAction(_ sender: Any) {
        
    }
    
    @IBAction func onTapLogout(_ sender: UIButton) {
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
    
    func HomeVideoApi(offset: Int?){
        // let  sv = HomeViewController.displaySpinner(onView: self.view)
        
        let url : String = self.appDelegate.baseUrl!+self.appDelegate.showAllVideos!
        
      //  let udid = UIDevice.current.identifierForVendor?.uuidString
        
        let parameter:[String:Any]?  = ["fb_id":UserDefaults.standard.string(forKey: "uid")!,"videos_id":"","offset": "0","type":"related"]
        
        let headers: HTTPHeaders = [
            "api-key": "4444-3333-2222-1111"
        ]
        
        //"https://realtynextt.com/API/index.php?p=showAllVideosNew"
        Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers).validate().responseData { [weak self] (responseData) in
            switch responseData.result {
            case .success(let json):
                do {
                    self?.homeModel = try JSONDecoder().decode(HomeModel.self, from: json)
                    if let code = self?.homeModel?.code, (code == "200") {
                        DispatchQueue.main.async {
                            self?.homeVideoCollectionView.reloadData()
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

//        Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers).validate().responseJSON(completionHandler: {
//            respones in
//            print(String.init(data: respones.data!, encoding: .utf8))
//            switch respones.result {
//
//            case .success( let json):
//
//
//
//
//                let dic = json as! NSDictionary
//                let code = dic["code"] as! NSString
//
//                if(code == "200"){
//                    if let count = dic["total_video_count"] as? String{
//                        self.totalVideoCount = Int(count) ?? 0
//                        print(self.totalVideoCount)
//                    }
//
//
//                    let myCountry = (dic["msg"] as? [[String:Any]])!
//                    //                 print("video count",myCountry.count)
//                    for Dict in myCountry {
//
//                        let myRestaurant = Dict as NSDictionary
//
//                        let count = myRestaurant["count"] as! NSDictionary
//                        let Username = myRestaurant["user_info"] as! NSDictionary
//                        let sound = myRestaurant["sound"] as! NSDictionary
//                        let sound_id = sound["id"] as? String
//                        let audio_patha = sound["audio_path"] as! NSDictionary
//                        let audio_path:String! =   audio_patha["acc"] as? String
//                        //                    let obj1 = SoundObj(sound_id: sound_id, audioUrl: audio_path)
//                        //                    self.sound_array.add(obj1)
//
//                        let shareCount = count["share"] as? String
//                        let like_count = count["like_count"] as? String
//
//                        let video_comment_count = count["video_comment_count"] as? String
//                        let view_count = count["view"] as? String
//
//                        let sound_name = sound["sound_name"] as? String
//                        let video_url:String! =   myRestaurant["video"] as? String
//                        //                        let video_url = "https://www.radiantmediaplayer.com/media/big-buck-bunny-360p.mp4"
//
//                        let u_id:String! =   myRestaurant["fb_id"] as? String
//                        let v_id:String! =   myRestaurant["id"] as? String
//                        let thum:String! =   myRestaurant["thum"] as? String
//                        let username:String! =   Username["username"] as? String
//                        let last_name:String! =   Username["last_name"] as? String
//                        let profile_pic:String! =   Username["profile_pic"] as? String
//                        let like:String! =   myRestaurant["liked"] as? String
//                        let isFollow:Int! = Dict["is_follow"] as? Int
//                        let desc:String! =   myRestaurant["description"] as? String
//                        let first_name:String! =   Username["first_name"] as? String
//                        let allow_comment:String! =   myRestaurant["allow_comments"] as? String
//                        let allow_duet:String! =   myRestaurant["allow_duet"] as? String
//                        //    print("is follow",isFollow)
//                        let obj = Home(like_count: like_count, video_comment_count: video_comment_count, sound_name: sound_name,thum: thum, first_name: first_name, last_name: last_name,profile_pic: profile_pic, video_url: video_url, v_id: v_id, u_id: u_id, like: like, desc: desc, username: username, view_count: view_count, allow_comment: allow_comment, allow_duet: allow_duet, isFollow: isFollow, share_count: shareCount, sound_id: sound_id ?? "0", sound_url: audio_path)
//
//                        self.homeArr.append(obj)
//
//
//                    }
//
//                    self.getDiscoverVideos()
//                }else{
//
//                    //  print(dic["msg"] as! String)
//                    // self.alertModule(title:"Error", msg:dic["msg"] as! String)
//
//                }
//
//            case .failure(let error):
//
//                print(error.localizedDescription)
//
//            // HomeViewController.removeSpinner(spinner: sv)
//            // self.alertModule(title:"Error",msg:error.localizedDescription)
//
//
//            }
//        })
        
        
        
    }

    func getDiscoverVideos() {
        
        let url : String = self.appDelegate.baseUrl!+self.appDelegate.discover!

        let parameter :[String:Any]? = ["fb_id":UserDefaults.standard.string(forKey: "uid")!,
                                        "middle_name":"osd191k3hEZm5PzMfoboJy5l466w7szI",
                                        "offset":"0",
                                        "section_id":"1"]
        let headers: HTTPHeaders = ["api-key": "4444-3333-2222-1111"]
        
        //https://realtynextt.com/API/index.php?p=discover_new
        Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers).validate().responseData { [weak self] (responseData) in
            switch responseData.result {
            case .success(let json):
                do {
                    self?.videoModel = try JSONDecoder().decode(VideoModel.self, from: json)
                    if let code = self?.videoModel?.code, code == "200" {
                        DispatchQueue.main.async {
                            self?.homeTableView.reloadData()
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
        
//        Alamofire.request(url, method: .post, parameters:parameter, encoding:JSONEncoding.default, headers:headers).validate().responseJSON(completionHandler: {
//
//            respones in
//
//            switch respones.result {
//            case .success( let value):
//
//                let json  = value
//
////                self.hashArr.removeAll()
////                self.video_array = []
//                self.Newssection = []
//                print(json)
//                let dic = json as! NSDictionary
//                let code = dic["code"] as! NSString
//                if(code == "200"){
//
//                    if let myCountry = dic["msg"] as? NSArray{
//                        for i in 0...myCountry.count-1{
//
//                            if  let sectionData = myCountry[i] as? NSDictionary{
//
//                                var tempMenuObj = Discover()
//                                tempMenuObj.name = sectionData["section_name"] as? String
//                                tempMenuObj.hashtagIcon = sectionData["section_icon"] as? String ?? " "
//                                tempMenuObj.totalView = sectionData["section_views"] as! String
//                                tempMenuObj.section_Id = sectionData["section_id"] as? String
//                                self.Newssection.add(tempMenuObj.name!)
//                               // self.hashArr.append(tempMenuObj.name!)
//                                tempMenuObj.sectionInd = i
//                                if let extraData = sectionData["sections_videos"] as? NSArray{
//
//                                    for j in 0...extraData.count-1{
//
//                                        let dic2 = extraData[j] as! [String:Any]
//                                        var tempProductList = sectionVideos()
//
//                                        tempProductList.description = dic2["description"] as? String
//
//                                        if let count = dic2["count"] as? NSDictionary{
//
//                                            tempProductList.like_count = count["like_count"] as? String
//
//                                            tempProductList.view_count = count["view"] as? String
//
//                                            tempProductList.share = count["share"] as? String
//                                        }
//
//                                        if let user_info = dic2["user_info"] as? NSDictionary{
//
//                                            tempProductList.username = user_info["username"] as? String ?? "No Name"
//                                            tempProductList.first_name = user_info["first_name"] as? String ?? ""
//                                            tempProductList.last_name = user_info["last_name"] as? String
//
//                                            tempProductList.profile_pic = user_info["profile_pic"] as? String
//
//                                            tempProductList.u_id = user_info["fb_id"] as? String
//                                        }
//
//
//                                        tempProductList.video = dic2["video"] as? String
//                                        tempProductList.thum = dic2["thum"] as? String
//                                        tempProductList.liked = dic2["liked"] as? String
//                                        tempProductList.v_id = dic2["id"] as? String
//
//                                        if let sound = dic2["sound"] as? NSDictionary{
//                                            let audio_patha = sound["audio_path"] as! NSDictionary
//                                            tempProductList.sound_name = sound["sound_name"] as? String
//                                            tempProductList.audio_url = audio_patha["acc"] as! String
//                                            tempProductList.s_id = sound["id"] as? String
//                                        }
//
//                                        tempMenuObj.listOfProducts.append(tempProductList)
//
//                                    }
//
//                                }
//
//                                self.video_array.append(tempMenuObj)
//                                print(self.video_array.count)
//                            }
//
//                        }
//
//                    }
//
//                    self.HomeTableView.delegate = self
//                    self.HomeTableView.dataSource = self
//                    self.HomeTableView.reloadData()
//
//                }else{
//                    //self.refreshControl.endRefreshing()
//
//                }
//
//            case .failure(let error):
//                print(error)
//
//                //self.tableview.hideLoading()
//                //to hide the loader
//
//            }
//        })
    }
    
//    func DailyAppVisit(){
//        var deviceID = ""
//        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
//            deviceID = uuid
//        }
//        
//        let url : String = self.appDelegate.baseUrl!+self.appDelegate.DailyAppVisit!
//        
//        let parameter :[String:Any]? = ["fb_id":UserDefaults.standard.string(forKey: "uid") ?? "", "middle_name": self.appDelegate.middle_name]
//        
//        let headers: HTTPHeaders = [
//            "api-key": "4444-3333-2222-1111"
//        ]
//  
//        AF.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:headers).validate().responseJSON(completionHandler: {
//            
//            respones in
//            
//            switch respones.result {
//            case .success( let value):
//                let json  = value
//           
//              //  print(json)
//            
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        })
//    }
    
}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.videoModel?.msg?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videoModel?.msg?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeHashtagTVC", for: indexPath) as? HomeHashtagTVC {
            cell.videoMsg = self.videoModel?.msg?[indexPath.row]
            cell.callBack = { [weak self] (object) in
                if let str = object as? String, str == "views" {
                    if let controller = self?.storyboard?.instantiateViewController(identifier: "HashTagViewController") as? HashTagViewController {
                        controller.videoMsg = self?.videoModel?.msg?[indexPath.row]
                        self?.navigationController?.pushViewController(controller, animated: true)
                    }
                }else if let obj = object as? (String, Sections_videos), obj.0 == "video" {
                    if let controller = self?.storyboard?.instantiateViewController(withIdentifier: "VideoPlayerVC") as? VideoPlayerVC {
                        controller.selectedVideo = obj.1
                        self?.navigationController?.pushViewController(controller, animated: true)
                    }
                }
                
            }
            return cell
        }
        return UITableViewCell(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
//    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if let tvc = self.homeTableView.dequeueReusableCell(withIdentifier: "HomeVideoTVC") as? HomeVideoTVC{
//            let visiblePaths = tvc.HomeVideoCV.indexPathsForVisibleItems
//
//            for i in visiblePaths  {
//                let cell = tvc.HomeVideoCV.cellForItem(at: i) as? HomeVideoCollectionViewCell
//            if keyPath == "timeControlStatus", let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
//                let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
//                let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
//                if newStatus != oldStatus {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {[weak self] in
//                        if newStatus == .playing || oldStatus == .paused  {
////                            cell?.progressView.signal()
////                            cell?.progressView.isHidden = true
//                           // cell?.player?.play()
//                        } else {
//
////                             cell?.progressView.wait()
////                            cell?.progressView.isHidden = false
//                           // cell?.player?.pause()
//
//                        }
//                    })
//                }
//            }
//            }
//        }
//    }
    
   
        
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.homeModel?.msg?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeVideoCollectionViewCell", for: indexPath) as? HomeVideoCollectionViewCell {
            cell.homeMsg = self.homeModel?.msg?[indexPath.item]
            cell.btnPayView.setImage(UIImage(named: "ic_play"), for: .normal)
            cell.btnPayView.isHidden = true
            cell.btnPayView.tag = indexPath.row
           
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            cell.viewInnerView.addGestureRecognizer(tap)
            cell.viewInnerView.isUserInteractionEnabled = true
            cell.viewInnerView.tag = indexPath.item
            
            cell.callBack = { (isLiked: Bool) in
                if isLiked {
                    let count = (Int(self.homeModel?.msg?[indexPath.item].count?.like_count ?? "0") ?? 0) + 1
                    self.homeModel?.msg?[indexPath.item].count?.like_count = "\(count)"
                    self.homeModel?.msg?[indexPath.item].liked = "1"
                }else {
                    let count = (Int(self.homeModel?.msg?[indexPath.item].count?.like_count ?? "0") ?? 0) - 1
                    self.homeModel?.msg?[indexPath.item].count?.like_count = "\(count)"
                    self.homeModel?.msg?[indexPath.item].liked = "0"
                }
            }
            
            if self.homeModel?.msg?[indexPath.item].is_follow == 0{
                cell.viewFollow.isHidden = false
                cell.btnFollow.isHidden = false
                cell.btnVerification.isHidden = true
            }else{
                cell.viewFollow.isHidden = true
                cell.btnFollow.isHidden = true
                cell.btnVerification.isHidden = false
            }
            
                cell.strCallBack = { [weak self] (object) in
                if let str = object as? String, str == "share" {
                    
                    let objectsToShare = [URL(string: self?.homeModel?.msg?[indexPath.item].video ?? "")] //comment!, imageData!, myWebsite!]
                    let activityVC = UIActivityViewController(activityItems: objectsToShare as [Any], applicationActivities: nil)
                   

                    activityVC.setValue("Video", forKey: "subject")
                        
                    //New Excluded Activities Code
                    if #available(iOS 9.0, *) {
                     activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.assignToContact, UIActivity.ActivityType.copyToPasteboard, UIActivity.ActivityType.mail, UIActivity.ActivityType.message, UIActivity.ActivityType.openInIBooks, UIActivity.ActivityType.postToTencentWeibo, UIActivity.ActivityType.postToVimeo, UIActivity.ActivityType.postToWeibo, UIActivity.ActivityType.print]
                    } else {
                        // Fallback on earlier versions
                     activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.assignToContact, UIActivity.ActivityType.copyToPasteboard, UIActivity.ActivityType.mail, UIActivity.ActivityType.message, UIActivity.ActivityType.postToTencentWeibo, UIActivity.ActivityType.postToVimeo, UIActivity.ActivityType.postToWeibo, UIActivity.ActivityType.print ]
                    }

                    //    self?.view.stopLoading()
                    self?.present(activityVC, animated: true, completion: nil)
                        
                }
                
            }
            return cell
        }
        return UICollectionViewCell(frame: .zero)
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        
        
        let myview = sender.view
        let buttonTag = myview?.tag
        let indexPath = IndexPath(row: buttonTag!, section: 0)
        let cell = homeVideoCollectionView.cellForItem(at: indexPath) as! HomeVideoCollectionViewCell
        cell.btnPayView.isHidden = false
        if(cell.btnPayView.currentImage == UIImage(named: "ic_play")){ //play
            
            
            cell.btnPayView.setImage( UIImage(named: "ic_pause"), for: .normal) //pause
            cell.player?.pause()

        }else if(cell.btnPayView.currentImage == UIImage(named: "ic_pause")){ //pause
      
                
                cell.btnPayView.setImage( UIImage(named: "ic_play"), for: .normal) //play
                cell.player?.play()
                cell.btnPayView.isHidden = true
        
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeVideoCollectionViewCell", for: indexPath) as? HomeVideoCollectionViewCell {
//            cell.btnPayView.isHidden = true
//            cell.player?.rate = 1.0
//            cell.imgView.sd_setImage(with: URL(string: self.homeModel?.msg?[indexPath.item].thum ?? ""), placeholderImage: UIImage(), options: SDWebImageOptions.continueInBackground, completed: nil)
//            cell.player?.play()
            //cell.player?.addObserver(self, forKeyPath:"timeControlStatus", options: [.old, .new], context: nil)
           // updateVideoData(ind: indexPath.item)
        //}
        if let cell = cell as? HomeVideoCollectionViewCell {
            DispatchQueue.main.async {
                //cell.player?.seek(to: CMTime.zero)
                cell.player?.play()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize: CGRect = UIScreen.main.bounds
        return CGSize(width: screenSize.width, height: 400)
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        for indexPath in indexPaths {
//            if let tempObj = self.homeModel?.msg?[indexPath.row] {
//                self.homeModel?.msg?[indexPath.row] = tempObj
//            }
//        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? HomeVideoCollectionViewCell {
            DispatchQueue.main.async {
                cell.player?.pause()
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let visibleCells = self.homeVideoCollectionView.visibleCells
//        for cell in visibleCells {
//            var _cell = cell as? HomeVideoCollectionViewCell
//            if self.homeVideoCollectionView.bounds.contains(_cell?.frame ?? CGRect()) {
//                _cell?.player?.play()
//            }else{
//                _cell?.player?.pause()
//            }
//        }
    }
//   @objc func onClickLike(_ sender : UIButton) {
//       //print(sender.tag)
//
//       var action:String! = ""
//
//       let buttonTag = sender.tag
//       let indexPath = IndexPath(row: buttonTag, section: 0)
//       let cell = coll.cellForItem(at: indexPath) as? HomeVideoCollectionViewCell
//       let obj = self.homeArr[buttonTag]
//
//       if(obj.like == "0"){
//
//           action = "1"
//
//           cell?.btn_like.setBackgroundImage(UIImage(named:"ic_like"), for: .normal)
//
//       }else{
//
//
//           cell?.btn_like.setBackgroundImage(UIImage(named:"ic_like_fill"), for: .normal)
//           action = "0"
//       }
//
//       let url : String = self.appDelegate.baseUrl!+self.appDelegate.likeDislikeVideo!
//
//       let parameter :[String:Any]? = ["fb_id":UserDefaults.standard.string(forKey: "uid")!,"video_id":obj.v_id!,"action":action!, "middle_name": self.appDelegate.middle_name]
//
////        print(url)
////        print(parameter!)
//
//       let headers: HTTPHeaders = [
//               "api-key": "4444-3333-2222-1111"
//           ]
//       Alamofire.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:nil).validate().responseString(completionHandler: {
//
//           respones in
//
//          // print(respones)
//
//           let jsondata = respones.data
//           //print("jsondata",jsondata)
//
//           switch respones.result {
//
//           case .success (let value):
//
//               let json  = value
//
//            //   print(json)
//
//            //   let dic = json as! NSDictionary
//
//           //    let code = dic["code"] as! NSString
//             //  if(code == "200"){
//
//                  obj.like = action
//
//
//                   if(obj.like == "0"){
//
//
//                       cell?.btn_like.setBackgroundImage(UIImage(named:"ic_like"), for: .normal)
//
//                       if(Int(obj.like_count)! > 0){
//
//                           let str:Int = Int(obj.like_count)! - 1
//                           obj.like_count = String(str)
//
//                           cell?.lblLikeCount.text = String(obj.like_count)
//
//                       }
//
//                   }else{
//
//                       let str:Int = Int(obj.like_count)! + 1
//                       obj.like_count = String(str)
//
//                      cell?.lblLikeCount.text = String(obj.like_count)
//                       cell?.btn_like.setBackgroundImage(UIImage(named:"ic_like_fill"), for: .normal)
//                   }
//
//
//             //  }else{
//
//
//
//            //   }
//
//           case .failure(let error):
//               print("error",error)
//           }
//       })
//       }
       
   }
    


