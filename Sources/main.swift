import Foundation

struct Task: Codable {
    let id: UUID
    var title: String
    var isCompleted: Bool
}

class TaskManager {
    private var tasks: [Task] = []
    private let fileURL = URL(fileURLWithPath: "tasks.json")

    init() {
        loadTasks()
    }

    func addTask(title: String) {
        let newTask = Task(id: UUID(), title: title, isCompleted: false)
        tasks.append(newTask)
        saveTasks()
        print("✅ Task added.")
    }

    func listTasks() {
        if tasks.isEmpty {
            print("No tasks available.")
        } else {
            for (index, task) in tasks.enumerated() {
                print("\(index + 1). \(task.title) [\(task.isCompleted ? "✔" : " ")]")
            }
        }
    }

    func completeTask(index: Int) {
        guard index >= 0 && index < tasks.count else {
            print("Invalid index.")
            return
        }
        tasks[index].isCompleted = true
        saveTasks()
        print("Task marked as complete.")
    }

    func deleteTask(index: Int) {
        guard index >= 0 && index < tasks.count else {
            print("Invalid index.")
            return
        }
        tasks.remove(at: index)
        saveTasks()
        print("🗑️ Task deleted.")
    }

    private func loadTasks() {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return }
        do {
            let data = try Data(contentsOf: fileURL)
            tasks = try JSONDecoder().decode([Task].self, from: data)
        } catch {
            print("⚠️ Failed to load tasks: \(error)")
        }
    }

    private func saveTasks() {
        do {
            let data = try JSONEncoder().encode(tasks)
            try data.write(to: fileURL)
        } catch {
            print("⚠️ Failed to save tasks: \(error)")
        }
    }
}

// MARK: - CLI Interface

let manager = TaskManager()

func showMenu() {
    print("""
    \n Task Manager
    1. Add Task
    2. List Tasks
    3. Complete Task
    4. Delete Task
    5. Exit
    """)
}

while true {
    showMenu()
    print("Enter choice:", terminator: " ")
    guard let input = readLine(), let choice = Int(input) else {
        print("Invalid input.")
        continue
    }

    switch choice {
    case 1:
        print("Enter task title:", terminator: " ")
        if let title = readLine() {
            manager.addTask(title: title)
        }
    case 2:
        manager.listTasks()
    case 3:
        manager.listTasks()
        print("Enter task number to complete:", terminator: " ")
        if let input = readLine(), let index = Int(input) {
            manager.completeTask(index: index - 1)
        }
    case 4:
        manager.listTasks()
        print("Enter task number to delete:", terminator: " ")
        if let input = readLine(), let index = Int(input) {
            manager.deleteTask(index: index - 1)
        }
    case 5:
        print("Goodbye!")
        exit(0)
    default:
        print("Invalid choice.")
    }
}
