//
//  CreateTeamVC.swift
//  Reely - Create Transform & Donate
//
//  Created by MacBook Air on 13/07/1943 Saka.
//

import UIKit
import  Alamofire
import SDWebImage
import CoreServices
import AVKit
import AVFoundation
import CameraManager

protocol CreateTeamVCDelegate : AnyObject {
    func successfullTeamCreate()
}

class CreateTeamVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, DatePickerVCDelegate, UITextFieldDelegate {
    
    weak var delegate : CreateTeamVCDelegate?
    func DismissVC(date: Date?) {
        self.selectedDate = date
    }
    

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
   
    @IBOutlet weak var txtFunds: UITextField!
    @IBOutlet weak var txtAbout: UITextField!
    @IBOutlet weak var txtTeamName: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    var datePicker = UIDatePicker()

    var videoAndImageReview = UIImagePickerController()
    var selectedImg : UIImage?
    var selectedDate : Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // self.tabBarController?.tabBar.isHidden = true
        addDoneButtonOnKeyboard()
        self.txtDate.delegate = self
        // Do any additional setup after loading the view.
      
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        let dateStr = dateFormatter.string(from: date)
        
        txtDate.text = dateStr
        showDatePicker()
       
    }
    
    func showDatePicker(){
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        txtDate.inputAccessoryView = toolbar
        txtDate.inputView = datePicker
    }
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        txtDate.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
 
    @IBAction func onTapCreate(_ sender: UIButton) {
        print(self.selectedImg)
        guard txtAbout.text != "" && txtFunds.text != "" && txtTeamName.text != "" && txtDate.text != "" else{
            Alert(title: "Alert", msg: "All fields are mandatory")
           return
        }
        
//        guard selectedImg != nil else{
//            Alert(title: "Alert", msg: "Please upload profile Image")
//           return
//        }
        
        createTeamApiCall()
    }
    
    func Alert(title: String, msg: String){
    let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
    let okalertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: {(alert : UIAlertAction!) in
        self.dismiss(animated: true, completion: nil)
    })
    alertController.addAction(okalertAction)
    present(alertController, animated: true, completion: nil)
    }
    
    func createTeamApiCall(){
        
        let Imagedata = selectedImg?.jpegData(compressionQuality: 1.0)
        let strBase64Image = Imagedata?.base64EncodedString()
            
            let url : String = self.appDelegate.baseUrl!+self.appDelegate.createTeam!
            
        let parameter:[String:Any]?  = ["fb_id": UserDefaults.standard.string(forKey: "uid")!,"team_name":txtTeamName.text,"about": txtAbout.text, "funds_to_raise": txtFunds.text, "last_date": txtDate.text, "image":strBase64Image]
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
                        self.dismiss(animated: true, completion: { [weak self] in
                            self?.delegate?.successfullTeamCreate()
                        })
                    
                }else{
                    
                    print(dic["msg"] as! String)
            
                    }
                    
                case .failure(let error):
                    
                    print(error.localizedDescription)
                    
               
                
                }
            })
            
            
            
        }
    
    @IBAction func onTapCamera(_ sender: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            videoAndImageReview.delegate = self
            videoAndImageReview.sourceType = .camera;
            videoAndImageReview.allowsEditing = false
            self.present(videoAndImageReview, animated: true, completion: nil)
        }
    }
    
    @IBAction func onTapGallary(_ sender: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            videoAndImageReview.delegate = self
            videoAndImageReview.sourceType = .photoLibrary;
            videoAndImageReview.allowsEditing = true
            self.present(videoAndImageReview, animated: true, completion: nil)
        }
    }
    
    //MARK: PICKER DELEGATE METHOD
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        videoAndImageReview.dismiss(animated: true, completion: nil)
        selectedImg = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
    
        //selectedImg = image
        
    }

    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        txtTeamName.inputAccessoryView = doneToolbar
        txtAbout.inputAccessoryView = doneToolbar
        txtFunds.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        txtTeamName.resignFirstResponder()
        txtAbout.resignFirstResponder()
        txtFunds.resignFirstResponder()
    }
    
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        if textField == txtDate{
//            return true
//        }
//        return true
//    }
//
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField == txtDate{
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let yourVC: DatePickerVC = storyboard.instantiateViewController(withIdentifier: "DatePickerVC") as! DatePickerVC
//            yourVC.delegate = self
//            self.present(yourVC, animated: true, completion: nil)
//        }
//    }
}
