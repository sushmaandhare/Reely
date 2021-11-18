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
        NotificationCenter.default.addObserver(self, selector: #selector(self.successVideoUpload(_ :)), name: Notification.Name("uploadvideo"), object: nil)
    }
    
    @objc func successVideoUpload(_ center: NotificationCenter){
        NotificationCenter.default.removeObserver(self, name: Notification.Name("uploadvideo"), object: nil)
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
        
        let url : String = self.appDelegate.baseUrl!+self.appDelegate.showAllVideos!
                
        let parameter:[String:Any]?  = ["fb_id":UserDefaults.standard.string(forKey: "uid")!,"videos_id":"","offset": "0","type":"related"]
        
        let headers: HTTPHeaders = [
            "api-key": "4444-3333-2222-1111"
        ]
        
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
    }

    func getDiscoverVideos() {
        let url : String = self.appDelegate.baseUrl!+self.appDelegate.discover!
        let parameter :[String:Any]? = ["fb_id":UserDefaults.standard.string(forKey: "uid")!,
                                        "middle_name":"osd191k3hEZm5PzMfoboJy5l466w7szI",
                                        "offset":"0",
                                        "section_id":"1"]
        let headers: HTTPHeaders = ["api-key": "4444-3333-2222-1111"]
        
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
    }
}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
    


