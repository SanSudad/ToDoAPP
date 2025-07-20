import SwiftData
import Foundation

@Model
class TodoItem {
    var id: UUID
    var title: String
    var isCompleted: Bool
    var dueDate: Date
    var isToday: Bool
    var isTomorrow: Bool
    
    init(title: String, dueDate: Date, isToday: Bool = false, isTomorrow: Bool = false) {
        self.id = UUID()
        self.title = title
        self.isCompleted = false
        self.dueDate = dueDate
        self.isToday = isToday
        self.isTomorrow = isTomorrow
    }
}

//import SwiftData
//import Foundation
//
//@Model
//class TodoItem{
//    
//    var id : UUID
//    var title : String
//    var isCompleted : Bool
//    var isToday : Bool
//    var isdueDate : Date
//    var isTomorrow : Bool
//    init(id: UUID, title: String, isCompleted: Bool, isToday: Bool, isdueDate: Date, isTomorrow: Bool) {
//        self.id = UUID()
//        self.title = title
//        self.isCompleted = false
//        self.isToday = isToday
//        self.isdueDate = isdueDate
//        self.isTomorrow = isTomorrow
//    }
//    
//    
//}
