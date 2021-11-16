//
//  LoginVC.swift
//  Reely - Create Transform & Donate
//
//  Created by Mac on 03/08/21.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import FirebaseAuth
import Alamofire
import AuthenticationServices

class LoginVC: UIViewController {
    
    var first_name:String! = ""
    var last_name:String! = ""
    var email:String! = ""
    var my_id:String! = ""
    var profile_pic:String! = ""
    var signUPType:String! = ""
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //        GIDSignIn.sharedInstance()?.presentingViewController = self
        print(UserDefaults.standard.string(forKey: "uid"))
        
        
        if UserDefaults.standard.string(forKey: "uid") == nil {
            print("String is nil or empty.")
            UserDefaults.standard.set("", forKey: "uid")
            // or break, continue, throw
        }
        
        
        if UserDefaults.standard.string(forKey: "uid") != "" {
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc: TabbarViewController = storyboard.instantiateViewController(withIdentifier: "TabbarViewController") as! TabbarViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
            
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

    

    @IBAction func loginWithFbBtnAction(_ sender: UIButton) {
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : LoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email")){
                        self.getFBUserData()
                    }
                }
            }
        }
    }
    
    
    func getFBUserData(){
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email,age_range"]).start(completion: { (connection, result, error) -> Void in
                if (error == nil){
                    let dict = result as! [String : AnyObject]
                    print(dict)
                    if let dict = result as? [String : AnyObject]{
                        if(dict["email"] as? String == nil || dict["id"] as? String == nil || dict["email"] as? String == "" || dict["id"] as? String == "" ){
                            
                          //  HomeViewController.removeSpinner(spinner: sv)
                            
                         //   self.alertModule(title:"Error", msg:"You cannot login with this facebook account because your facebook is not linked with any email")
                            
                        }else{
                           // HomeViewController.removeSpinner(spinner: sv)
                            self.email = dict["email"] as? String
                            self.first_name = dict["first_name"] as? String
                            self.last_name = dict["last_name"] as? String
                            self.my_id = dict["id"] as? String
                            let dic1 = dict["picture"] as! NSDictionary
                            let pic = dic1["data"] as! NSDictionary
                            self.profile_pic = pic["url"] as? String
                            UserDefaults.standard.set(self.profile_pic, forKey: "Profile_Pic")
                           
                            self.signUPType = "facebook"
                            
                            self.SignUpApi()
                            
                        }
                    }
                    
                }else{
                    
                  //  HomeViewController.removeSpinner(spinner: sv)
                    
                    
                }
            })
            
            
            
            
           
        }
        
    }
    
    
    @IBAction func loginWithGoogleBtnAction(_ sender: UIButton) {
        let signInConfig = GIDConfiguration.init(clientID: "866548814294-hrjk0hndqqs7tdu6u8h0ku9icugtscfc.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }

            // If sign in succeeded, display the app's main content View.
            self.GoogleApi(user: user)
          }
        
    }
    
    
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        //UIActivityIndicatorView.stopAnimating()
    }
    
    func signIn(signIn: GIDSignIn!,
                presentViewController viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func signIn(signIn: GIDSignIn!,
                dismissViewController viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if (error == nil) {
            // Perform any operations on signed in user here.
            self.GoogleApi(user: user)
            
            // ...
        } else {
            
            //            self.view.isUserInteractionEnabled = true
            //            KRProgressHUD.dismiss {
            //                print("dismiss() completion handler.")
            //
            //            }
            print("\(error.localizedDescription)")
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!){
        
        
        
    }
    
    // Gmail Login
    
    func GoogleApi(user: GIDGoogleUser!){
        

        if(user.profile?.email == nil || user.userID == nil || user.profile?.email == "" || user.userID == ""){
            
        
           // self.alertModule(title:"Error", msg:"You cannot signup with this Google account because your Google is not linked with any email.")
            
        }else{
            
            
//            HomeViewController.removeSpinner(spinner: sv)
//            //SliderViewController.removeSpinner(spinner: sv)
            self.email = user.profile?.email
            self.first_name = user.profile?.givenName
            self.last_name = user.profile?.familyName
            self.my_id = user.userID
            
            print(self.email, self.first_name, self.last_name, self.my_id)
            if ((user.profile?.hasImage) != nil)
            {
                let pic = user.profile?.imageURL(withDimension: 100)
                self.profile_pic = pic!.absoluteString
                UserDefaults.standard.set(self.profile_pic, forKey: "Profile_Pic")
            }else{
                self.profile_pic = ""
            }
            
            self.signUPType = "gmail"
            self.SignUpApi()
        }
        
        
    }
    
    @IBAction func loginWithAppleBtNACTION(_ sender: UIButton) {
        if #available(iOS 13.0, *) {
            //Show sign-in with apple button. Create button here via code if you need.
            self.setupAppleIDCredentialObserver()
            let appleSignInRequest = ASAuthorizationAppleIDProvider().createRequest()
            appleSignInRequest.requestedScopes = [.fullName, .email]
            let controller = ASAuthorizationController(authorizationRequests: [appleSignInRequest])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        } else {
            // Fallback on earlier versions
            //Hide your sign in with apple button here.
        }
    }
    
    
    private func setupAppleIDCredentialObserver() {
        if #available(iOS 13.0, *) {
            let authorizationAppleIDProvider = ASAuthorizationAppleIDProvider()
            authorizationAppleIDProvider.getCredentialState(forUserID: "currentUserIdentifier") { (credentialState: ASAuthorizationAppleIDProvider.CredentialState, error: Error?) in
                if let error = error {
                    print(error)
                    // Something went wrong check error state
                    return
                }
                switch (credentialState) {
                case .authorized:
                    //User is authorized to continue using your app
                    break
                case .revoked:
                    //User has revoked access to your app
                    break
                case .notFound:
                    //User is not found, meaning that the user never signed in through Apple ID
                    break
                default: break
                }
            }
        }else{
        }
    }
    
    @IBAction func loginWithPhnNumBtnActn(_ sender: UIButton) {
        
    }
    
    @IBAction func unwindToContainerVC(segue: UIStoryboardSegue) {
        
    }
    
    func SignUpApi(){
        
        // let  sv = HomeViewController.displaySpinner(onView: self.view)
        
        var VersionString:String! = ""
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            VersionString = version
        }
        
        let url : String = self.appDelegate.baseUrl!+self.appDelegate.signUp!
        let udid = UIDevice.current.identifierForVendor?.uuidString
        
        
        let parameter:[String:Any]?  = ["fb_id":self.my_id!,"first_name":self.first_name!,"last_name":self.last_name!,"profile_pic":self.profile_pic!,"gender":"m","signup_type":self.signUPType!,"version":VersionString!,"device":"iOS", "latitude" : UserDefaults.standard.value(forKey: "Latitude") ?? "", "longitude" : UserDefaults.standard.value(forKey: "Longitude") ?? "","device_id":udid!, "referral_fb_id": UserDefaults.standard.value(forKey: "referral_fb_id") ?? ""]
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
    
}

