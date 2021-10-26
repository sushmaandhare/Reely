//
//  AnimationVC.swift
//  Reely - Create Transform & Donate
//
//  Created by Mac on 03/08/21.
//

import UIKit

class AnimationVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: TabbarViewController = storyboard.instantiateViewController(withIdentifier: "TabbarViewController") as! TabbarViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
