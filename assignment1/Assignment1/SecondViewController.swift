//
//  SecondViewController.swift
//  Assignment1
//
//  Created by Joey Lee on 2021/09/10.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBOutlet weak var textfield: UITextField!
    
    @IBAction func addTask(_ sender: UIButton) {
        guard let taskname = textfield.text else { return }
        guard taskname.count >= 1 else {
            let alert = UIAlertController(title: "Warning", message: "You must enter a name for your task", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .destructive, handler : nil)
            alert.addAction(defaultAction)
            present(alert, animated: false, completion: nil)
            return
        }
        

        let newTask = Task(taskName: taskname)

        var tempTasks: [Task] = [Task]()
        
        tempTasks = loadTasks()
        tempTasks.append(newTask)
        UserDefaults.standard.removeObject(forKey: "tasks")
        saveTasks(tempTasks)
        guard let controller = storyboard?.instantiateViewController(identifier: "mainViewController") as? ViewController else { return }
        navigationController?.pushViewController(controller, animated: true)
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
