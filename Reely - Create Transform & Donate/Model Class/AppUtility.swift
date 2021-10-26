

import Foundation
import UIKit
import AVFoundation
import Photos
import AssetsLibrary
import ProgressHUD
import Alamofire

var gradientLayer: CAGradientLayer!
var userDefaults = UserDefaults.standard
var documentController:UIDocumentInteractionController!
var ReferalURL = ""
var ReferalCode = ""

let FONT_LETSUP_MEDIUM = UIFont(name: "SFUIText-RegularG1", size: 17.0)!
let FONT_LETSUP_REGULAR = UIFont(name: "Roboto-Regular", size: 13.0)!

var player : AVAudioPlayer!
var currentPlayIndex = 0
var isPlay = false
var isPaymentdoneForOrderList = false
var isPaymentdoneForSoilTest = false
var isPaymentdoneForbooking = false
var isPaymentdoneForpurchase = false

//var audioArray = [PodcastPod]()
//var videoArray = [PodcastPod]()
// Colors COde
let PRIMARY_COLOR = hexStringToUIColor(hex: "#0EBA46") // Green
let Dark_BACKGROUND_COLOR = hexStringToUIColor(hex: "#465A65") // Dark Gray

let DEFAULT_BLUE = hexStringToUIColor(hex: "#2383F7")
let LIGHT_GRAY_MAIN = hexStringToUIColor(hex: "#C7C6CC")

let FONT_COLOR = hexStringToUIColor(hex: "#19315B")
let FONT_SECOUNDRY_COLOR = hexStringToUIColor(hex: "#19315B").withAlphaComponent(0.80)

let BORDER_COLOR = hexStringToUIColor(hex: "#19315B").withAlphaComponent(0.20)
let GREEN_COLOR = hexStringToUIColor(hex: "#28D094").withAlphaComponent(0.80)
let RED_COLOR = hexStringToUIColor(hex: "#FA2337").withAlphaComponent(0.80)

let LIGHT_BLUE_UNSELECTED_COLOR = hexStringToUIColor(hex: "#8793A8")

var pdfDATA:Data!

var totalDuration = ""
var totalDurationFloat = 0.0

var currentDuration = ""
var currentDurationFloat = 0.0

var timer = Timer()
var tempTotalTime = 0.0
//var activityIndicator = NVActivityIndicatorView(frame: .zero, type: NVActivityIndicatorType.ballRotateChase, color: Green_Agri10x, padding: 10.0)

var cars = ["Audi", "Aston Martin","BMW", "Bugatti", "Bentley","Chevrolet", "Cadillac","Dodge","Ferrari", "Ford","Honda","Jaguar","Lamborghini","Mercedes", "Mazda","Nissan","Porsche","Rolls Royce","Toyota","Volkswagen"]

var StateArray = ["Andhra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", "Chhattisgarh", "Goa", "Gujarat", "Haryana", "Himachal Pradesh", "Jammu & Kashmir", "Jharkhand", "Karnataka", "Kerala", "Madhya Pradesh", "Maharashtra", "Manipur", "Meghalaya", "Mizoram", "Nagaland", "Odisha", "Punjab", "Rajasthan", "Sikkim", "Tamil Nadu", "Tripura", "Uttarakhand", "Uttar Pradesh", "West Bengal", "Andaman & Nicobar", "Chandigarh", "Dadra and Nagar Haveli", "Daman & Diu", "Delhi", "Lakshadweep", "Puducherry"]

// To set Color in hexa color code
func hexStringToUIColor(hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
func replaceStringForMessage(str: String) -> String {
    
    let newString = str.replacingOccurrences(of: "*", with: "")
    let newString2 = newString.replacingOccurrences(of: "_", with: "")
    let newString3 = newString2.replacingOccurrences(of: "~", with: "")
    
    return newString3
}

func createPhotoLibraryAlbum(albumName: String, strURL: String, name: String, isVideo: Bool) {
    var albumPlaceholder: PHObjectPlaceholder?
    PHPhotoLibrary.shared().performChanges({
        // Request creating an album with parameter name
        let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
        // Get a placeholder for the new album
        albumPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
    }, completionHandler: { success, error in
        if success {
            guard let placeholder = albumPlaceholder else {
                fatalError("Album placeholder is nil")
            }
            
            let fetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [placeholder.localIdentifier], options: nil)
            guard let album: PHAssetCollection = fetchResult.firstObject else {
                // FetchResult has no PHAssetCollection
                return
            }
            
            checkAndCreateAlbum(strURL: strURL, name: name, isVideo: isVideo)
            // Saved successfully!
            print(album.assetCollectionType)
        }
        else if let e = error {
            // Save album failed with error
        }
        else {
            // Save album failed with no error
        }
    })
}

