//
//  TrimmerViewController.swift
//  Reely - Create Transform & Donate
//
//  Created by Mac on 12/08/21.
//

import UIKit
import AVFoundation
import AVKit

class TrimmerViewController: UIViewController {
    
    
    @IBOutlet weak var speedView: UIView!
    @IBOutlet weak var imageFrameView: UIView!
    @IBOutlet weak var frameContainerView: UIView!
    @IBOutlet weak var videoPlayerView: UIView!
    @IBOutlet weak var btnDismiss: UIButton!
    @IBOutlet weak var buttonDone: UIButton!
    
    
    @IBOutlet weak var btnFastThreeX: UIButton!
    @IBOutlet weak var btnFastTwoX: UIButton!
    @IBOutlet weak var btnOneX: UIButton!
    @IBOutlet weak var btnSlowTwoX: UIButton!
    @IBOutlet weak var btnSlowThreeX: UIButton!
    
    var myVideoURL: URL!
    var videoSpeed : Double = 1.0
    var myPlayer:AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(myVideoURL)
        // Do any additional setup after loading the view.
    }
    

    
    
    @IBAction func ontapDismiss(_ sender: UIButton) {
    }
    
    
    @IBAction func doneBtnAction(_ sender: UIButton) {
    }
    
    
    
    @IBAction func onTapSlowThreeX(_ sender: UIButton) {
        UserDefaults.standard.set(nil, forKey: "finalVideo")
        
        self.btnSlowThreeX.backgroundColor = .white
        self.btnSlowThreeX.layer.cornerRadius = 5
        self.btnSlowThreeX.setTitleColor(.black, for: .normal)
        self.btnSlowTwoX.backgroundColor = .black
        self.btnSlowTwoX.layer.cornerRadius = 0
        self.btnSlowTwoX.setTitleColor(.white, for: .normal)
        self.btnOneX.backgroundColor = .black
        self.btnOneX.layer.cornerRadius = 0
        self.btnOneX.setTitleColor(.white, for: .normal)
        self.btnFastTwoX.backgroundColor = .black
        self.btnFastTwoX.layer.cornerRadius = 0
        self.btnFastTwoX.setTitleColor(.white, for: .normal)
        self.btnFastThreeX.backgroundColor = .black
        self.btnFastThreeX.layer.cornerRadius = 0
        self.btnFastThreeX.setTitleColor(.white, for: .normal)
        if myVideoURL != nil{
        VSVideoSpeeder.shared.scaleAsset(fromURL: myVideoURL, by: 3, withMode: SpeedoMode.Slower) { (exporter) in
             if let exporter = exporter {
                 switch exporter.status {
                        case .failed: do {
                              print(exporter.error?.localizedDescription ?? "Error in exporting..")
                        }
                        case .completed: do {
                              print("Scaled video has been generated successfully!")
                        }
                        case .unknown: break
                        case .waiting: break
                        case .exporting: break
                        case .cancelled: break
                   }
              }
              else {
                   /// Error
                   print("Exporter is not initialized.")
              }
        }
        }
            videoSpeed = 0.3
    }
    
    
    @IBAction func onTapSlowTwoX(_ sender: UIButton) {
        UserDefaults.standard.set(nil, forKey: "finalVideo")
        
        self.btnSlowThreeX.backgroundColor = .black
        self.btnSlowThreeX.layer.cornerRadius = 0
        self.btnSlowThreeX.setTitleColor(.white, for: .normal)
        self.btnSlowTwoX.backgroundColor = .white
        self.btnSlowTwoX.layer.cornerRadius = 5
        self.btnSlowTwoX.setTitleColor(.black, for: .normal)
        self.btnOneX.backgroundColor = .black
        self.btnOneX.layer.cornerRadius = 0
        self.btnOneX.setTitleColor(.white, for: .normal)
        self.btnFastTwoX.backgroundColor = .black
        self.btnFastTwoX.layer.cornerRadius = 0
        self.btnFastTwoX.setTitleColor(.white, for: .normal)
        self.btnFastThreeX.backgroundColor = .black
        self.btnFastThreeX.layer.cornerRadius = 0
        self.btnFastThreeX.setTitleColor(.white, for: .normal)
        
        if myVideoURL != nil{
        VSVideoSpeeder.shared.scaleAsset(fromURL: myVideoURL, by: 2, withMode: SpeedoMode.Slower) { (exporter) in
             if let exporter = exporter {
                 switch exporter.status {
                        case .failed: do {
                              print(exporter.error?.localizedDescription ?? "Error in exporting..")
                        }
                        case .completed: do {
                              print("Scaled video has been generated successfully!")
                        }
                        case .unknown: break
                        case .waiting: break
                        case .exporting: break
                        case .cancelled: break
                   }
              }
              else {
                   /// Error
                   print("Exporter is not initialized.")
              }
            }}
            videoSpeed = 0.2
    }
    
    
    
    @IBAction func onTapOneX(_ sender: UIButton) {
        UserDefaults.standard.set(nil, forKey: "finalVideo")
        
              self.btnSlowThreeX.backgroundColor = .black
              self.btnSlowThreeX.layer.cornerRadius = 0
              self.btnSlowThreeX.setTitleColor(.white, for: .normal)
              self.btnSlowTwoX.backgroundColor = .black
              self.btnSlowTwoX.layer.cornerRadius = 0
              self.btnSlowTwoX.setTitleColor(.white, for: .normal)
              self.btnOneX.backgroundColor = .white
              self.btnOneX.layer.cornerRadius = 5
              self.btnOneX.setTitleColor(.black, for: .normal)
              self.btnFastTwoX.backgroundColor = .black
              self.btnFastTwoX.layer.cornerRadius = 0
              self.btnFastTwoX.setTitleColor(.white, for: .normal)
              self.btnFastThreeX.backgroundColor = .black
              self.btnFastThreeX.layer.cornerRadius = 0
              self.btnFastThreeX.setTitleColor(.white, for: .normal)
              
        if myVideoURL != nil{
        VSVideoSpeeder.shared.scaleAsset(fromURL: myVideoURL, by: 1, withMode: SpeedoMode.Faster) { (exporter) in
             if let exporter = exporter {
                 switch exporter.status {
                        case .failed: do {
                              print(exporter.error?.localizedDescription ?? "Error in exporting..")
                        }
                        case .completed: do {
                              print("Scaled video has been generated successfully!")
                        }
                        case .unknown: break
                        case .waiting: break
                        case .exporting: break
                        case .cancelled: break
                   }
              }
              else {
                   /// Error
                   print("Exporter is not initialized.")
              }
            }}
            videoSpeed = 1.0
       }
    
    
    
    @IBAction func onTapFastTwoX(_ sender: UIButton) {
        UserDefaults.standard.set(nil, forKey: "finalVideo")
        
        self.btnSlowThreeX.backgroundColor = .black
              self.btnSlowThreeX.layer.cornerRadius = 0
              self.btnSlowThreeX.setTitleColor(.white, for: .normal)
              self.btnSlowTwoX.backgroundColor = .black
              self.btnSlowTwoX.layer.cornerRadius = 0
              self.btnSlowTwoX.setTitleColor(.white, for: .normal)
              self.btnOneX.backgroundColor = .black
              self.btnOneX.layer.cornerRadius = 0
              self.btnOneX.setTitleColor(.white, for: .normal)
              self.btnFastTwoX.backgroundColor = .white
              self.btnFastTwoX.layer.cornerRadius = 5
              self.btnFastTwoX.setTitleColor(.black, for: .normal)
              self.btnFastThreeX.backgroundColor = .black
              self.btnFastThreeX.layer.cornerRadius = 0
              self.btnFastThreeX.setTitleColor(.white, for: .normal)
              
        if myVideoURL != nil{
        VSVideoSpeeder.shared.scaleAsset(fromURL: myVideoURL, by: 2, withMode: SpeedoMode.Faster) { (exporter) in
             if let exporter = exporter {
                 switch exporter.status {
                        case .failed: do {
                              print(exporter.error?.localizedDescription ?? "Error in exporting..")
                        }
                        case .completed: do {
                              print("Scaled video has been generated successfully!")
                        }
                        case .unknown: break
                        case .waiting: break
                        case .exporting: break
                        case .cancelled: break
                   }
              }
              else {
                   /// Error
                   print("Exporter is not initialized.")
              }
            }}
            videoSpeed = 2.0
       }
    
    
    @IBAction func onTapFastThreeX(_ sender: UIButton) {
        UserDefaults.standard.set(nil, forKey: "finalVideo")
        self.btnSlowThreeX.backgroundColor = .black
              self.btnSlowThreeX.layer.cornerRadius = 0
        self.btnSlowThreeX.setTitleColor(.white, for: .normal)
              self.btnSlowTwoX.backgroundColor = .black
              self.btnSlowTwoX.layer.cornerRadius = 0
              self.btnSlowTwoX.setTitleColor(.white, for: .normal)
              self.btnOneX.backgroundColor = .black
              self.btnOneX.layer.cornerRadius = 0
              self.btnOneX.setTitleColor(.white, for: .normal)
              self.btnFastTwoX.backgroundColor = .black
              self.btnFastTwoX.layer.cornerRadius = 0
              self.btnFastTwoX.setTitleColor(.white, for: .normal)
              self.btnFastThreeX.backgroundColor = .white
              self.btnFastThreeX.layer.cornerRadius = 5
              self.btnFastThreeX.setTitleColor(.black, for: .normal)
              
        if myVideoURL != nil{
        VSVideoSpeeder.shared.scaleAsset(fromURL: myVideoURL, by: 3, withMode: SpeedoMode.Faster) { (exporter) in
             if let exporter = exporter {
                 switch exporter.status {
                        case .failed: do {
                              print(exporter.error?.localizedDescription ?? "Error in exporting..")
                        }
                        case .completed: do {
                              print("Scaled video has been generated successfully!")
                        }
                        case .unknown: break
                        case .waiting: break
                        case .exporting: break
                        case .cancelled: break
                   }
              }
              else {
                   /// Error
                   print("Exporter is not initialized.")
              }
            }}
            videoSpeed = 3.0
       }
    
    func applySpeed(url:URL){
        UserDefaults.standard.set(nil, forKey: "finalVideo")
        switch videoSpeed {
        case 0.3:
            VSVideoSpeeder.shared.scaleAsset(fromURL: url, by: 3, withMode: SpeedoMode.Slower) { (exporter) in
                if let exporter = exporter {
                    switch exporter.status {
                    case .failed: do {
                        print(exporter.error?.localizedDescription ?? "Error in exporting..")
                        }
                    case .completed: do {
                        print("Scaled video has been generated successfully!")
                        // self.upload(url: url)
                        }
                    case .unknown: break
                    case .waiting: break
                    case .exporting: break
                    case .cancelled: break
                    }
                }
                else {
                    /// Error
                    print("Exporter is not initialized.")
                }
            }
        case 0.2:
            VSVideoSpeeder.shared.scaleAsset(fromURL: url, by: 2, withMode: SpeedoMode.Slower) { (exporter) in
                if let exporter = exporter {
                    switch exporter.status {
                    case .failed: do {
                        print(exporter.error?.localizedDescription ?? "Error in exporting..")
                        }
                    case .completed: do {
                        print("Scaled video has been generated successfully!")
                        //self.upload(url: url)
                        }
                    case .unknown: break
                    case .waiting: break
                    case .exporting: break
                    case .cancelled: break
                    }
                }
                else {
                    /// Error
                    print("Exporter is not initialized.")
                }
            }
        case 1.0 :
            VSVideoSpeeder.shared.scaleAsset(fromURL: url, by: 1, withMode: SpeedoMode.Faster) { (exporter) in
                if let exporter = exporter {
                    switch exporter.status {
                    case .failed: do {
                        print(exporter.error?.localizedDescription ?? "Error in exporting..")
                        }
                    case .completed: do {
                        print("Scaled video has been generated successfully!")
                        // self.upload(url: url)
                        }
                    case .unknown: break
                    case .waiting: break
                    case .exporting: break
                    case .cancelled: break
                    }
                }
                else {
                    /// Error
                    print("Exporter is not initialized.")
                }
            }
        case 2.0:
            VSVideoSpeeder.shared.scaleAsset(fromURL: url, by: 2, withMode: SpeedoMode.Faster) { (exporter) in
                if let exporter = exporter {
                    switch exporter.status {
                    case .failed: do {
                        print(exporter.error?.localizedDescription ?? "Error in exporting..")
                        }
                    case .completed: do {
                        print("Scaled video has been generated successfully!")
                        // self.upload(url: url)
                        }
                    case .unknown: break
                    case .waiting: break
                    case .exporting: break
                    case .cancelled: break
                    }
                }
                else {
                    /// Error
                    print("Exporter is not initialized.")
                }
            }
        case 3.0:
            VSVideoSpeeder.shared.scaleAsset(fromURL: url, by: 3, withMode: SpeedoMode.Faster) { (exporter) in
                if let exporter = exporter {
                    switch exporter.status {
                    case .failed: do {
                        print(exporter.error?.localizedDescription ?? "Error in exporting..")
                        }
                    case .completed: do {
                        print("Scaled video has been generated successfully!")
                        // self.upload(url: url)
                        }
                    case .unknown: break
                    case .waiting: break
                    case .exporting: break
                    case .cancelled: break
                    }
                }
                else {
                    /// Error
                    print("Exporter is not initialized.")
                }
            }
        default:
            VSVideoSpeeder.shared.scaleAsset(fromURL: url, by: 1, withMode: SpeedoMode.Faster) { (exporter) in
                if let exporter = exporter {
                    switch exporter.status {
                    case .failed: do {
                        print(exporter.error?.localizedDescription ?? "Error in exporting..")
                        
                        }
                    case .completed: do {
                        print("Scaled video has been generated successfully!")
                        //  self.upload(url: url)
                        }
                    case .unknown: break
                    case .waiting: break
                    case .exporting: break
                    case .cancelled: break
                    }
                }
                else {
                    /// Error
                    print("Exporter is not initialized.")
                }
            }
        }
        
        
    }
}
