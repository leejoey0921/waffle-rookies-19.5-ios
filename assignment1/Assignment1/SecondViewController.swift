//
//  SecondViewController.swift
//  Assignment1
//
//  Created by Joey Lee on 2021/09/10.
//

import UIKit

class SecondViewController: UIViewController {
    var editRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textfield.delegate = self
        
        if editRow == nil {
            // navigated from moveToAdd
            addOrEditButton.setTitle("Add Item", for: .normal)
        } else {
            // navigated from moveToEdit
            addOrEditButton.setTitle("Rename", for: .normal)
        }
    }

    
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var addOrEditButton: UIButton!
    
    
    @IBAction func addOrEdit(_ sender: UIButton) {
        guard let taskName = textfield.text else { return }
        guard taskName.count >= 1 else {
            let alert = UIAlertController(title: "Warning", message: "You must enter a name for your task", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .destructive, handler : nil)
            alert.addAction(defaultAction)
            present(alert, animated: false, completion: nil)
            return
        }
        if editRow == nil {
            // add task
            addTask(taskName: taskName)
        } else {
            // edit task
            let atRow: Int! = editRow
            editTask(taskName: taskName, atRow: atRow)
        }
        navigationController?.popViewController(animated: true)
    }
    
    // add task with name 'taskName'
    func addTask(taskName: String) {
        let newTask = Task(taskName: taskName)

        var tempTasks: [Task] = [Task]()
        
        tempTasks = loadTasks()
        tempTasks.append(newTask)
        UserDefaults.standard.removeObject(forKey: "tasks")
        saveTasks(tempTasks)

    }
    // change name to 'taskName' at row 'atRow'
    func editTask(taskName: String, atRow: Int) {
        let newTask = Task(taskName: taskName)

        var tempTasks: [Task] = [Task]()
        
        tempTasks = loadTasks()
        tempTasks[atRow] = newTask
        UserDefaults.standard.removeObject(forKey: "tasks")
        saveTasks(tempTasks)
    }

}

extension SecondViewController: UITextFieldDelegate {
    // press return key to push keyboard down
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