extension LoginVC: ASAuthorizationControllerDelegate {
    @available(iOS 12.0, *)
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        
        print("User ID: \(appleIDCredential.user)")
        self.my_id = appleIDCredential.user
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            print(appleIDCredential)
        case let passwordCredential as ASPasswordCredential:
            print(passwordCredential)
        default: break
        }
        
        if let userEmail = appleIDCredential.email {
            print("Email: \(userEmail)")
            self.email = userEmail
            self.my_id = appleIDCredential.user
        }
        
        if let userGivenName = appleIDCredential.fullName?.givenName,
            
            let userFamilyName = appleIDCredential.fullName?.familyName {
            //print("Given Name: \(userGivenName)")
            // print("Family Name: \(userFamilyName)",
            self.my_id = appleIDCredential.user
            self.first_name = userGivenName
            self.last_name = userFamilyName
            
            
        }
        
        
        
        if let authorizationCode = appleIDCredential.authorizationCode,
            let identifyToken = appleIDCredential.identityToken {
            print("Authorization Code: \(authorizationCode)")
            print("Identity Token: \(identifyToken)")
            //First time user, perform authentication with the backend
            //TODO: Submit authorization code and identity token to your backend for user validation and signIn
            //self.signUp(self)
            // if(self.email != ""){
            
            self.signUPType = "apple"
            self.profile_pic = ""
            self.SignUpApi()
            // }else{
            
            //self.alertModule(title:"Error", msg: "Please share your email.")
            // }
            return
        }
        //TODO: Perform user login given User ID
        
        
        
        
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Authorization returned an error: \(error.localizedDescription)")
    }
}
extension LoginVC: ASAuthorizationControllerPresentationContextProviding {
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

