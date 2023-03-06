//
//  TaskEditController.swift
//  To-Do Manager
//
//  Created by Дмитрий Гусев on 29.11.2022.
//

import UIKit

class TaskEditController: UITableViewController {
    
    var taskText: String = ""
    var taskType: TaskPriority = .normal
    var taskStatus: TaskStatus = .planned

    override func viewDidLoad() {
        super.viewDidLoad()
        taskTitle?.text = taskText
        // обновление метки в соответствии с текущим типом
        taskTypeLabel?.text = taskTitles[taskType]
        // обновляем статус задачи
        if taskStatus == .completed {
            taskStatusSwitch.isOn = true
        }

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    var doAfterEdit: ((String, TaskPriority, TaskStatus) -> Void)?
    
    @IBOutlet var taskTitle: UITextField!
    @IBOutlet var taskTypeLabel: UILabel!
    
    // Названия типов задач
    private var taskTitles: [TaskPriority: String] = [
        .important: "Важная",
        .normal: "Текущая"
    ]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTaskTypeScreen" {
            //ссылка на контроллер значения
            let destination = segue.destination as! TaskTypeController
            // передача выбранного типа
            destination.selectedType = taskType
            // передача обработчика типа
            destination.doAfterTypeSelected = { [unowned self] selectedType in
                taskType = selectedType
                // обновляем метку с текущим типом
                taskTypeLabel?.text = taskTitles[taskType]
            }
        }
    }
    
    @IBOutlet var taskStatusSwitch: UISwitch!
    
    @IBAction func saveTask(_ sender: UIBarButtonItem) {
    // получаем актуальные значения
        var title = taskTitle?.text ?? ""
        let type = taskType
        let status: TaskStatus = taskStatusSwitch.isOn ? .completed : .planned
        // ЗАДАНИЕ - проверка на пробелы
       
        while title.first == " " {
            title.removeFirst()
        }
        while title.last == " " {
            title.removeLast()
        }
        
        if title == "" {
            let alert = UIAlertAction(title: "OK", style: .default)
            let alert2 = UIAlertController(title: "Ошибка", message: "Введите верные данные", preferredStyle: .alert)
            alert2.addAction(alert)
            present(alert2, animated: true)
        }
        
        
        // вызываем обработчик
        doAfterEdit?(title, type, status)
        // возвращаемся к предыдущему экрану
        navigationController?.popViewController(animated: true)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