func checkAndCreateAlbum(strURL: String, name: String, isVideo: Bool) {
    
    let albumName = "LetsUp"
    var assetCollection = PHAssetCollection()
    var albumFound = Bool()
    var photoAssets = PHFetchResult<AnyObject>()
    
    let fetchOptions = PHFetchOptions()
    fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
    
    let collection:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
    
    if let firstObject = collection.firstObject{
        //found the album
        assetCollection = firstObject
        albumFound = true
        
        if isVideo {
            saveVideoToGallary(strURL: strURL, name: name, album: assetCollection)
        }
        else {
            savePhotoToGallary(strURL: strURL, name: name, album: assetCollection)
        }
        
    }
    else {
        albumFound = false
        createPhotoLibraryAlbum(albumName: "LetsUp", strURL: strURL, name: name, isVideo: isVideo)
    }
    
    
}

func saveVideoToGallary(strURL: String, name: String, album: PHAssetCollection) {
    
    DispatchQueue.global(qos: .background).async {
        if let url = URL(string: strURL),
            let urlData = NSData(contentsOf: url) {
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
            let filePath="\(documentsPath)/\(name)"
            DispatchQueue.main.async {
                urlData.write(toFile: filePath, atomically: true)
                PHPhotoLibrary.shared().performChanges({
                    let createAssetRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
                    let assetPlaceholder = createAssetRequest?.placeholderForCreatedAsset
                    let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
                    //PHAssetCollectionChangeRequest(forAssetCollection: album, assets: self.photosAsset)
                    albumChangeRequest?.addAssets([assetPlaceholder!] as NSFastEnumeration)
                }, completionHandler: { (success, error) in
                    if success {
                        print("Video is saved!")
                        //self.view.makeToast("Video Saved!!")
                    }
                    print(error)
                })
                
            }
        }
    }
}
func savePhotoToGallary(strURL: String, name: String, album: PHAssetCollection) {
    
    DispatchQueue.global(qos: .background).async {
        if let url = URL(string: strURL),
            let urlData = NSData(contentsOf: url) {
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
            let filePath="\(documentsPath)/\(name)"
            DispatchQueue.main.async {
                urlData.write(toFile: filePath, atomically: true)
                PHPhotoLibrary.shared().performChanges({
                    let createAssetRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: URL(fileURLWithPath: filePath))
                    let assetPlaceholder = createAssetRequest?.placeholderForCreatedAsset
                    let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
                    //PHAssetCollectionChangeRequest(forAssetCollection: album, assets: self.photosAsset)
                    albumChangeRequest?.addAssets([assetPlaceholder!] as NSFastEnumeration)
                }, completionHandler: { (success, error) in
                    if success {
                        print("Image is saved!")
                        //self.view.makeToast("Image Saved!!")
                    }
                    print(error)
                })
                
            }
        }
    }
}


extension UIView {
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards//CAMediaTimingFillMode.forwards
        
        self.layer.add(animation, forKey: nil)
    }
    
    func dropShadow(scale: Bool = true , cornerRadius : Float) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = .zero
        layer.shadowRadius = 3
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ?
            UIScreen.main.scale : 1
        layer.cornerRadius = CGFloat(cornerRadius)
    }
    
    
   //  var indicator = NVActivityIndicatorView(frame: .zero, type: NVActivityIndicatorType.ballRotateChase, color: Green_Agri10x, padding: 10)
    
}


extension Double {
    // Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
    
    func toRoundDouble() -> Double {
        let roundedValue1 = (self * 100000).rounded(.toNearestOrEven) / 100000
        print(roundedValue1) // returns 0.684
        return roundedValue1
    }
}

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}

