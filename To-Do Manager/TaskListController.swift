//
//  TaskListController.swift
//  To-Do Manager
//
//  Created by Дмитрий Гусев on 27.11.2022.
//

import UIKit

class TaskListController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // загрузка задач
        loadTasks()
        // кнопка активации режима редактирования
        navigationItem.leftBarButtonItem = editButtonItem
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if tasks[.important]?.count == 0 && tasks[.normal]?.count == 0{
        preLabel.text = "Задачи отсутствуют"
        } else {
            preLabel.text = ""
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // количество секций в таблице
        return tasks.count
    }
    // количество строк в определенной секции
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // определяем приоритет задач, соответствующий текущей секции
        let taskType = sectionTypesPosition[section]
        guard let currentTasksType = tasks[taskType] else {
            return 0
        }
        return currentTasksType.count
    }
    // ячейка для строки таблицы
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // ячейка на основе констрейнтов
//        return getConfiguredTaskCell_constraints(for: indexPath)
        // ячейка на основе стека
        return  getConfiguredTaskCell_stack(for: indexPath)
        
    }
    
    // ячейка на основе ограничений
    private func getConfiguredTaskCell_constraints(for indexPath: IndexPath) ->
    UITableViewCell {
        // загружаем прототип ячейки по идентификатору
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellConstrains", for: indexPath)
        // получаем данные о задаче, которую необходимо вывести в ячейке
        let taskType = sectionTypesPosition[indexPath.section]
        guard let currentTask = tasks[taskType]?[indexPath.row] else {
            return cell
        }
        // текстовая метка символа
        let symbolLabel = cell.viewWithTag(1) as? UILabel
        // текстовая метка названия задачи
        let textLabel = cell.viewWithTag(2) as? UILabel
        
        // изменяем символ в ячейке
        symbolLabel?.text = getSymbolForTask(with: currentTask.status)
        // изменяем текст в ячейке
        textLabel?.text = currentTask.title
        
        // изменяем цвет текста и символа
        if currentTask.status == .planned {
            textLabel?.textColor = .black
            symbolLabel?.textColor = .black
        } else {
            textLabel?.textColor = .lightGray
            symbolLabel?.textColor = .lightGray
        }
        
        return cell
    }
    
    // возвращаем символ для соответствующего типа задачи
    private func getSymbolForTask(with status: TaskStatus) -> String {
        var resultSymbol: String
        if status == .planned {
            resultSymbol = "\u{25CB}"
        } else if status == .completed {
            resultSymbol = "\u{25C9}"
        } else {
            resultSymbol = ""
        }
        return resultSymbol
    }
    
    // хранилище задач
    var tasksStorage: TasksStorageProtocol = TaskStorage()
    // коллекция задач
    var tasks: [TaskPriority:[TaskProtocol]] = [:] {
        didSet {
            for (tasksGroupPriority, tasksGroup) in tasks {
                tasks[tasksGroupPriority] = tasksGroup.sorted{ task1, task2 in
                    let task1position = tasksStatusPosition.firstIndex(of: task1.status) ?? 0
                    let task2position = tasksStatusPosition.firstIndex(of: task2.status) ?? 0
                    return task1position < task2position
                }
            }
            // сохранение задач
            var savigArray: [TaskProtocol] = []
            tasks.forEach { _, value in
                savigArray += value
            }
            tasksStorage.saveTasks(savigArray)
            
        }
    }
    
    // порядок отображения секций по типам
    // индекс в массиве соответствует индексу в секции в таблице
    var sectionTypesPosition: [TaskPriority] = [.important, .normal]
    
    private func loadTasks() {
        // подготовка коллекции с задачами
        // будем использовать только те задачи, для которых определена секция в таблице
        sectionTypesPosition.forEach { taskType in
            tasks[taskType] = []
        }
        // загрузка и разбор задач из хранилища
        tasksStorage.loadTasks().forEach { task in
            tasks[task.type]?.append(task)
        }
        // Сортировка старая, до 13 главы
//        for (tasksGroupPriority, tasksGroup) in tasks {
//            tasks[tasksGroupPriority] = tasksGroup.sorted { task1, task2 in
//                let task1position = tasksStatusPosition.firstIndex(of: task1.status)
//                ?? 0
//                let task2position = tasksStatusPosition.firstIndex(of: task2.status)
//                ?? 0
//                return task1position < task2position
//            }
//        }

        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String?
        let tasksType = sectionTypesPosition[section]
        if tasksType == .important {
            title = "Важные"
        } else if tasksType == .normal {
            title = "Текущие"
        }
        return title
    }
    // порядок отображения задач по их статусу
    var tasksStatusPosition: [TaskStatus] = [.planned, .completed]
    
    // MARK: - Отображение списка задач с использованием прототипа со стеком и кастомным классом
    
    // ячейка на основе стека
    private func getConfiguredTaskCell_stack(for indexPath: IndexPath) ->
    UITableViewCell {
        // загружаем прототип ячейки по идентификатору
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellStack", for: indexPath) as! TaskCell
        // получаем данные о задаче, которые необходимо вывести в ячейке
        let taskType = sectionTypesPosition[indexPath.section]
        guard let currentTask = tasks[taskType]?[indexPath.row] else {
            return cell
        }
        
        // изменяем текст в ячейке
        cell.title.text = currentTask.title
        // изменяем символ в ячейке
        cell.symbol.text = getSymbolForTask(with: currentTask.status)
        
        // изменяем цвет текста
        if currentTask.status == .planned {
            cell.title.textColor = .black
            cell.symbol.textColor = .black
        } else {
            cell.title.textColor = .lightGray
            cell.symbol.textColor = .lightGray
        }
        return cell
    }
    
    // MARK: - 13 глава
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 1. Проверяем существование задачи
        let taskType = sectionTypesPosition[indexPath.section]
        guard let _ = tasks[taskType]?[indexPath.row] else {
            return
        }
        
        // 2. Убеждаемся, что задача не является выполненной
        guard tasks[taskType]![indexPath.row].status == .planned else {
            // снимаем выделение со строки
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        // 3. Отмечаем задачу как выполненную
        tasks[taskType]![indexPath.row].status = .completed
        
        // 4. Перезагружаем секцию таблицы
        tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // получаем данные о задаче, по которой осуществлен свайп
        let taskType = sectionTypesPosition[indexPath.section]
        guard let _ = tasks[taskType]?[indexPath.row] else {
            return nil
        }
        // действие для изменения статуса на "запланирована"
        let actionSwipeInstance = UIContextualAction(style: .normal, title: "Не выполнена") { _,_,_ in
            self.tasks[taskType]![indexPath.row].status = .planned
            self.tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
        }
        // действие для перехода к экрану редактирования
        let actionEditInstance = UIContextualAction(style: .normal, title: "Изменить") { _,_,_ in
            // загрузка сцены со storyboard
            let editSceen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TaskEditController") as! TaskEditController
            // передача значений редактируемой задачи
            editSceen.taskText = self.tasks[taskType]![indexPath.row].title
            editSceen.taskType = self.tasks[taskType]![indexPath.row].type
            editSceen.taskStatus = self.tasks[taskType]![indexPath.row].status
            // передача обработчика для сохранения задачи
            editSceen.doAfterEdit = { [unowned self] title, type, status in
            let editedTask = Task(title: title, type: type, status: status)
                tasks[taskType]![indexPath.row] = editedTask
                tableView.reloadData()
            }
            // переход к экрану редактирования
            self.navigationController?.pushViewController(editSceen, animated: true)
        }
        // изменяем цвет фона кнопки с действием
        actionEditInstance.backgroundColor = .darkGray
        //создаем объект, описывающий доступные действия
        // в зависимости от статуса задачи отображено 1 или 2 действия
        let actionConfiguration: UISwipeActionsConfiguration
        if tasks[taskType]![indexPath.row].status == .completed {
            actionConfiguration = UISwipeActionsConfiguration(actions: [actionSwipeInstance, actionEditInstance])
        } else {
            actionConfiguration = UISwipeActionsConfiguration(actions: [actionEditInstance])
        }
        return actionConfiguration
        
//        // получаем даннные о задаче, которую необходимо перевести в статус "запланирована"
//        let taskType = sectionTypesPosition[indexPath.section]
//        guard let _ = tasks[taskType]?[indexPath.row] else {
//            return nil
//        }
//        // проверяем, что задача имеет статус "выполнено"
//        guard tasks[taskType]![indexPath.row].status == .completed else {
//            return nil
//        }
//        // создаем действие для изменения статуса
//        let actionSwipeInstance = UIContextualAction(style: .normal, title: "Не выполнена") { _, _, _ in
//            self.tasks[taskType]![indexPath.row].status = .planned
//            self.tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
//        }
//        // возвращаем натроенный объект
//        return UISwipeActionsConfiguration(actions: [actionSwipeInstance])
        
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let taskType = sectionTypesPosition[indexPath.section]
        // Удаляаем задачу
        tasks[taskType]?.remove(at: indexPath.row)
        // Удаляем строку, соответствующую задаче
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    // ручная сортировка списка задач
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // секция из которой происходит перемещение
        let taskTypeFrom = sectionTypesPosition[sourceIndexPath.section]
        // секция в которую происходит перемещение
        let taskTypeTo = sectionTypesPosition[destinationIndexPath.section]
        
        // безопасно извлекаем задачу, тем самым копируем ее
        guard let movedTask = tasks[taskTypeFrom]?[sourceIndexPath.row] else {
            return
        }
        // удаляем задачу с места, от куда она перенесена
        tasks[taskTypeFrom]!.remove(at: sourceIndexPath.row)
        // вставляем задачу на новую позицию
        tasks[taskTypeTo]!.insert(movedTask, at: destinationIndexPath.row)
        // если секция изменилась, изменяем тип задачи в соответствии с новой позицией
        if taskTypeFrom != taskTypeTo {
            tasks[taskTypeTo]![destinationIndexPath.row].type = taskTypeTo
        }
        
        // обновляем данные
        tableView.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCreateScreen" {
            let destination = segue.destination as! TaskEditController
            destination.doAfterEdit = { [unowned self] title, type, status in
                let newTask = Task(title: title, type: type, status: status)
                tasks[type]?.append(newTask)
                tableView.reloadData()
            }
        }
    }
    
    // получение списка задач, их разбор и установка в свойство tasks
    func setTasks(_ tasksCollection: [TaskProtocol]) {
        // подготовка коллекции с задачами
        // будем использовать только те задачи, для которых определена секция
        sectionTypesPosition.forEach {taskType in
            tasks[taskType] = []
        }
        // загрузка и разбор задач из хранилища
        tasksCollection.forEach { task in
            tasks[task.type]?.append(task)
        }
    }

    @IBOutlet var preLabel: UILabel!
}
