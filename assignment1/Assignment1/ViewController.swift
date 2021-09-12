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
        
        // Do any additional setup after loading the view.
        tasks = loadTasks()
        saveTasks(tasks)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()

    }
    
    // '+' button: move to second view controller
    @IBAction func move(_ sender: UIButton) {
        guard let controller = storyboard?.instantiateViewController(identifier: "secondViewController") as? SecondViewController else { return }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
}

extension ViewController: UITableViewDelegate {
        
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let labelData = tasks[index].taskName
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "exampleCell") as? ExampleCell else {
            return UITableViewCell()
        }
        
        cell.index = index
        cell.label.text = labelData
        
        if tasks[index].completed {
            cell.label.textColor = .gray
        } else {
            cell.label.textColor = .black
        }
        
        return cell
    }
    
    // swipe to delete implementation
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
class ExampleCell: UITableViewCell {
        
    var index: Int = 0
    
    @IBOutlet weak var label: UILabel!
    
    @IBAction func taskCompleted(_ sender: UIButton) {
        toggleCompleted(index)
        toggleLabelColor()
    }
    
    func toggleLabelColor() {
        if label.textColor == .gray {
            label.textColor = .black
        } else {
            label.textColor = .gray
        }
    }
}


