//
//  videoUploadViewController.swift
//  Reely - Create Transform & Donate
//
//  Created by Mac on 13/08/21.
//

import UIKit
import AVFoundation
import Photos
import AVKit
import Alamofire
import MobileCoreServices

class videoUploadViewController: UIViewController, HashTagListVCDelegate, PrivacyVCDelegate {
    
    func sendList(val: String) {
        print(val)
        self.discTextField.textColor = .white
        if discTextField.text == "  Add Description"{
            self.discTextField.text = ""
            self.discTextField.text =  val
        }else{
            self.discTextField.text = self.discTextField.text + val
        }
    }
    
    func sendString(val: String) {
        lblPrivacy.text = val
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var allowComment = true
    var allowDuet = "1"
    var descText :String = ""
    var videoUrl:URL?
    var base64videoUrl:String!
    var mediaType = ""
    var videoId : String? = ""
    
    @IBOutlet weak var bgView: UIView!
    // @IBOutlet weak var discTextField: UITextField!
    @IBOutlet weak var discTextField: UITextView!
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var saveVideoBtn: UIButton!
    @IBOutlet weak var videoPostBtn: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    @IBOutlet weak var commentSwitch: UISwitch!
    @IBOutlet weak var duetSwitch: UISwitch!
    @IBOutlet weak var lblPrivacy: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        self.view.addGestureRecognizer(tap)
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        discTextField.text = "  Add Description"
        discTextField.textColor = UIColor.gray
        discTextField.delegate = self
//        let placesData = UserDefaults.standard.object(forKey: "Draft") as? NSData
//
//        if let placesData = placesData {
//            draftArr = NSKeyedUnarchiver.unarchiveObject(with: placesData as Data) as! [URL]
//            print(draftArr)
//        }
//        let colors = [UIColor(red: 255/255, green: 81/255, blue: 47/255, alpha: 1.0), UIColor(red: 221/255, green: 36/255, blue: 181/255, alpha: 1.0)]
//        self.videoPostBtn.setGradientBackgroundColors(colors, direction: .toBottom, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        print("VideoUrl ----\(videoUrl)")
        print("mediaType ----\(mediaType)")
        
//        if fromDraftVC == true{
//
//            saveVideoBtn.isHidden = true
//        }
        
        if let urldata = videoUrl
        {
            if let thumbnailImage = getThumbnailImage(forUrl: urldata) {
                videoImageView.image = thumbnailImage
            }
            
        }
    }
    
