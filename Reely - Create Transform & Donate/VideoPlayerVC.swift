//
//  VideoPlayerVC.swift
//  Reely - Create Transform & Donate
//
//  Created by MacBook Air on 06/06/1943 Saka.
//

import UIKit
import AVKit
import AVFoundation
import Alamofire

class VideoPlayerVC:  UIViewController {
    
    
    //    func DismissVC() {
    //        UserDefaults.standard.set("", forKey: "audioUrl")
    //        UserDefaults.standard.set("", forKey: "soundId")
    //
    //        self.dismiss(animated: true, completion: {
    //            self.delegate?.DismissPlayerVC()
    //        })
    //    }
    
    
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var lblShareCount: UILabel!
    @IBOutlet weak var lblViewCount: UILabel!
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var newView: UIView!
    
    //var selectedVideo: Videos!
    var selectedVideo: Sections_videos?
    var isLiked: Bool = false
    var socialMediaModel: SocialMediaModel?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    //  var myVideoURL: URL!
    var myPlayer: AVPlayer!
    let avPlayerViewController = PreviewViewController()
    // var thumImg: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        // print(self.videoId)
        
        userImg.layer.masksToBounds = false
        userImg.layer.cornerRadius = userImg.frame.height/2
        userImg.clipsToBounds = true
        userImg.layer.borderWidth = 1.0
        userImg.layer.borderColor = UIColor.white.cgColor
        
        
        //  DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
        //
        let video = URL(string: selectedVideo?.video ?? "")
        self.myPlayer = AVPlayer(url: video!)
        self.avPlayerViewController.view.frame.size.height = self.newView.frame.size.height
        self.avPlayerViewController.view.frame.size.width = self.newView.frame.size.width
        self.avPlayerViewController.player = self.myPlayer
        
        //  let playerLayer = AVPlayerLayer(player: myPlayer)
        // playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        //  avPlayerViewController.view.frame = self.view.frame
        self.newView.addSubview(self.avPlayerViewController.view)
        self.addChild(self.avPlayerViewController)
        self.avPlayerViewController.didMove(toParent: self)
        self.myPlayer?.play()
        avPlayerViewController.showsPlaybackControls = false
        avPlayerViewController.videoGravity = .resize
        //   self.thumImg = Helper().generateThumbnail(path: self.myVideoURL)
        //    }
        self.lblUsername.text = self.selectedVideo?.user_info?.username ?? ""
        self.lblViewCount.text = self.selectedVideo?.count?.view ?? "0"
        //        self.lblLikeCount.text = self.selectedVideo.
        //        self.lblShareCount.text = self.selectedVideo.username
        
