//
//  PickerViewController.swift
//  assignment3
//
//  Created by Joey Lee on 2021/10/11.
//

import UIKit

class PickerViewController: UIViewController{
    let seminars = ["Android", "iOS", "React", "Django", "Springboot"]
    
    var selectedSeminarIndex: Int?
    
    var delegate: PickerViewControllerDelegate?
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        // Do any additional setup after loading the view.
    }

    @IBAction func selectSeminar(_ sender: UIButton) {
        guard let delegate = delegate else { return }
        let index = selectedSeminarIndex ?? 0
        
        delegate.seminarSelected(seminarIndex: index)
        
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

extension PickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.seminars.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.seminars[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSeminarIndex = row
    }
    
}

protocol PickerViewControllerDelegate {
    
    func seminarSelected(seminarIndex: Int)
    
}
