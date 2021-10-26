//
//  HomeVideoCollectionViewCell.swift
//  Reely - Create Transform & Donate
//
//  Created by Rahul on 30/08/21.
//

import UIKit
import AVKit
import  SDWebImage
import Alamofire

class HomeVideoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var btnFollow: UIButton!
    @IBOutlet weak var viewFollow: UIView!
    @IBOutlet weak var btnRequestVerification: UIButton!
    @IBOutlet weak var viewUserDetail: UIView!
    @IBOutlet weak var viewSocialMedia: UIStackView!
    @IBOutlet weak var lblVideoDescription: UILabel!
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var lblViewCount: UILabel!
    @IBOutlet weak var lblCommentCount: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
       
    @IBOutlet weak var btnUserName: UIButton!
    @IBOutlet weak var btnPayView: UIButton!
    @IBOutlet weak var btnUserProfilePic: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnVerification: UIButton!
    @IBOutlet weak var btnEyeView: UIButton!
    @IBOutlet weak var btnComments: UIButton!
    
    @IBOutlet weak var viewVideoPlayer: UIView!
    @IBOutlet weak var viewDescAnimation: UIView!
    @IBOutlet weak var viewComments: UIView!
    @IBOutlet weak var viewInnerView: UIView!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var viewGradient: UIView!
    @IBOutlet weak var progessBar: UIProgressView!
    
    
    var player:AVPlayer? = nil
    var playerItem:AVPlayerItem? = nil
    var playerLayer:AVPlayerLayer? = nil
    var isLiked: Bool = false
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    public typealias HTTPHeaders = [String: String]
    var socialMediaModel: SocialMediaModel?
    
    var callBack: ((Bool)->())?
    var strCallBack:((Any?)->())?
    
    var homeMsg: HomeMsg? {
        didSet {
            let url = URL(string: self.homeMsg?.video ?? "")
            
            let screenSize: CGRect = UIScreen.main.bounds
            self.player = AVPlayer(url: url!)
            self.player?.automaticallyWaitsToMinimizeStalling = false
            self.playerLayer = AVPlayerLayer(player: self.player)
            self.playerLayer?.frame = CGRect(x:0,y:0,width:screenSize.width,height: 400)
            self.playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
            self.viewVideoPlayer?.layer.addSublayer(self.playerLayer ?? AVPlayerLayer())
            
            //            _ = self.player?.addProgressObserver(action: { (time) in
            //                self.progessBar.progress = Float(time)
            //            })
            
            self.player?.addPeriodicTimeObserver(forInterval: CMTime.init(value: 1, timescale: 1), queue: .main, using: { [weak self] time in
                if let duration = self?.player?.currentItem?.duration {
                    let duration = CMTimeGetSeconds(duration), time = CMTimeGetSeconds(time)
                    let progress = (time/duration)
                    //self?.progessBar.setProgress(Float(progress), animated: true)
                }
            })
            
            self.viewVideoPlayer.layer.backgroundColor = UIColor.black.cgColor
            
            if let f_name = self.homeMsg?.user_info?.first_name, let l_name = self.homeMsg?.user_info?.last_name {
                lblUserName.text = f_name + l_name
            }
            
            if let str = self.homeMsg?.user_info?.profile_pic {
                self.imgProfile.sd_setImage(with: URL(string: str), placeholderImage: UIImage(), options: SDWebImageOptions.continueInBackground, completed: nil)
            }
            
            self.lblLikeCount.text = self.homeMsg?.count?.like_count ?? "0"
            self.lblCommentCount.text = self.homeMsg?.count?.share ?? "0"
            self.lblViewCount.text = self.homeMsg?.count?.view ?? "0"
            
            if let count = self.homeMsg?.liked, count == "0" {
                self.btnLike.setBackgroundImage(UIImage(named:"ic_like"), for: .normal)
            }else if let count = self.homeMsg?.liked, count == "1" {
                self.btnLike.setBackgroundImage(UIImage(named:"ic_like_fill"), for: .normal)
            }
            
            self.lblVideoDescription.text = self.homeMsg?.description ?? ""
            //self.player?.play()
            
        }
    }
    
    @IBAction func btnLikedToggleClick(_ sender: Any) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.likedToggle(action: self?.isLiked ?? false ? "0": "1")
        }
    }
    
    @IBAction func btnFollowTapped(_ sender: Any) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.onTapfollow(action: "follow")
        }
    }
    
    @IBAction func btnCommentClick(_ sender: Any) {
        self.strCallBack?("share")
    }
    
    private func likedToggle(action: String){
        print("action \(action)")
        // let  sv = HomeViewController.displaySpinner(onView: self.view)
        
        let url : String = self.appDelegate.baseUrl!+self.appDelegate.likeDislikeVideo!
        
      //  let udid = UIDevice.current.identifierForVendor?.uuidString
        let parameter:[String:Any]?  = ["fb_id":UserDefaults.standard.string(forKey: "uid")!,
                                        "video_id":homeMsg?.id,
                                         "action": action,
                                         "middle_name":"osd191k3hEZm5PzMfoboJy5l466w7szI"]
            
        
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
                                let count = (Int(self?.homeMsg?.count?.like_count ?? "0") ?? 0) + 1
                                self?.homeMsg?.count?.like_count = "\(count)"
                                self?.lblLikeCount.text = "\(count)"
                                self?.btnLike.setBackgroundImage(UIImage(named:"ic_like_fill"), for: .normal)
                                self?.callBack?(true)
                            }else{
                                let count = (Int(self?.homeMsg?.count?.like_count ?? "0") ?? 0) - 1
                                self?.homeMsg?.count?.like_count = "\(count)"
                                self?.lblLikeCount.text = "\(count)"
                                self?.btnLike.setBackgroundImage(UIImage(named:"ic_like"), for: .normal)
                                self?.callBack?(false)
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
    }
    
    
    private func onTapfollow(action: String){
        print("action \(action)")
        // let  sv = HomeViewController.displaySpinner(onView: self.view)
        
        let url : String = self.appDelegate.baseUrl!+self.appDelegate.follow_users!
        
      //  let udid = UIDevice.current.identifierForVendor?.uuidString
        let parameter:[String:Any]?  = ["fb_id":UserDefaults.standard.string(forKey: "uid")!,
                                        "followed_fb_id": homeMsg?.fb_id,
                                        "status":"1",
                                        "middle_name":"osd191k3hEZm5PzMfoboJy5l466w7szI"]
        
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
                        self?.btnVerification.isHidden = false
                        self?.viewFollow.isHidden = true
                        self?.btnFollow.isHidden = true
                           
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
    }
 }