extension UIViewController {

    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func KeyboardTapped(){
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height - 70
                
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
        
    }

    
    func simpleAlert(title: String, details: String) {
        let alert = UIAlertController(title: "\(title)", message: "\(details)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
//    func setLoading() {
//                let frame = CGRect(origin: view.center, size: CGSize(width: 70, height: 70))
//                NVActivityIndicatorView(frame: frame, type: NVActivityIndicatorType.ballRotateChase, color: Dark_BACKGROUND_COLOR, padding: 10.0)
//                NVActivityIndicatorView.startAnimating(self)
//
//        startAnimating(CGSize(width: 70 , height: 70), message: "", type: NVActivityIndicatorType.ballRotateChase, color: Dark_BACKGROUND_COLOR, backgroundColor: UIColor.clear, textColor: .black)
//    }

//    func hideLoading() {
//        stopAnimating()
//    }
   
    
    func setLoading() {
        
        self.view.isUserInteractionEnabled = false
        
        ProgressHUD.show("")
        ProgressHUD.show("", interaction: false)
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.colorHUD = .systemGray
        ProgressHUD.colorBackground = .clear
        ProgressHUD.colorAnimation = UIColor.systemGreen
        ProgressHUD.colorProgress = UIColor.systemGreen

  

    }

    func hideLoading() {
        ProgressHUD.dismiss()
        self.view.isUserInteractionEnabled = true

        
    }
    
    func backTwo() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    
    func isValidEmail(emailAddressString:String) -> Bool {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return returnValue
    }
    
    func setShadowToView(shView: UIView, mnView: UIView) {
        shView.layer.shadowColor = UIColor.darkGray.cgColor
        shView.layer.shadowOpacity = 0.5
        shView.layer.shadowOffset = CGSize.zero
        shView.layer.shadowRadius = 8
        shView.backgroundColor = UIColor.clear
        
        mnView.layer.cornerRadius = 5.0
        mnView.clipsToBounds = true
    }
    
    func setRoundCornerToView(mnView: UIView, radius: CGFloat) {
        mnView.layer.cornerRadius = radius
        mnView.clipsToBounds = true
    }
    
    func setBorderToView(mnView: UIView, color: UIColor) {
        mnView.layer.borderWidth = 1.0
        mnView.layer.borderColor = color.cgColor
        
        mnView.layer.cornerRadius = 5.0
        mnView.clipsToBounds = true
    }
    
    // MARK: Share Text To Whatsapp
    func shareByWhatsapp(msg:String){
        let urlWhats = "whatsapp://send?text=\(msg)"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if let whatsappURL = NSURL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                    UIApplication.shared.openURL(whatsappURL as URL)
                } else {
                    
                    let alert = UIAlertController(title: NSLocalizedString("Whatsapp not found", comment: "Error message"),
                                                  message: NSLocalizedString("Could not found a installed app 'Whatsapp' to proceed with sharing.", comment: "Error description"),
                                                  preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Alert button"), style: .default, handler:{ (UIAlertAction)in
                    }))
                    
                    self.present(alert, animated: true, completion:nil)
                    // Cannot open whatsapp
                }
            }
        }
    }
    func shareByWhatsapp2(msg:String, msg2 :String) {
        let urlWhats = "whatsapp://send?text=\(msg + "\n\n" +  msg2)"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if let whatsappURL = NSURL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                    UIApplication.shared.openURL(whatsappURL as URL)
                } else {
                    
                    let alert = UIAlertController(title: NSLocalizedString("Whatsapp not found", comment: "Error message"),
                                                  message: NSLocalizedString("Could not found a installed app 'Whatsapp' to proceed with sharing.", comment: "Error description"),
                                                  preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Alert button"), style: .default, handler:{ (UIAlertAction)in
                    }))
                    
                    self.present(alert, animated: true, completion:nil)
                    // Cannot open whatsapp
                }
            }
        }
    }
    
    // MARK: Share Image To Whatsapp
    func sharePicture(img: UIImage) {
        let urlWhats = "whatsapp://app"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            if let whatsappURL = NSURL(string: urlString) {
                
                if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                    
                    if let imageData = img.jpegData(compressionQuality: 0.75) {
                        let tempFile = NSURL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Documents/yourImageName.jpg")
                        do {
                            try imageData.write(to: tempFile!, options: .atomicWrite)
                            documentController = UIDocumentInteractionController(url: tempFile!)
                            documentController.uti = "net.whatsapp.image"
                            documentController.presentOpenInMenu(from: CGRect.zero, in: self.view, animated: true)
                        } catch {
                            print(error)
                        }
                    }
                } else {
                    // Cannot open whatsapp
                    let alert = UIAlertController(title: NSLocalizedString("Whatsapp not found", comment: "Error message"),
                                                  message: NSLocalizedString("Could not found a installed app 'Whatsapp' to proceed with sharing.", comment: "Error description"),
                                                  preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Alert button"), style: .default, handler:{ (UIAlertAction)in
                    }))
                    
                    self.present(alert, animated: true, completion:nil)
                    
                    print("Whatsapp isn't installed ")
                }
            }
        }
    }
    func shareVideo(str: String) {
        
        DispatchQueue.main.async {
            let url = URL(string: str)
            let videoData = try? Data.init(contentsOf: url!)
            let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
            let videoUrl = "demo.mp4"
            let actualPath = resourceDocPath.appendingPathComponent(videoUrl)
            print(actualPath)
            
            do {
                try videoData?.write(to: actualPath, options: .atomic)
                print("Video successfully saved!")
                let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
                for url in contents {
                    if url.description.contains("demo.mp4") {
                        
                        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                        activityViewController.popoverPresentationController?.sourceView=self.view
                        self.present(activityViewController, animated: true, completion: nil)
                    }
                }
            }catch {
                print("video could not be saved")
            }
        }
    }
    func savePdf(str: String){
        
        DispatchQueue.main.async {
            let url = URL(string: str)
            let pdfData = try? Data.init(contentsOf: url!)
            let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
            let pdfNameFromUrl = "demo.pdf"
            let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
            print(actualPath)
            
            do {
                try pdfData?.write(to: actualPath, options: .atomic)
                print("pdf successfully saved!")
                let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
                for url in contents {
                    if url.description.contains("demo.pdf") {
                        
                        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                        activityViewController.popoverPresentationController?.sourceView=self.view
                        self.present(activityViewController, animated: true, completion: nil)
                    }
                }
                
            } catch {
                print("Pdf could not be saved")
            }
        }
        
    }
    
    func openAnyURL(str: String) {
        
        guard let url = URL(string: str) else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
        
    }
    func openAnyURL2(str: String, str2: String) {
           
           guard let url = URL(string: str + str2) else {
               return //be safe
           }
           
           if #available(iOS 10.0, *) {
               UIApplication.shared.open(url, options: [:], completionHandler: nil)
           } else {
               UIApplication.shared.openURL(url)
           }
           
       }
    func showToast(message : String) {
        let screenWidth = self.view.frame.size.width

//        let toastLabel = UILabel(frame: CGRect(x: screenWidth/2, y: screenWidth / 2, width: 150, height: 35))

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.systemGreen
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Proxima Nova Alt Regular", size: 15.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    
    func goToSettingsForPermission() {
        
        
        let alertController = UIAlertController(title: "Location Permission Required", message: "Please enable location permissions in settings.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
            //Redirect to Settings app
            if let bundleId = Bundle.main.bundleIdentifier,
               let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }

            
            
          //UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)

    }
}
extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .lightGray
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "Roboto-Medium", size: 18.0)!
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
        self.separatorStyle = .none;
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
    
    func scroll(to: Position, animated: Bool) {
        let sections = numberOfSections
        let rows = numberOfRows(inSection: numberOfSections - 1)
        switch to {
        case .top:
            if rows > 0 {
                let indexPath = IndexPath(row: 0, section: 0)
                self.scrollToRow(at: indexPath, at: .top, animated: animated)
            }
            break
        case .bottom:
            if rows > 0 {
                let indexPath = IndexPath(row: rows - 1, section: sections - 1)
                self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
            break
        }
    }
    
    enum Position {
        case top
        case bottom
    }
}
extension UITableViewCell {
    func setShadowToView(shView: UIView, mnView: UIView) {
        shView.layer.shadowColor = UIColor.lightGray.cgColor
        shView.layer.shadowOpacity = 0.5
        shView.layer.shadowOffset = CGSize.zero
        shView.layer.shadowRadius = 8
        shView.backgroundColor = UIColor.clear
        
      //  mnView.layer.cornerRadius = 5.0
        mnView.clipsToBounds = true
    }
    
