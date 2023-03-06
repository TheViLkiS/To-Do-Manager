//
//  Task.swift
//  To-Do Manager
//
//  Created by Дмитрий Гусев on 27.11.2022.
//

import Foundation


enum TaskPriority {
    // текущая
    case normal
    // важная
    case important
}

enum TaskStatus: Int {
    //запланированная
    case planned
    // завершенная
    case completed
}

// требования к типу, описывающему сущность "задача"
protocol TaskProtocol {
    // название
    var title: String { get set}
    // тип
    var type: TaskPriority {get set}
    //статус
    var status: TaskStatus {get set}
}

//сущность "задача"
struct Task: TaskProtocol {
    var title: String
    var type: TaskPriority
    var status: TaskStatus
}