    func json(from object:Any) -> String {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return ""
        }
        return String(data: data, encoding: String.Encoding.utf8)!
    }
    
    @IBAction func VideoPostBtn(_ sender: Any) {
//        if draftArr.isEmpty == false{
//        if let index = draftArr.firstIndex(of: videoUrl!) {
//            draftArr.remove(at: index)
//        }
//            let draftData = NSKeyedArchiver.archivedData(withRootObject: draftArr)
//            UserDefaults.standard.set(draftData, forKey: "Draft")
//        }
        self.loader.isHidden = false
        self.loader.startAnimating()
        videoPostBtn.isEnabled = false
        print("videoUrl",videoUrl!)
        
        self.sendDataToServer()
        
    }
    
    
    @IBAction func VideoCancelBtn(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTapHashtag(_ sender: UIButton) {
        
        discTextField.resignFirstResponder()
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: HashtagListVC = storyboard.instantiateViewController(withIdentifier: "HashtagListVC") as! HashtagListVC
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    
}
    
    func sendDataToServer()
    {
        // let sv = HomeViewController.displaySpinner(onView: self.view)
        let url : String = self.appDelegate.baseUrl!+self.appDelegate.uploadVideo!
        var parameter :[String:Any] = [:]
        
        var hashArr : [String] = discTextField.text.findMentionText()
        //  print(discTextField.text.findMentionText())
        var strArr : [String] = []
        for str in hashArr{
            strArr.append(str)
        }
        
        // print(strArr)
        
        var hashtags_json : [[String:String]] = []
        for a in strArr{
            var vc = a.replacingOccurrences(of: "#", with: "")
            // print(vc)
            hashtags_json.append(["name": vc])
        }
        
        //    print(hashtags_json)
        
        var json_Arra = self.json(from: hashtags_json)
        //  print(json_Arra)
        
        
        if discTextField.text == "  Add Description"{
            discTextField.text = ""
        }else{
            //            let string = discTextField.text!
            //            discTextField.text = string.replacingOccurrences(of: "#(?:\\S+)\\s?", with: " ", options: .regularExpression, range: nil)
        }
        
        
        if UserDefaults.standard.string(forKey: "audioUrl") == ""{
            parameter = ["fb_id":UserDefaults.standard.string(forKey: "uid")!,"sound_id":"null","description":discTextField.text ?? "" , "privacy_type" : lblPrivacy.text ?? "Public", "allow_comments" : allowComment, "allow_duet" : allowDuet, "hashtags_json" : json_Arra, "duet": "0", "video_id": ""]
        }else{
            parameter = ["fb_id":UserDefaults.standard.string(forKey: "uid")!,"sound_id":UserDefaults.standard.string(forKey: "sid")!,"description":discTextField.text ?? "", "privacy_type" : lblPrivacy.text ?? "Public", "allow_comments" : allowComment, "allow_duet" : allowDuet, "hashtags_json" : json_Arra, "duet": "0", "video_id": ""]
        }
        print(url)
        print(parameter)
        let headers: HTTPHeaders = [
            "api-key": "4444-3333-2222-1111",
            "Content-type": "multipart/form-data"
        ]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(try! Data(contentsOf: self.videoUrl!), withName: "uploaded_file" , fileName: "uploaded_file", mimeType: "video/mp4")
            
            for (key, value) in parameter{
                
                multipartFormData.append((value as? String ?? "").data(using: .utf8 )!  , withName: key)
            }
            
        }, to: url, method: .post, headers: headers,
                encodingCompletion: { encodingResult in
                  switch encodingResult {
                  case .success(let upload, _, _):
                    upload.response { [weak self] response in
                      guard let strongSelf = self else {
                        return
                      }
                        print(String.init(data: response.data!, encoding: .utf8))
                        strongSelf.loader.stopAnimating()
                        strongSelf.convertdataintojson(data: response.data!)
                    }
                  case .failure(let encodingError):
                    print("error:\(encodingError)")
                    self.loader.stopAnimating()
                    self.showAlertMethod(title: "Error", message: "Please wait or try again later!", response: "Not")
                  }
          })
        
    }

    func convertdataintojson(data:Data){
        
        let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
       // print("json",json)
        let dic = json as! NSDictionary
        let code = dic["code"] as! NSString
        if(code == "200"){
            if let myCountry = dic["msg"] as? NSArray{
                
                
                if  let sectionData = myCountry[0] as? NSDictionary{
                    
                    let success = sectionData["response"] as? String ?? ""
                    self.showAlertMethod(title: "", message: success, response: "upload")
                }
            }
        }
        
    }
    
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        imageGenerator.appliesPreferredTrackTransform = true
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        
        return nil
    }
    
    func showAlertMethod(title:String,message:String, response:String)
    {
        
        // Create the alert controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            if response == "Not"
            {
                
            }else if response == "upload"{
                UserDefaults.standard.set(true, forKey: "Upload")
                self.navigationController?.popToRootViewController(animated: true)
                NotificationCenter.default.post(name: Notification.Name("uploadvideo"), object: nil)

                //            self.dismiss(animated: true, completion: {
                //            self.delegate?.DismissVC()
                //         })
            }else{
                self.navigationController?.popViewController(animated: true)
                
            }
        }
        //        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
        //            UIAlertAction in
        //            NSLog("Cancel Pressed")
        //        }
        
        // Add the actions
        alertController.addAction(okAction)
        //alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func onTapPrivacyBtn(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: PrivacyVC = storyboard.instantiateViewController(withIdentifier: "PrivacyVC") as! PrivacyVC
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
}

extension videoUploadViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == "  Add Description"{
            textView.text = ""
        }
        textView.textColor = .white
        return true
    }
}

extension String {
    func findMentionText() -> [String] {
        var arr_hasStrings:[String] = []
        let regex = try? NSRegularExpression(pattern: "(#[a-zA-Z0-9_\\p{Arabic}\\p{N}]*)", options: [])
        if let matches = regex?.matches(in: self, options:[], range:NSMakeRange(0, self.count)) {
            for match in matches {
                arr_hasStrings.append(NSString(string: self).substring(with: NSRange(location:match.range.location, length: match.range.length )))
            }
        }
        return arr_hasStrings
    }
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
}