    func setRoundCornerToView(mnView: UIView, radius: CGFloat) {
        mnView.layer.cornerRadius = radius
        mnView.clipsToBounds = true
    }
}

extension UITableViewHeaderFooterView {
    func setShadowToView(shView: UIView, mnView: UIView) {
        shView.layer.shadowColor = UIColor.lightGray.cgColor
        shView.layer.shadowOpacity = 0.5
        shView.layer.shadowOffset = CGSize.zero
        shView.layer.shadowRadius = 4
        shView.backgroundColor = UIColor.clear
        
        mnView.layer.cornerRadius = 5.0
        mnView.clipsToBounds = true
    }
    
    func setRoundCornerToView(mnView: UIView, radius: CGFloat) {
        mnView.layer.cornerRadius = radius
        mnView.clipsToBounds = true
    }
}

extension UICollectionViewCell {
    func setShadowToView(shView: UIView, mnView: UIView) {
        shView.layer.shadowColor = UIColor.lightGray.cgColor
        shView.layer.shadowOpacity = 0.5
        shView.layer.shadowOffset = CGSize.zero
        shView.layer.shadowRadius = 4
        shView.backgroundColor = UIColor.clear
        
        mnView.layer.cornerRadius = 5.0
        mnView.clipsToBounds = true
    }
    
    func setRoundCornerToView(mnView: UIView, radius: CGFloat) {
        mnView.layer.cornerRadius = radius
        mnView.clipsToBounds = true
    }
    func setBorderToView(mnView: UIView, color: UIColor) {
        mnView.layer.borderWidth = 1.0
        mnView.layer.borderColor = color.cgColor
        
        mnView.layer.cornerRadius = 5.0
        mnView.clipsToBounds = true
    }
    
}

extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}

extension UILabel {
    func set(html: String) {
        if let htmlData = html.data(using: .unicode) {
            do {
                self.attributedText = try NSAttributedString(data: htmlData,
                                                             options: [.documentType: NSAttributedString.DocumentType.html],
                                                             documentAttributes: nil)
            } catch let e as NSError {
                print("Couldn't parse \(html): \(e.localizedDescription)")
            }
        }
    }
}

func randomNumber(with digit: Int) -> Int? {
    
    guard 0 < digit, digit < 20 else { // 0 digit number don't exist and 20 digit Int are to big
        return nil
    }
    
    /// The final ramdom generate Int
    var finalNumber : Int = 0;
    
    for i in 1...digit {
        
        /// The new generated number which will be add to the final number
        var randomOperator : Int = 0
        
        repeat {
            #if os(Linux)
            randomOperator = Int(random() % 9) * Int(powf(10, Float(i - 1)))
            #else
            randomOperator = Int(arc4random_uniform(9)) * Int(powf(10, Float(i - 1)))
            #endif
            
        } while Double(randomOperator + finalNumber) > Double(Int.max) // Verification to be sure to don't overflow Int max size
        
        finalNumber += randomOperator
    }
    
    return finalNumber
}

//func random(digits:Int) -> Int {
//    let min = Int(pow(Double(10), Double(digits-1))) - 1
//    let max = Int(pow(Double(10), Double(digits))) - 1
//
//    return Int(Range(uncheckedBounds: (min, max)))
//}

func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
    let attributedString = NSMutableAttributedString(string: string,
                                                     attributes: [NSAttributedString.Key.font: font])
    let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
    let range = (string as NSString).range(of: boldString)
    attributedString.addAttributes(boldFontAttribute, range: range)
    return attributedString
}

func getDateFromString(str: String) -> Date {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = DateFormatType.dateWithTime.rawValue
    let date = dateFormatter.date(from: str)
    print(date)
    
    
    return date!
    
}
func GetFormatedDate(date_string:String,dateFormat:String)-> String{

   let dateFormatter = DateFormatter()
   dateFormatter.locale = Locale(identifier: "en_US_POSIX")
   dateFormatter.dateFormat = dateFormat

   let dateFromInputString = dateFormatter.date(from: date_string)
   dateFormatter.dateFormat = "MMM dd, yyyy" // Here you can use any dateformate for output date
   if(dateFromInputString != nil){
       return dateFormatter.string(from: dateFromInputString!)
   }
   else{
       debugPrint("could not convert date")
       return "N/A"
   }
}
func GetFormatedDateTime(date_string:String,dateFormat:String)-> String{

   let dateFormatter = DateFormatter()
   dateFormatter.locale = Locale(identifier: "en_US_POSIX")
   dateFormatter.dateFormat = dateFormat

   let dateFromInputString = dateFormatter.date(from: date_string)
   dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss" // Here you can use any dateformate for output date
   if(dateFromInputString != nil){
       return dateFormatter.string(from: dateFromInputString!)
   }
   else{
       debugPrint("could not convert date")
       return "N/A"
   }
}
func getCurrentTimeStampWOMiliseconds(dateToConvert: NSDate) -> String {
    let objDateformat: DateFormatter = DateFormatter()
    objDateformat.dateFormat = "yyyy-MM-dd"
    let strTime: String = objDateformat.string(from: dateToConvert as Date)
    let objUTCDate: NSDate = objDateformat.date(from: strTime)! as NSDate
    let milliseconds: Int64 = Int64(objUTCDate.timeIntervalSince1970)
    let strTimeStamp: String = "\(milliseconds)"
    return strTimeStamp
}
func getCurrentDateInString() -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = DateFormatType.dateWithTime.rawValue
    
    let date = dateFormatter.string(from: Date())
    print(date)
    
    return date
    
}
func miliSecFromDate(date : String) -> String {
    let strTime = date
    let formatter = DateFormatter()
    formatter.dateFormat = "E MMM d HH:mm:ss Z yyyy"
    let ObjDate = formatter.date(from: strTime)
    return (String(describing: ObjDate!.millisecondsSince1970))
}

extension Date {
    
