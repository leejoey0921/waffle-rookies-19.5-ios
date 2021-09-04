//
//  ViewController.swift
//  seminar-0-assignment
//
//  Created by Joey Lee on 2021/09/04.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var stackview: UIStackView!
    
    @IBAction func login(_ sender: UIButton) {
        let identifier = "SecondViewController"
        guard let username = username.text else { return }
        guard let email = email.text else { return }
        guard let controller = storyboard?.instantiateViewController(identifier: identifier) as? SecondViewController else { return }
        guard username.count >= 3 else {
            let alert = UIAlertController(title: "Warning", message: "username은 세 글자 이상이어야 합니다", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .destructive, handler : nil)
            alert.addAction(defaultAction)
            present(alert, animated: false, completion: nil)
            return
        }
        controller.user = User(username:username, email:email)
        navigationController?.pushViewController(controller, animated: true)
        
    }
}

