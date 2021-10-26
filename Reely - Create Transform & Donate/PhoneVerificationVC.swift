//
//  PhoneVerificationVC.swift
//  Reely - Create Transform & Donate
//
//  Created by Mac on 03/08/21.
//

import UIKit
import FlagPhoneNumber
import AuthenticationServices
import FirebaseAuth

class PhoneVerificationVC: UIViewController, UITextFieldDelegate {
    
  
    @IBOutlet weak var countryDigTF: FPNTextField!
    @IBOutlet weak var mobileNoTF: UITextField!
    @IBOutlet weak var btnVerify: UIButton!
    
    var listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)
    var countryCode : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        self.view.addGestureRecognizer(tap)
        countryDigTF.borderStyle = .roundedRect
        //        countryTF.pickerView.showPhoneNumbers = false
        countryDigTF.text = countryCode
        countryDigTF.displayMode = .picker // .picker by default
        
        listController.setup(repository: countryDigTF.countryRepository)
        
        listController.didSelect = { [weak self] country in
            self?.countryDigTF.setFlag(countryCode: country.code)
        }
        
        countryDigTF.delegate = self
        countryDigTF.font = UIFont.systemFont(ofSize: 14)
        
        // The placeholder is an example phone number of the selected country by default. You can add your own placeholder :
        countryDigTF.hasPhoneNumberExample = false
        countryDigTF.placeholder = ""
        
        // Custom the size/edgeInsets of the flag button
        countryDigTF.flagButtonSize = CGSize(width: 35, height: 35)
        countryDigTF.flagButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        // Set the flag image with a region code
        countryDigTF.setFlag(countryCode: .IN)
        
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
    
    @IBAction func verifyNumBtnAction(_ sender: UIButton) {
//        loader.isHidden = false
//        loader.isLoadable = true
        btnVerify.isEnabled = false
        
        guard let mobile = mobileNoTF.text else {
            
            return //alertModule(title: "Error", msg: "Mobile number is incorrect")
        }
        
        let mobNo = countryCode + " " + mobile
        print(mobNo)
        
        UserDefaults.standard.set(mobNo, forKey: "MoblieNumber")
        
        Auth.auth().settings?.isAppVerificationDisabledForTesting = false
        
        PhoneAuthProvider.provider().verifyPhoneNumber(mobNo, uiDelegate: nil) { (verificationId, error) in
         
            if error == nil{
//                self.loader.isHidden = true
//                self.loader.isLoadable = false
               // print("verificationId",verificationId)
                UserDefaults.standard.set(verificationId, forKey: "authVerificationID")
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc: OTPVC = storyboard.instantiateViewController(withIdentifier: "OTPVC") as! OTPVC
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else{
//                self.loader.isHidden = true
//                self.loader.isLoadable = false
                self.btnVerify.isEnabled = true
                let alert = UIAlertController(title: "", message: "\(error!.localizedDescription)", preferredStyle: .alert)
                      alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                      self.present(alert, animated: true, completion: nil)
                print("Unable to get secret verification code", error?.localizedDescription)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "OTPVC" {
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc: OTPVC = storyboard.instantiateViewController(withIdentifier: "OTPVC") as! OTPVC
            vc.mobNo = countryCode + " " + mobileNoTF.text!
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
        
        mobileNoTF.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        mobileNoTF.resignFirstResponder()
    }
}


extension PhoneVerificationVC: FPNTextFieldDelegate {

    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        textField.rightViewMode = .always
       // textField.rightView = UIImageView(image: isValid ? #imageLiteral(resourceName: "success") : #imageLiteral(resourceName: "error"))

        print(
            isValid,
            textField.getFormattedPhoneNumber(format: .E164) ?? "E164: nil",
            textField.getFormattedPhoneNumber(format: .International) ?? "International: nil",
            textField.getFormattedPhoneNumber(format: .National) ?? "National: nil",
            textField.getFormattedPhoneNumber(format: .RFC3966) ?? "RFC3966: nil",
            textField.getRawPhoneNumber() ?? "Raw: nil"
        )
    }

    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
      //  print(name, dialCode, code)
        countryCode = dialCode
    }

    func fpnDisplayCountryList() {
      //  let navigationViewController = UINavigationController(rootViewController: listController)

//        listController.title = "Countries"
//        listController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissCountries))

     //   self.present(navigationViewController, animated: true, completion: nil)
    }
}
