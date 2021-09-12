//
//  Task.swift
//  Assignment1
//
//  Created by Joey Lee on 2021/09/10.
//

import Foundation

struct Task: Codable {
    var taskName: String
    var completed: Bool = false
}

func saveTasks(_ tasks: [Task]) {
    let data = tasks.map { try? JSONEncoder().encode($0) }
    UserDefaults.standard.set(data, forKey: "tasks")
}

func loadTasks() -> [Task] {
    guard let encodedData = UserDefaults.standard.array(forKey: "tasks") as? [Data] else {
        return []
    }

    return encodedData.map { try! JSONDecoder().decode(Task.self, from: $0) }
}


func toggleCompleted(_ index: Int) {
    var tasks: [Task] = [Task]()
    tasks = loadTasks()
    tasks[index].completed.toggle()
    saveTasks(tasks)
}