    var day:Int {return Calendar.current.component(.day, from:self)}
    var month:Int {return Calendar.current.component(.month, from:self)}
    var year:Int {return Calendar.current.component(.year, from:self)}
    var weekDay:Int {return Calendar.current.component(.weekday, from:self)}
    var hours:Int {return Calendar.current.component(.hour, from:self)}
    var minutes:Int {return Calendar.current.component(.minute, from:self)}
    var secounds:Int {return Calendar.current.component(.second, from:self)}
    
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func toMillis() -> Double! {
        
        
        return Double(self.timeIntervalSince1970 * 1000)//Int64(self.timeIntervalSince1970 * 1000)
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
}

extension Date {
    func dateByAddingDays(days: Int) -> Date {
        return self.days(days: days)
    }
    
    func dateBySubstractingDays(days: Int) -> Date {
        return self.days(days: -days)
    }
    
    func days(days:Int) -> Date {
        return Calendar.current.date(byAdding: Calendar.Component.day, value: days, to: Date())!
    }
    
    func dateByAddingSecounds(sec: Int) -> Date {
        return self.secounds(secs: sec)
    }
    
    func dateBySubstractingSecounds(sec: Int) -> Date {
        return self.secounds(secs: -sec)
    }
    
    func secounds(secs:Int) -> Date {
        
        
        return Calendar.current.date(byAdding: Calendar.Component.second, value: secs, to: Date())!
    }
    
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

extension Date {
  
    func dateAtPrevMidnight() -> Date? {
        
        let date                = Date().dateBySubstractingDays(days: 1)
        let calendar            = Calendar.current
        let components          = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        // Specify date components
        var dateComponents      = DateComponents()
        dateComponents.year     = components.year
        dateComponents.month    = components.month
        dateComponents.day      = components.day
        dateComponents.timeZone = TimeZone(abbreviation: "UTC")
        dateComponents.hour     = 0
        dateComponents.minute   = 0
        dateComponents.second   = 0
        
        // Create date from components
        let userCalendar    = Calendar.current
        let dateTime        = userCalendar.date(from: dateComponents)
        
        return dateTime
    }

    
    
}

enum DateFormatType: String {
    /// Time
    case time = "HH:mm:ss"
    case timeIN24 = "HH:mm"
    
    case onlyTimeAMPM = "hh:mm a"
    
    /// Date with hours
    case dateWithTime = "yyyy-MM-dd HH:mm:ss"
    case dateAndTimeAMPM = "dd/MM/yyyy hh:mm a"
    
    case orderDatePlace = "dd-MM-yyyy HH:mm:ss"
    case orderCancelDate = "dd-MM-yyyy HH:mm"
    
    /// Date
    case date = "dd-MMM-yyyy"
    case day = "dd"
    case dateWithSpace = "dd MMM yyyy"
    
    /// SimpleDate
    case simpledate = "yyyy-MM-dd"
    case simpleSlashdate = "dd/MM/yyyy"
    
