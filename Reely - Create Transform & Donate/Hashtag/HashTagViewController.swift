//
//  HashTagViewController.swift
//  Reely - Create Transform & Donate
//
//  Created by MacBook Air on 20/07/1943 Saka.
//

import UIKit
import Alamofire
import SDWebImage

class HashTagViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var hashTagModel: HashTagModel?
    var videoMsg: VideoMsg?
    
    @IBOutlet weak var hashTagCollectionView: UICollectionView!
    @IBOutlet weak var imgViewHashTagView: UIImageView!
    @IBOutlet weak var lblHashTag: UILabel!
    @IBOutlet weak var lblViews: UILabel!
    
    @IBAction func btnViewsClick(_ sender: Any) {
        
    }
    
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
        callAPI()
    }
    
    private func initialSetUp() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        
        let screenSize: CGRect = UIScreen.main.bounds
        flowLayout.itemSize = CGSize(width: ((screenSize.size.width)/3) - 20, height: 200)
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.hashTagCollectionView.collectionViewLayout = flowLayout
        self.hashTagCollectionView.delegate = self
        self.hashTagCollectionView.dataSource = self
    }
    
    private func callAPI() {
        let url : String = self.appDelegate.baseUrl!+self.appDelegate.discover_details!
    
        let parameter :[String:Any]? = ["fb_id":UserDefaults.standard.string(forKey: "uid")!,
                                        "middle_name":"osd191k3hEZm5PzMfoboJy5l466w7szI",
                                        "offset":"0",
                                        "section_id":videoMsg?.section_id ?? "0"]
        
        let headers: HTTPHeaders = [
            "api-key": "4444-3333-2222-1111"
        ]
        
        //"https://realtynextt.com/API/index.php?p=showAllVideosNew"
        Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers).validate().responseData { [weak self] (responseData) in
            switch responseData.result {
            case .success(let json):
                do {
                    self?.hashTagModel = try JSONDecoder().decode(HashTagModel.self, from: json)
                    if let code = self?.hashTagModel?.code, (code == "200") {
                        DispatchQueue.main.async {
                            self?.lblHashTag.text = self?.videoMsg?.section_name ?? ""
                            self?.lblViews.text = "\(self?.videoMsg?.section_views ?? "0")M views"
                            
                            let str = "\(self?.videoMsg?.section_icon ?? "")friendship.png"
                            #warning("temp added becuase URL from response is not completed.")

                            self?.imgViewHashTagView.sd_setImage(with: URL(string: str), placeholderImage: UIImage(), options: SDWebImageOptions.continueInBackground, completed: nil)
                            self?.hashTagCollectionView.reloadData()
                        }
                    }
                } catch let error {
                    print(error)
                }
            case .failure(let error):
                print(error)
                break
            }
        }
    }

}

extension HashTagViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.hashTagModel?.msg?.first?.sections_videos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HashTagCollectionViewCell", for: indexPath) as? HashTagCollectionViewCell {
            cell.videos = self.hashTagModel?.msg?.first?.sections_videos?[indexPath.item]
            cell.callBack = {
    
            }
            return cell
        }
        return UICollectionViewCell(frame: .zero)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "VideoPlayerVC") as? VideoPlayerVC {
            controller.selectedVideo = self.hashTagModel?.msg?.first?.sections_videos?[indexPath.item]
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 150)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return  10
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return  10
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//    }
    
    
    
}
