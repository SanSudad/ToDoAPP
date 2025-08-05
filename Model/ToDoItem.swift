import SwiftData
import Foundation

@Model
class TodoItem {
  var id: String
  var title: String
  var taskDescription: String
  var priority: String
  var isCompleted: Bool
  var dueDate: Date
  var isToday: Bool
  var isTomorrow: Bool

  init(
    title: String,
    taskDescription: String = "",
    priority: String = "Medium", 
    dueDate: Date,
    isToday: Bool = false,
    isTomorrow: Bool = false
  ) {
    self.id = UUID().uuidString
    self.title = title
    self.taskDescription = taskDescription
    self.priority = priority
    self.isCompleted = false
    self.dueDate = dueDate
    self.isToday = isToday
    self.isTomorrow = isTomorrow
  }
}