    case onlyFullDate = "yyyy/MM/dd"
    case ShowDate = "MMM dd yyyy"
}

/// Convert String to Date
func convertToDate(dateString: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = DateFormatType.onlyFullDate.rawValue // Your date format
    let serverDate: Date = dateFormatter.date(from: dateString)! // according to date format your date string
    return serverDate
}

//get Difference time to show
func timeAgoSinceDate(_ date:Date,currentDate:Date, numericDates:Bool) -> String {
    let calendar = Calendar.current
    let now = currentDate
    let earliest = (now as NSDate).earlierDate(date)
    let latest = (earliest == now) ? date : now
    let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
    
    if (components.year! >= 2) {
        return "\(components.year!) years ago"
    } else if (components.year! >= 1){
        if (numericDates){
            return "1 year ago"
        } else {
            return "Last year"
        }
    } else if (components.month! >= 2) {
        return "\(components.month!) months ago"
    } else if (components.month! >= 1){
        if (numericDates){
            return "1 month ago"
        } else {
            return "Last month"
        }
    } else if (components.weekOfYear! >= 2) {
        return "\(components.weekOfYear!) weeks ago"
    } else if (components.weekOfYear! >= 1){
        if (numericDates){
            return "1 week ago"
        } else {
            return "Last week"
        }
    } else if (components.day! >= 2) {
        return "\(components.day!) days ago"
    } else if (components.day! >= 1){
        if (numericDates){
            return "1 day ago"
        } else {
            return "Yesterday"
        }
    } else if (components.hour! >= 2) {
        return "\(components.hour!) hours ago"
    } else if (components.hour! >= 1){
        if (numericDates){
            return "1 hour ago"
        } else {
            return "An hour ago"
        }
    } else if (components.minute! >= 2) {
        return "\(components.minute!) minutes ago"
    } else if (components.minute! >= 1){
        if (numericDates){
            return "1 minute ago"
        } else {
            return "A minute ago"
        }
    } else if (components.second! >= 3) {
        return "\(components.second!) seconds ago"
    } else {
        return "Just now"
    }
    
}

extension String {
 
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length >= 10//self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    //validate Password
    var isValidPassword: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z_0-9\\-_,;.:#+*?=!§$%&/()@]+$", options: .caseInsensitive)
            if(regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil){
                
                if(self.count>=3 && self.count<=12){
                    return true
                }else{
                    return false
                }
            }else{
                return false
            }
        } catch {
            return false
        }
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    mutating func getJSONFormatedString(){
        self = self.replacingOccurrences(of: "(", with: "[")
        self = self.replacingOccurrences(of: ")", with: "]")
        self = self.replacingOccurrences(of: "\n ", with: "\n \"")
        self = self.replacingOccurrences(of: ",", with: "\",")
        self = self.replacingOccurrences(of: "\"\"", with: "\"")
        self = self.replacingOccurrences(of: "\",\"", with: "\",\n \"")
        self = self.replacingOccurrences(of: "[\"", with: "[\n \"")
        self = self.replacingOccurrences(of: "\"]", with: "\"\"\n]")
        self = self.replacingOccurrences(of: "\"\"", with: "\"")
    }
    
    
}
extension URL {
    func queryStringComponents() -> [String: AnyObject] {
        
        var dict = [String: AnyObject]()
        
        // Check for query string
        if let query = self.query {
            
            // Loop through pairings (separated by &)
            for pair in query.components(separatedBy: "&") {
                
                // Pull key, val from from pair parts (separated by =) and set dict[key] = value
                let components = pair.components(separatedBy: "=")
                if (components.count > 1) {
                    dict[components[0]] = components[1] as AnyObject?
                }
            }
            
        }
        
        return dict
    }
}

func videoIDFromYouTubeURL(_ videoURL: URL) -> String? {
       if videoURL.pathComponents.count > 1 && (videoURL.host?.hasSuffix("youtu.be"))! {
           return videoURL.pathComponents[1]
       } else if videoURL.pathComponents.contains("embed") {
           return videoURL.pathComponents.last
       }
       return videoURL.queryStringComponents()["v"] as? String
   }
func validateMobileNo(no: String) -> String {
    var moNumber = no
    if moNumber != "" {
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: NSRegularExpression.Options.caseInsensitive)
        let range = NSMakeRange(0, moNumber.count)
        moNumber = regex.stringByReplacingMatches(in: moNumber, options: [], range: range, withTemplate: "")
        print(moNumber)
        if moNumber.count < 10 {
            return ""//(false,moNumber)
        }
        else {
            return moNumber//(true,moNumber)
        }
    }
    return ""//(false,moNumber)
}

//MARK: UICollectionViewFlowLayout Class
class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
                
                
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing - 15
            maxY = max(layoutAttribute.frame.maxY , maxY)
            
            
        }
        
        return attributes
    }
}

func readJsonForCity() -> [String] {
    do {
        if let file = Bundle.main.url(forResource: "city", withExtension: "json") {
            let data = try Data(contentsOf: file)
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String] {
                    print(json)
                    return json
                }
            } catch {
                print(error.localizedDescription)
                return []
            }
        } else {
            print("no file")
            return []
        }
    } catch {
        print(error.localizedDescription)
        return []
    }
    return []
}


func makeStringFromSet(setString: Set<String>) -> String {
    
    let size = setString.count
    if size == 0 {
        return ""
    }
    var str = ""
    for (index, val) in setString.enumerated() {
        str.append(val)
        if (index < size - 1)
        {
            str.append(",");
        }
    }
    print(str)
    return str
}

func makeStringFromStringArray(setString: [String]) -> String {
    
    let size = setString.count
    if size == 0 {
        return ""
    }
    var str = ""
    for (index, val) in setString.enumerated() {
        str.append(val)
        if (index < size - 1)
        {
            str.append(",");
        }
    }
    print(str)
    return str
}

// Convert Amount String to Selected Currency Formate
let usLocale = Locale(identifier: "en_US") // ($)
let frenchLocale = Locale(identifier: "fr_FR") // (€) option + shift + 4
let germanLocale = Locale(identifier: "de_DE") // (€) option + shift + 4
let englishUKLocale = Locale(identifier: "en_GB") // (£)United Kingdom

var selectedCurrencyFormate = usLocale //Locale.current

func convertStringToCurrency(str: String) -> Double {
    //    let formatter = NumberFormatter()
    //    formatter.locale = selectedCurrencyFormate
    //    formatter.numberStyle = .currency
    //
    //    let currencyFor = formatter.number(from: "9,999.99")
    //
    //    print(currencyFor)
    
    if let cost = Double(str)?.roundToDecimal(5) {
        print("The user entered a value price of \(cost)")
        return cost.roundToDecimal(5)
    } else {
        print("Not a valid number")
        return 0.00000
    }
    
    
}

