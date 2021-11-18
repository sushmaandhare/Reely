//
//  DonateDetailViewController.swift
//  Reely - Create Transform & Donate
//
//  Created by MacBook Air on 27/07/1943 Saka.
//

import UIKit
import Alamofire

class DonateDetailViewController: UIViewController, ProfileViewControllerDelegate {

    @IBOutlet weak var teamImg: UIImageView!
    @IBOutlet weak var lblTeamName: UILabel!
    @IBOutlet weak var lblTeamDesc: UITextView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var lblProgress: UILabel!
    @IBOutlet weak var lblSubscriber: UILabel!
    @IBOutlet weak var lblCreatedBy: UILabel!
    @IBOutlet weak var lblDaysLeft: UILabel!
    @IBOutlet weak var creatorPic: UIImageView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var donateDetail : DonateList!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.lblTeamName.text = self.donateDetail.activity_name
        self.lblTeamDesc.text = self.donateDetail.desc
        self.lblCreatedBy.text = self.donateDetail.created_by
        self.lblDaysLeft.text = self.donateDetail.days_left
        self.teamImg.sd_setImage(with: URL(string:self.donateDetail.activity_image), placeholderImage: UIImage(named:"create-1"))
        self.creatorPic.sd_setImage(with: URL(string:self.donateDetail.creator_pic), placeholderImage: UIImage(named:"create-1"))
        if let fundDonate = self.donateDetail.fund_donate , let fundRaised = self.donateDetail.fundRaise{
            self.lblProgress.text = "\(fundDonate) raised out of \(fundRaised)"
        }
        
        self.creatorPic.layer.cornerRadius = self.creatorPic.frame.height/2
        self.creatorPic.clipsToBounds = true
        self.creatorPic.layer.borderColor = UIColor.white.cgColor
        self.creatorPic.layer.borderWidth = 1.0
      
    }
    
    
    @IBAction func cartBtnAction(_ sender: UIButton) {
    }
    
    @IBAction func NotificationBtnAction(_ sender: UIButton) {
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
    
    
    @IBAction func ContributeBtnAction(_ sender: UIButton) {
    }
    
    @IBAction func ShareFunderBtnAction(_ sender: UIButton) {
    }
    
    @IBAction func onTapJoin(_ sender: UIButton) {
        let url : String = self.appDelegate.baseUrl!+self.appDelegate.joinActivity!
        
        let parameter:[String:Any]?  = ["fb_id": UserDefaults.standard.string(forKey: "uid")!,"activity_id": donateDetail.activity_id]
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
                            let resp = Dict["response"] as? String
                            self.Alert(title: "", msg: resp!)
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                        
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
    
    func Alert(title: String, msg: String){
    let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
    let okalertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: {(alert : UIAlertAction!) in
        self.dismiss(animated: true, completion: {
            self.navigationController?.popViewController(animated: true)
        })
    })
    alertController.addAction(okalertAction)
    present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func onTapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
