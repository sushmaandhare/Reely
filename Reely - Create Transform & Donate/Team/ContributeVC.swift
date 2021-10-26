//
//  ContributeVC.swift
//  Reely - Create Transform & Donate
//
//  Created by MacBook Air on 15/07/1943 Saka.
//

import UIKit
import Alamofire

class ContributeVC: UIViewController {

    var activityId : String! = ""
    var totalPoints = "0"
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblPoints: UILabel!
    
    @IBOutlet weak var txtPoints: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblPoints.text = self.totalPoints
    }
    
    @IBAction func onTapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTapDonate(_ sender: UIButton) {
        
        guard txtPoints.text != "" else {
            return
        }
        let url : String = self.appDelegate.baseUrl!+self.appDelegate.donateFundPoints!
        
        let parameter:[String:Any]?  = ["fb_id":UserDefaults.standard.string(forKey: "uid")!, "activity_id":self.activityId, "points": txtPoints.text]
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
                    
                    if let myCountry = dic["msg"] as? [String:Any]{
                        
                        self.Alert(title: "Thank you!!", msg: "Contribution successful")
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let yourVC: ThankYouVC = storyboard.instantiateViewController(withIdentifier: "ThankYouVC") as! ThankYouVC
                        self.navigationController?.pushViewController(yourVC, animated: true)
                           
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
        self.dismiss(animated: true, completion: nil)
    })
    alertController.addAction(okalertAction)
    present(alertController, animated: true, completion: nil)
    }
    

}
