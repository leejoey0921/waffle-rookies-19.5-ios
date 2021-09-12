//
//  ViewController.swift
//  Assignment1
//
//  Created by Joey Lee on 2021/09/10.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var tasks: [Task] = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasks = loadTasks()
        saveTasks(tasks)
        self.tableView.allowsSelectionDuringEditing = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    // '+' button: push to SecondViewController to add new Task
    @IBAction func moveToAdd(_ sender: UIButton) {
        guard let controller = storyboard?.instantiateViewController(identifier: "secondViewController") as? SecondViewController else { return }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // push to SecondViewController to edit Task
    func moveToEdit(atRow: Int) {
        guard let controller = storyboard?.instantiateViewController(identifier: "secondViewController") as? SecondViewController else { return }
        controller.editRow = atRow
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    // edit' button action to toggle edit mode
    @IBAction func edit(_ sender: UIButton) {
        if self.tableView.isEditing {
            self.tableView.setEditing(false, animated: true)
            self.editButton.setTitle("Edit", for: .normal)
        } else {
            self.tableView.setEditing(true, animated: true)
            self.editButton.setTitle("Done", for: .normal)
        }
    }
    
    
    // edit button outlet
    @IBOutlet weak var editButton: UIButton!
    
    
}

extension ViewController: UITableViewDelegate {
    // move to SecondViewController to edit selected row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.tableView.isEditing {
            moveToEdit(atRow: indexPath.row)
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks = loadTasks()
        return tasks.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let labelData = tasks[index].taskName
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as? TaskCell else {
            return UITableViewCell()
        }
        
        // set cell properties
        cell.index = index
        cell.label.text = labelData
        
        // set label color
        if tasks[index].completed {
            cell.label.textColor = .gray
        } else {
            cell.label.textColor = .black
        }
        
        return cell
    }
    
    // implement swipe to delete
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let index = indexPath.row
            tasks.remove(at: index)
            saveTasks(tasks)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.none)
            tableView.reloadData()

        }
    }
}


// cell class
class TaskCell: UITableViewCell {
    var index: Int = 0
    
    
    @IBOutlet weak var label: UILabel!
    
    @IBAction func taskCompleted(_ sender: UIButton) {
        toggleCompleted(index) // edit UserDefaults data
        toggleLabelColor() // toggle label color
    }
    
    
    // toggle label color
    func toggleLabelColor() {
        if label.textColor == .gray {
            label.textColor = .black
        } else {
            label.textColor = .gray
        }
    }
}


