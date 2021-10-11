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
    var savedSeminarIndex: Int? // 고른 세미나의 Index 저장하기
    let catViewMinHeight: CGFloat = 150 // catView 최대로 내렸을 때 높이
    
    @IBOutlet weak var seminarLabel: UILabel! // 세미나 이름 표시
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCatView()
    }
    
    private func addCatView() {
        catViewController = CatViewController(nibName: "CatViewController", bundle: nil)
        
        guard let catVC = catViewController else { return }
        
        self.view.addSubview(catVC.view)
                
        // set CatView dimensions
        catVC.view.frame.origin.y = self.view.frame.height - self.catViewMinHeight
        catVC.view.frame.size.width = self.view.frame.width
        if catVC.view.frame.height > self.view.frame.height {
            catVC.view.frame.size.height = self.view.frame.height
        }
        
        let panGestureRc = UIPanGestureRecognizer(target: self, action: #selector(moveCatView(_:)))
        catVC.view.addGestureRecognizer(panGestureRc)
        
    }
    
    // CatView pan 구현
    @objc private func moveCatView(_ recognizer: UIPanGestureRecognizer) {
        guard let catView = catViewController?.view else { return }
        
        let translation = recognizer.translation(in: catView)
        
        recognizer.setTranslation(CGPoint.zero, in: catView)
        
        let selfHeight: CGFloat = self.view.frame.height
        
        let catViewMinY = calcNavigationBarLowerY() // Navigation Bar 아래까지만 올라오게 설정
        let catViewMaxY = selfHeight - catViewMinHeight // catViewMinHeight만큼만 남도록 내려가게 설정
        
        let tooHigh: Bool = catView.frame.origin.y < catViewMinY
        let tooLow: Bool = catView.frame.origin.y > catViewMaxY
        
        
        // when CatView dragged
        if recognizer.state == .changed {
            if ((translation.y > 0 && !tooLow) || (translation.y < 0 && !tooHigh)) {
                catView.frame.origin.y += translation.y
            }
        }
        
        // when CatView released
        if recognizer.state == .ended {
            if catView.frame.origin.y > selfHeight/2 { // MainViewController 절반보다 아래
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: .curveEaseOut) {
                    catView.frame.origin.y = catViewMaxY
                }
            } else { // MainViewController 절반보다 위
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: .curveEaseOut) {
                    catView.frame.origin.y = catViewMinY
                }
            }
        }
    }
    
    // PickerView present하기
    @IBAction func presentPickerVC(_ sender: UIButton) {
        pickerViewController = PickerViewController(nibName: "PickerViewController", bundle: nil)
        
        pickerViewController?.modalTransitionStyle = .coverVertical
        
        self.pickerViewController?.delegate = self
        self.pickerViewController?.selectedSeminarIndex = self.savedSeminarIndex // 골랐던 seminar의 index 전달
        
        self.present(pickerViewController!, animated: true, completion: nil)
    }
    
    // NavigationBar 아래의 y값 계산
    private func calcNavigationBarLowerY() -> CGFloat {
        let statHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let nbHeight = self.navigationController?.navigationBar.frame.size.height ?? 0
        return (self.view.bounds.origin.y + statHeight + nbHeight)
    }
    
}

// PickerView에서 선택한 세미나 이름 표시, index 저장
extension MainViewController: PickerViewControllerDelegate {
    func seminarSelected(seminarIndex: Int) {
        self.seminarLabel.text = self.pickerViewController?.seminars[seminarIndex]
        self.savedSeminarIndex = seminarIndex
    }
    
}

