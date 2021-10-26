//
//  OTPVC.swift
//  Reely - Create Transform & Donate
//
//  Created by Mac on 03/08/21.
//

import UIKit
import FlagPhoneNumber
import AuthenticationServices
import FirebaseAuth
import Alamofire

class OTPVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var TF1: UITextField!
    @IBOutlet weak var TF2: UITextField!
    @IBOutlet weak var TF3: UITextField!
    @IBOutlet weak var TF4: UITextField!
    @IBOutlet weak var TF5: UITextField!
    @IBOutlet weak var TF6: UITextField!
    
    var first_name:String! = ""
    var last_name:String! = ""
    var email:String! = ""
    var my_id:String! = ""
    var profile_pic:String! = ""
    var signUPType:String! = ""
    
    var mobNo : String!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var fb_Id = ""
    var maxLen:Int = 1;  // set max text count for textfeild
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        self.view.addGestureRecognizer(tap)
        
        mobNo = UserDefaults.standard.string(forKey: "MoblieNumber")
        
        TF1.delegate = self
        TF2.delegate = self
        TF3.delegate = self
        TF4.delegate = self
        TF5.delegate = self
        TF6.delegate = self
        
        
        TF1.becomeFirstResponder()
        TF1.layer.borderColor = UIColor.blue.cgColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

        @objc func keyboardWillShow(notification: NSNotification) {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }

        @objc func keyboardWillHide(notification: NSNotification) {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
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
    
    func SignUpApi(){
        
        // let  sv = HomeViewController.displaySpinner(onView: self.view)
        
        var VersionString:String! = ""
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            VersionString = version
        }
        
        let url : String = self.appDelegate.baseUrl!+self.appDelegate.signUp!
        let udid = UIDevice.current.identifierForVendor?.uuidString
        
        
        let parameter:[String:Any]?  = ["fb_id":self.fb_Id,"first_name":self.first_name!,"last_name":self.last_name!,"profile_pic":self.profile_pic!,"gender":"m","signup_type":self.signUPType!,"version":VersionString!,"device":"iOS", "latitude" : UserDefaults.standard.value(forKey: "Latitude") ?? "", "longitude" : UserDefaults.standard.value(forKey: "Longitude") ?? "","device_id":udid!, "referral_fb_id": UserDefaults.standard.value(forKey: "referral_fb_id") ?? ""]
        //        print(url)
        //        print(parameter!)
        
        let headers: HTTPHeaders = [
            "api-key": "4444-3333-2222-1111"
            
        ]
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers).validate().responseJSON(completionHandler: {
            
            respones in
            
            switch respones.result {
            
            case .success( let value):
                
                let json  = value
                //   HomeViewController.removeSpinner(spinner: sv)
                // print(json)
                
                let dic = json as! NSDictionary
                let code = dic["code"] as! NSString
                
                if(code == "200"){
                    
                    let myCountry = dic["msg"] as? NSArray
                    
                    if let data = myCountry![0] as? NSDictionary{
                        
                        print(data)
                        
                        let uid = data["fb_id"] as! String
                        UserDefaults.standard.set(uid, forKey: "uid")
                        
                       // self.navigationController?.navigationBar.isHidden = true
                        //   self.navigationItem.rightBarButtonItem?.isEnabled = true
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let yourVC: AnimationVC = storyboard.instantiateViewController(withIdentifier: "AnimationVC") as! AnimationVC
                        // self.present(yourVC, animated: true, completion: nil)
              self.navigationController?.pushViewController(yourVC, animated: true)
              
              print("Login successful")
              
          }
          
      }else{
                    
                    print(dic["msg"] as! String)
                    // self.alertModule(title:"Error", msg:dic["msg"] as! String)
                    
                }
                
                
            case .failure(let error):
                
                print(error.localizedDescription)
                
            // HomeViewController.removeSpinner(spinner: sv)
            // self.alertModule(title:"Error",msg:error.localizedDescription)
            
            
            }
        })
        
        
    }
    
    @IBAction func verifyNumBtnAction(_ sender: UIButton) {
        
        if (TF1.text == nil || TF2.text == nil || TF3.text == nil || TF4.text == nil || TF5.text == nil || TF6.text == nil){
            
            let alert = UIAlertController(title: "", message: "Please Enter Valid OTP", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }else if (TF1.text == "" || TF2.text == "" || TF3.text == "" || TF4.text == "" || TF5.text == "" || TF6.text == ""){
            
            let alert = UIAlertController(title: "", message: "Please Enter Valid OTP", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else{
        
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
            let verificationCode1 = TF1.text! + TF2.text! + TF3.text!
        let code2 =  TF4.text! + TF5.text! + TF6.text!
            //TF1.text + TF2.text + TF3.text + TF4.text + TF5.text + Tf6.text
        let code = verificationCode1 + code2
         print(code2)
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID!,
            verificationCode: code)
        
        Auth.auth().signIn(with: credential) { (user, error) in
//            self.loader.isHidden = false
//            self.loader.isLoadable = true
            //print(user?.user)
            //print(error)
            
            if let error = error {
//                self.loader.isHidden = true
//                self.loader.isLoadable = false
                print(error.localizedDescription)
                return
                
            }else if error == nil{
//                self.loader.isHidden = true
//                self.loader.isLoadable = false
                if let id = user?.user.uid{
                self.fb_Id = id
            }
                self.SignUpApi()
            }
          }
        }
    }
    
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        TF6.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        TF6.resignFirstResponder()
    }
    
    //MARK: Text Feild Delegates Method
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if((textField.text?.count)! < 1) && (string.count > 0) {
            
            if textField == TF1 {
                TF2.becomeFirstResponder()
                TF1.layer.borderColor = UIColor.white.cgColor
                TF3.layer.borderColor = UIColor.white.cgColor
                TF4.layer.borderColor = UIColor.white.cgColor
                TF5.layer.borderColor = UIColor.white.cgColor
                TF6.layer.borderColor = UIColor.white.cgColor
                
                TF2.layer.borderColor = UIColor.blue.cgColor
            }
            
            if textField == TF2 {
                TF3.becomeFirstResponder()
                TF2.layer.borderColor = UIColor.white.cgColor
                TF1.layer.borderColor = UIColor.white.cgColor
                TF4.layer.borderColor = UIColor.white.cgColor
                TF5.layer.borderColor = UIColor.white.cgColor
                TF6.layer.borderColor = UIColor.white.cgColor
                
                TF3.layer.borderColor = UIColor.blue.cgColor
            }
            
            if textField == TF3 {
                TF4.becomeFirstResponder()
                TF3.layer.borderColor = UIColor.white.cgColor
                TF1.layer.borderColor = UIColor.white.cgColor
                TF2.layer.borderColor = UIColor.white.cgColor
                TF5.layer.borderColor = UIColor.white.cgColor
                TF6.layer.borderColor = UIColor.white.cgColor
                
                TF4.layer.borderColor = UIColor.blue.cgColor
            }
            
            if textField == TF4 {
                TF5.becomeFirstResponder()
                TF4.layer.borderColor = UIColor.white.cgColor
                TF3.layer.borderColor = UIColor.white.cgColor
                TF1.layer.borderColor = UIColor.white.cgColor
                TF2.layer.borderColor = UIColor.white.cgColor
                TF6.layer.borderColor = UIColor.white.cgColor
                
                TF5.layer.borderColor = UIColor.blue.cgColor
            }
            
            if textField == TF5 {
                TF6.becomeFirstResponder()
                TF5.layer.borderColor = UIColor.white.cgColor
                TF4.layer.borderColor = UIColor.white.cgColor
                TF3.layer.borderColor = UIColor.white.cgColor
                TF1.layer.borderColor = UIColor.white.cgColor
                TF2.layer.borderColor = UIColor.white.cgColor
                
                TF6.layer.borderColor = UIColor.blue.cgColor
            }
            
            textField.text = string
            return false
        }
            
        else if ((textField.text?.count)! >= 1) && (string.count == 0) {
            
            if textField == TF1 {
                TF1.becomeFirstResponder()
                TF6.layer.borderColor = UIColor.white.cgColor
                TF5.layer.borderColor = UIColor.white.cgColor
                TF4.layer.borderColor = UIColor.white.cgColor
                TF3.layer.borderColor = UIColor.white.cgColor
                TF2.layer.borderColor = UIColor.white.cgColor
                
                TF1.layer.borderColor = UIColor.blue.cgColor
            }
            
            if textField == TF2 {
                TF1.becomeFirstResponder()
                TF6.layer.borderColor = UIColor.white.cgColor
                TF5.layer.borderColor = UIColor.white.cgColor
                TF4.layer.borderColor = UIColor.white.cgColor
                TF3.layer.borderColor = UIColor.white.cgColor
                TF2.layer.borderColor = UIColor.white.cgColor
                
                TF1.layer.borderColor = UIColor.blue.cgColor
            }
            
            if textField == TF3 {
                TF2.becomeFirstResponder()
                TF6.layer.borderColor = UIColor.white.cgColor
                TF5.layer.borderColor = UIColor.white.cgColor
                TF4.layer.borderColor = UIColor.white.cgColor
                TF3.layer.borderColor = UIColor.white.cgColor
                TF1.layer.borderColor = UIColor.white.cgColor
                
                TF2.layer.borderColor = UIColor.blue.cgColor
            }
            
            if textField == TF4 {
                TF3.becomeFirstResponder()
                TF6.layer.borderColor = UIColor.white.cgColor
                TF5.layer.borderColor = UIColor.white.cgColor
                TF4.layer.borderColor = UIColor.white.cgColor
                TF1.layer.borderColor = UIColor.white.cgColor
                TF2.layer.borderColor = UIColor.white.cgColor
                
                TF3.layer.borderColor = UIColor.blue.cgColor
            }
            
            if textField == TF5 {
                TF4.becomeFirstResponder()
                TF6.layer.borderColor = UIColor.white.cgColor
                TF5.layer.borderColor = UIColor.white.cgColor
                TF1.layer.borderColor = UIColor.white.cgColor
                TF3.layer.borderColor = UIColor.white.cgColor
                TF2.layer.borderColor = UIColor.white.cgColor
                
                TF4.layer.borderColor = UIColor.blue.cgColor
            }
            
            if textField == TF6 {
                TF5.becomeFirstResponder()
                TF1.layer.borderColor = UIColor.white.cgColor
                TF6.layer.borderColor = UIColor.white.cgColor
                TF4.layer.borderColor = UIColor.white.cgColor
                TF3.layer.borderColor = UIColor.white.cgColor
                TF2.layer.borderColor = UIColor.white.cgColor
                
                TF5.layer.borderColor = UIColor.blue.cgColor
            }
            
            textField.text = ""
            return false
        }
            
            
        else if ((textField.text?.count)! >= 1) {
            
            textField.text = string
            return false
        }
        return true
    }


}
