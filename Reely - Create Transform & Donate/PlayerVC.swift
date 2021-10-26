//
//  PlayerVC.swift
//  Reely - Create Transform & Donate
//
//  Created by MacBook Air on 20/07/1943 Saka.
//

import UIKit
import AVKit
import AVFoundation
import Alamofire

class PlayerVC: UIViewController {
    
    
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
    
    var selectedVideo: Videos!
    var isLiked: Bool = false
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var socialMediaModel: SocialMediaModel?
    
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
        self.lblUsername.text = self.selectedVideo.username
        self.lblViewCount.text = self.selectedVideo.view
        //        self.lblLikeCount.text = self.selectedVideo.
        //        self.lblShareCount.text = self.selectedVideo.username
        
        self.lblLikeCount.text = self.selectedVideo.likeCount
        
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
        
        //cell.btn_like.setBackgroundImage(UIImage(named:"ic_like"), for: .normal)
         var action:String! = ""
         
         if let count = selectedVideo?.liked, (count == "0") {
         action = "1"
         self.btnLike.setBackgroundImage(UIImage(named:"ic_like_fill"), for: .normal)
         }else {
         action = "0"
         self.btnLike.setBackgroundImage(UIImage(named:"ic_like"), for: .normal)
         }
         
         
         let url : String = self.appDelegate.baseUrl!+self.appDelegate.likeDislikeVideo!
         
        let parameter :[String:Any]? = ["fb_id":UserDefaults.standard.string(forKey: "uid")!,"video_id":selectedVideo.v_id ?? "0","action":action!]
         
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
         })
    }
}
