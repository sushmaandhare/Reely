//
//  DatePickerVC.swift
//  Reely - Create Transform & Donate
//
//  Created by MacBook Air on 16/07/1943 Saka.
//

import UIKit

protocol DatePickerVCDelegate {
    func DismissVC(date:Date?)
}


class DatePickerVC: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    var delegate : DatePickerVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.pickerDoneButton))
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let items = [flexSpace, doneButton]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
    }
    
    @objc func pickerDoneButton(){
        
        delegate?.DismissVC(date: datePicker.date)

        self.dismiss(animated: true, completion: nil)
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
