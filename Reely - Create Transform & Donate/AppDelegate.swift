//
//  AppDelegate.swift
//  Reely - Create Transform & Donate
//
//  Created by Mac on 30/07/21.
//

import UIKit
import FBSDKCoreKit
import AuthenticationServices
import Alamofire
import IQKeyboardManagerSwift
import GoogleSignIn
import AuthenticationServices
import FirebaseAuth
import Firebase
import FBSDKLoginKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var baseUrl:String? = "https://realtynextt.com/API/index.php?p=" // test url
    var signUp:String? = "signup"
    var uploadVideo:String? = "uploadVideoDuet"
    var showMyAllVideos:String? = "showMyAllVideos"
    var likeDislikeVideo:String? = "likeDislikeVideo"
    var get_hashtag:String? = "get_hashtag"
    var showAllVideos:String? = "showAllVideosNew"
    var discover:String? = "discover_new"
    var myTeamListing:String? = "MyTeamListing"
    var joinTeam:String? = "MyTeamListing"
    var createTeam:String? = "CreateTeam"
    var allTeamListing:String? = "allTeamListing"
    var activityTeamMember:String? = "activityTeamMember"
    var joinActivity:String? = "joinActivity"
    var selfTeamDetails:String? = "selfTeamDetails"
    var fundDonateMember:String? = "fundDonateMember"
    var donateFundPoints:String? = "donateFundPoints"
    var get_userPoints:String? = "get_userPoints"
    var discover_details: String? = "discover_details"
    var follow_users: String? = "follow_users"
    var donateTeamList:String? = "donatePageListing"
    var getNotifications:String? = "getNotifications"
    var DailyAppVisit: String? = "DailyAppVisit"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
//        let signInConfig = GIDConfiguration.init(clientID: "866548814294-hrjk0hndqqs7tdu6u8h0ku9icugtscfc.apps.googleusercontent.com")
//        UserDefaults.standard.set(signInConfig, forKey: "ClientId")
    
        IQKeyboardManager.shared.enable = true

        ApplicationDelegate.shared.application(
                application,
                didFinishLaunchingWithOptions: launchOptions
            )

//        if UserDefaults.standard.string(forKey: "uid") == ""{
//            self.showLoginScreen()
//        }else{
//            self.showHomeScreen()
//        }

        return true
    }


    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        GIDSignIn.sharedInstance.handle(url)
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension UIView {

    @IBInspectable var cornerRadius: CGFloat {
    get {
    return layer.cornerRadius
    }
    set {
    layer.cornerRadius = newValue
    layer.masksToBounds = newValue > 0
    }
    }

    @IBInspectable var borderWidth: CGFloat {
    get {
    return layer.borderWidth
    }
    set {
    layer.borderWidth = newValue
    }
    }

    @IBInspectable var borderColor: UIColor? {
    get {
    return UIColor(cgColor: layer.borderColor!)
    }
    set {
    layer.borderColor = newValue?.cgColor
    }
    }

    @IBInspectable
    var shadowRadius: CGFloat {
    get {
    return layer.shadowRadius
    }
    set {
    layer.shadowRadius = newValue
    }
    }

    @IBInspectable
    var shadowOpacity: Float {
    get {
    return layer.shadowOpacity
    }
    set {
    layer.shadowOpacity = newValue
    }
    }

    @IBInspectable
    var shadowOffset: CGSize {
    get {
    return layer.shadowOffset
    }
    set {
    layer.shadowOffset = newValue
    }
    }

    @IBInspectable
    var shadowColor: UIColor? {
    get {
    if let color = layer.shadowColor {
    return UIColor(cgColor: color)
    }
    return nil
    }
    set {
    if let color = newValue {
    layer.shadowColor = color.cgColor
    } else {
    layer.shadowColor = nil
    }
    }
    }
}


