//
//  SecondViewController.swift
//  seminar-0-assignment
//
//  Created by Joey Lee on 2021/09/04.
//

import UIKit

class SecondViewController: UIViewController {
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        username.text = user?.username
        email.text = user?.email
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    
    
    /*
     
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