        self.lblLikeCount.text = self.selectedVideo?.count?.like_count ?? ""
        if let count = selectedVideo?.liked, (count == "0") {
            self.btnLike.setBackgroundImage(UIImage(named:"ic_like"), for: .normal)
        }else{
            self.btnLike.setBackgroundImage(UIImage(named:"ic_like_fill"), for: .normal)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTapShare(_ sender: UIButton)
    {
            let objectsToShare = [URL(string: self.selectedVideo?.video ?? "")] //comment!, imageData!, myWebsite!]
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
            self.present(activityVC, animated: true, completion: nil)
        }

    @IBAction func onTapLike(_ sender: UIButton) {
        
        let action = self.isLiked ? "0": "1"
        
        let url : String = self.appDelegate.baseUrl!+self.appDelegate.likeDislikeVideo!
        
        //  let udid = UIDevice.current.identifierForVendor?.uuidString
        let parameter:[String:Any]?  = ["fb_id":UserDefaults.standard.string(forKey: "uid")!,
                                        "video_id":selectedVideo?.id ?? "0",
                                        "middle_name":"osd191k3hEZm5PzMfoboJy5l466w7szI",
                                        "action": action]
        
        let headers: HTTPHeaders = [
            "api-key": "4444-3333-2222-1111"
        ]
        
        //"https://realtynextt.com/API/index.php?p=likeDislikeVideo"
        Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers).validate().responseData { [weak self] (responseData) in
            switch responseData.result {
            case .success(let json):
                do {
                    self?.socialMediaModel = try JSONDecoder().decode(SocialMediaModel.self, from: json)
                    if let code = self?.socialMediaModel?.code, (code == "200") {
                        //DispatchQueue.main.async { [weak self] in
                        self?.isLiked.toggle()
                        if let flag = self?.isLiked, flag {
                            let count = (Int(self?.selectedVideo?.count?.like_count ?? "0") ?? 0) + 1
                            self?.selectedVideo?.count?.like_count = "\(count)"
                            self?.lblLikeCount.text = "\(count)"
                            self?.btnLike.setBackgroundImage(UIImage(named:"ic_like_fill"), for: .normal)
                        }else{
                            let count = (Int(self?.selectedVideo?.count?.like_count ?? "0") ?? 0) - 1
                            self?.selectedVideo?.count?.like_count = "\(count)"
                            self?.lblLikeCount.text = "\(count)"
                            self?.btnLike.setBackgroundImage(UIImage(named:"ic_like"), for: .normal)
                        }
                        //}
                    }
                } catch let error {
                    print(error)
                }
            case .failure(let error):
                print(error)
                break
            }
        }
        
        
        
        /*//cell.btn_like.setBackgroundImage(UIImage(named:"ic_like"), for: .normal)
         var action:String! = ""
         
         if let count = selectedVideo?.liked, (count == "0") {
         action = "1"
         self.btnLike.setBackgroundImage(UIImage(named:"ic_like_fill"), for: .normal)
         }else {
         action = "0"
         self.btnLike.setBackgroundImage(UIImage(named:"ic_like"), for: .normal)
         }
         
         
         let url : String = self.appDelegate.baseUrl!+self.appDelegate.likeDislikeVideo!
         
         let parameter :[String:Any]? = ["fb_id":UserDefaults.standard.string(forKey: "uid")!,"video_id":selectedVideo?.id ?? "0","action":action!]
         
         //        print(url)
         //        print(parameter!)
         
         let headers: HTTPHeaders = [
         "api-key": "4444-3333-2222-1111"
         ]
         Alamofire.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:nil).validate().responseString(completionHandler: {
         
         respones in
         
         // print(respones)
         
         let jsondata = respones.data
         //print("jsondata",jsondata)
         
         switch respones.result {
         
         case .success (let value):
         
         let json  = value
         
         //   print(json)
         
         //   let dic = json as! NSDictionary
         
         //    let code = dic["code"] as! NSString
         //  if(code == "200"){
         
         self.selectedVideo?.liked = action
         
         
         if( self.selectedVideo.liked == "0"){
         
         
         self.btnLike.setBackgroundImage(UIImage(named:"ic_like"), for: .normal)
         
         if(Int( self.selectedVideo.likeCount)! > 0){
         
         let str:Int = Int( self.selectedVideo.likeCount)! - 1
         self.selectedVideo.likeCount = String(str)
         
         self.lblLikeCount.text = String( self.selectedVideo.likeCount)
         
         }
         
         }else{
         
         let str:Int = Int(self.selectedVideo.likeCount)! + 1
         self.selectedVideo.likeCount = String(str)
         
         self.lblLikeCount.text = String(self.selectedVideo.likeCount)
         self.btnLike.setBackgroundImage(UIImage(named:"ic_like_fill"), for: .normal)
         }
         
         
         //  }else{
         
         
         
         //   }
         
         case .failure(let error):
         print("error",error)
         }
         })*/
    }
}
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    


class PreviewViewController: AVPlayerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        NotificationCenter.default.addObserver(self, selector: #selector(PreviewViewController.videoDidEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
//        self.player?.play()
        
    }
    
}

