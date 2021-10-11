//
//  ViewController.swift
//  assignment3
//
//  Created by Joey Lee on 2021/10/10.
//

import UIKit

class MainViewController: UIViewController {
    var pickerViewController: PickerViewController?
    var catViewController: CatViewController?
    
    @IBOutlet weak var seminarLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCatView()
        // Do any additional setup after loading the view.
        
    }
    
    private func addCatView() {
        catViewController = CatViewController(nibName: "CatViewController", bundle: nil)
        
        guard let catVC = catViewController else { return }
        
        self.view.addSubview(catVC.view)
        
        catVC.view.frame.origin.y = self.view.frame.height - 100
        
        let panGestureRc = UIPanGestureRecognizer(target: self, action: #selector(moveCatView(_:)))
        
        catVC.view.addGestureRecognizer(panGestureRc)
        
    }
    
    @objc private func moveCatView(_ recognizer: UIPanGestureRecognizer) {
        guard let catView = catViewController?.view else { return }
        
        let translation = recognizer.translation(in: catView)
        
        recognizer.setTranslation(CGPoint.zero, in: catView)
        
        if recognizer.state == .changed {
            if ((catView.frame.origin.y >= self.view.frame.height - catView.frame.height + 20 || (translation.y > 0)) && (catView.frame.origin.y > 50)) {
                catView.frame.origin.y += translation.y
            }
            
        }
        
        if recognizer.state == .ended {
            //translation y값 기준으로 animation 지정
            if catView.frame.origin.y > self.view.frame.height - 400 {
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: .curveEaseOut) {
                    catView.frame.origin.y = self.view.frame.height - 100
                }
            } else {
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: .curveEaseOut) {
                    catView.frame.origin.y = self.view.frame.height - catView.frame.height + 20
                }
            }
        }
    }
    
    
    @IBAction func presentPickerVC(_ sender: UIButton) {
        pickerViewController = PickerViewController(nibName: "PickerViewController", bundle: nil)
        pickerViewController?.modalTransitionStyle = .coverVertical
        self.pickerViewController?.delegate = self
        self.present(pickerViewController!, animated: true, completion: nil)
    }
}

extension MainViewController: PickerViewControllerDelegate {
    func seminarSelected(seminarIndex: Int) {
        self.seminarLabel.text = self.pickerViewController?.seminars[seminarIndex]
    }
    
}

