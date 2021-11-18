//
//  TeamDetailsVC.swift
//  Reely - Create Transform & Donate
//
//  Created by MacBook Air on 13/07/1943 Saka.
//

import UIKit
import  Alamofire

class TeamDetailsVC: UIViewController {

    var teamDetail : TeamList!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.teamImg.sd_setImage(with: URL(string:teamDetail.activity_image), placeholderImage: UIImage(named:"create-1"))
        self.lblTeamName.text = teamDetail.activity_name
        self.lblTeamDesc.text = teamDetail.desc
        self.progressBar.setProgress(0, animated: true)
        let donate = String(teamDetail.fund_donate ?? 0)
        self.lblProgress.text = donate + " Raised out of " + (teamDetail.fundRaise!)
        self.creatorPic.layer.cornerRadius = self.creatorPic.frame.height/2
        self.creatorPic.clipsToBounds = true
        self.creatorPic.layer.borderColor = UIColor.white.cgColor
        self.creatorPic.layer.borderWidth = 1.0
//        self.creatorPic.sd_setImage(with: URL(string:teamDetail.createdPic ?? "create"))
        self.creatorPic.image = UIImage(named: "ic_person")
        
        self.lblCreatedBy.text = teamDetail.createdBy
        self.lblDaysLeft.text = teamDetail.daysLeft
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onTapJoin(_ sender: UIButton) {
        let url : String = self.appDelegate.baseUrl!+self.appDelegate.joinActivity!
        
        let parameter:[String:Any]?  = ["fb_id": UserDefaults.standard.string(forKey: "uid")!,"activity_id": teamDetail.activity_id]
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
}