func getCurrencyValueFromString(val: Double) -> String {
    
    let currencyFormatter = NumberFormatter()
    currencyFormatter.usesGroupingSeparator = true
    currencyFormatter.numberStyle = .currency
    // localize to your grouping and decimal separator
    currencyFormatter.locale = usLocale//Locale.current
    
    // We'll force unwrap with the !, if you've got defined data you may need more error checking
    
    let priceString = currencyFormatter.string(from: NSNumber(value: val))!
    print(priceString) // Displays $9,999.99 in the US locale
    
    return priceString
}

func createGradientLayer(view : UIView, width: CGFloat, height: CGFloat) {
    gradientLayer = CAGradientLayer()
    //gradientLayer.frame = view.frame
    gradientLayer.frame.origin.x = 0
    gradientLayer.frame.origin.y = 0
    gradientLayer.frame.size = CGSize(width: 500, height: height)
    gradientLayer.colors = [UIColor.clear.withAlphaComponent(0.0).cgColor, UIColor.black.withAlphaComponent(0.8).cgColor]
    
    view.layer.addSublayer(gradientLayer)
    view.layoutIfNeeded()
}

extension UIImageView {
    
    public func loadGif(name: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(name: name)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
    @available(iOS 9.0, *)
    public func loadGif(asset: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(asset: asset)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
}

extension UIImage {
    
    public class func gif(data: Data) -> UIImage? {
        // Create source from data
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("SwiftGif: Source for the image does not exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gif(url: String) -> UIImage? {
        // Validate URL
        guard let bundleURL = URL(string: url) else {
            print("SwiftGif: This image named \"\(url)\" does not exist")
            return nil
        }
        
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(url)\" into NSData")
            return nil
        }
        
        return gif(data: imageData)
    }
    
    public class func gif(name: String) -> UIImage? {
        // Check for existance of gif
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gif(data: imageData)
    }
    
    @available(iOS 9.0, *)
    public class func gif(asset: String) -> UIImage? {
        // Create source from assets catalog
        guard let dataAsset = NSDataAsset(name: asset) else {
            print("SwiftGif: Cannot turn image named \"\(asset)\" into NSDataAsset")
            return nil
        }
        
        return gif(data: dataAsset.data)
    }
    
    internal class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        // Get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        defer {
            gifPropertiesPointer.deallocate()
        }
        let unsafePointer = Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()
        if CFDictionaryGetValueIfPresent(cfProperties, unsafePointer, gifPropertiesPointer) == false {
            return delay
        }
        
        let gifProperties: CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)
        
        // Get delay time
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        if let delayObject = delayObject as? Double, delayObject > 0 {
            delay = delayObject
        } else {
            delay = 0.1 // Make sure they're not too fast
        }
        
        return delay
    }
    
    internal class func gcdForPair(_ lhs: Int?, _ rhs: Int?) -> Int {
        var lhs = lhs
        var rhs = rhs
        // Check if one of them is nil
        if rhs == nil || lhs == nil {
            if rhs != nil {
                return rhs!
            } else if lhs != nil {
                return lhs!
            } else {
                return 0
            }
        }
        
        // Swap for modulo
        if lhs! < rhs! {
            let ctp = lhs
            lhs = rhs
            rhs = ctp
        }
        
        // Get greatest common divisor
        var rest: Int
        while true {
            rest = lhs! % rhs!
            
            if rest == 0 {
                return rhs! // Found it
            } else {
                lhs = rhs
                rhs = rest
            }
        }
    }
    
    internal class func gcdForArray(_ array: [Int]) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    internal class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        // Fill arrays
        for index in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, index, nil) {
                images.append(image)
            }
            
            // At it's delay in cs
            let delaySeconds = UIImage.delayForImageAtIndex(Int(index),
                                                            source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        // Calculate full duration
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        // Get frames
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for index in 0..<count {
            frame = UIImage(cgImage: images[Int(index)])
            frameCount = Int(delays[Int(index)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        // Heyhey
        let animation = UIImage.animatedImage(with: frames,
                                              duration: Double(duration) / 1000.0)
        
        return animation
    }
    
}

extension UIView {
    func addDashedBorder() {
        let color = GREEN_COLOR.cgColor

        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)

        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 4).cgPath

        self.layer.addSublayer(shapeLayer)
    }
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = .zero
        layer.shadowRadius = 3
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ?
            UIScreen.main.scale : 1
        layer.cornerRadius = 5
    }
    
    

}

