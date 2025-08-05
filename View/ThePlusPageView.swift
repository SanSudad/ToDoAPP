import SwiftUI
import SwiftData

struct ThePlusPageView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss

  @State var todoToEdit: TodoItem?

  @State private var refreshTrigger = false
  @State private var taskName: String = ""
  @State private var taskDescription: String = ""
  @State private var taskDate = Date()
  @State private var taskTime = Date()
  @State private var selectedPriority: String = "High"
  @State private var getAlerts: Bool = true

  let priorities = ["High", "Medium", "Low"]
  let descriptionCharLimit = 250

  @State private var isShowingTimePicker = false

  private var timeFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "h:mm a"
    return formatter
  }

  var body: some View {
    ZStack {
      Color.black.ignoresSafeArea()

      VStack(spacing: 0) {
        ScrollView {
          VStack(alignment: .leading, spacing: 24) {
            WeeklyCalendarView(selectedDate: $taskDate)
            scheduleSection
            timeSection
            prioritySection
            alertSection
          }
        }
        createOrUpdateButton
      }
    }
    .foregroundColor(.white)
    .navigationTitle(
      todoToEdit == nil ? "Create new task" : "Edit task"
    )
    .navigationBarTitleDisplayMode(.inline)
    .onAppear(perform: setupViewForEditing)
    .sheet(isPresented: $isShowingTimePicker) {
      TimePickerCardView(selection: $taskTime)
        .presentationDetents([.height(400)])
    }
  }

  

  private var scheduleSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Schedule")
        .font(.headline)
        .foregroundColor(.white)

      TextField("Name", text: $taskName)
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)

      ZStack(alignment: .topLeading) {
        TextEditor(text: $taskDescription)
          .scrollContentBackground(.hidden)
          .padding(12)
          .onChange(of: taskDescription) { newValue in
            if newValue.count > descriptionCharLimit {
              taskDescription = String(
                newValue.prefix(descriptionCharLimit)
              )
            }
          }

        if taskDescription.isEmpty {
          Text("Description")
            .foregroundColor(.gray.opacity(0.6))
            .padding()
            .allowsHitTesting(false)
        }
      }
      .frame(height: 120)
      .background(Color.gray.opacity(0.2))
      .cornerRadius(12)
    }
    .padding(.horizontal)
  }

  private var timeSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Time")
        .font(.headline)
        .foregroundColor(.white)

      Button(action: {
        isShowingTimePicker = true
      }) {
        HStack {
          Image(systemName: "clock")
            .foregroundColor(.purple)
          Text(timeFormatter.string(from: taskTime))
          Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
      }
      .tint(.white)
    }
    .padding(.horizontal)
  }

  private var prioritySection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Priority")
        .font(.headline)
        .foregroundColor(.white)

      HStack(spacing: 12) {
        ForEach(priorities, id: \.self) { priority in
          Button(action: {
//            selectedPriority = priority
              withAnimation {
                      selectedPriority = priority
                  refreshTrigger.toggle()
                  }
          }) {
            Text(priority)
              .fontWeight(.semibold)
              .frame(maxWidth: .infinity)
              .padding(.vertical, 12)
              .foregroundColor(
                selectedPriority == priority
                  ? .black : priorityColorFor(priority)
              )
              .background(
                selectedPriority == priority
                  ? priorityColorFor(priority) : Color.clear
              )
              .cornerRadius(10)
              .overlay(
                RoundedRectangle(cornerRadius: 10)
                  .stroke(priorityColorFor(priority), lineWidth: 1.5)
              )
          }
        }
      }
    }
    .padding(.horizontal)
  }

  private var alertSection: some View {
    HStack {
      Text("Get alert for this task")
        .font(.headline)
      Spacer()
      Toggle("", isOn: $getAlerts)
        .labelsHidden()
        .tint(.purple)
    }
    .padding(.horizontal)
  }

  private var createOrUpdateButton: some View {
      Button(action:
          saveOrUpdateTask
          
      ) {
      Text(todoToEdit == nil ? "Create Task" : "Update Task")
        .font(.headline)
        .fontWeight(.semibold)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .padding()
        .background(
          LinearGradient(
            colors: [
              Color.purple.opacity(0.8), Color.purple.opacity(0.6),
            ],
            startPoint: .leading,
            endPoint: .trailing
          )
        )
        .cornerRadius(12)
    }
    .padding()
  }

  

  private func setupViewForEditing() {
    
    if let todo = todoToEdit {
      taskName = todo.title
      taskDescription = todo.taskDescription
      taskDate = todo.dueDate
      taskTime = todo.dueDate
      selectedPriority = todo.priority
    }
  }

  private func saveOrUpdateTask() {
    
    let calendar = Calendar.current
    let hour = calendar.component(.hour, from: taskTime)
    let minute = calendar.component(.minute, from: taskTime)
    let finalDueDate = calendar.date(
      bySettingHour: hour,
      minute: minute,
      second: 0,
      of: taskDate
    )!
      playSound(sound: "Sound-ding", type: "mp3")
      
    let isToday = calendar.isDateInToday(finalDueDate)
    let isTomorrow = calendar.isDateInTomorrow(finalDueDate)

    if let todo = todoToEdit {
      
      todo.title = taskName
      todo.taskDescription = taskDescription
      todo.dueDate = finalDueDate
      todo.priority = selectedPriority
      todo.isToday = isToday
      todo.isTomorrow = isTomorrow
    } else {
      
      let newTodo = TodoItem(
        title: taskName,
        taskDescription: taskDescription,
        priority: selectedPriority,
        dueDate: finalDueDate,
        isToday: isToday,
        isTomorrow: isTomorrow
      )
        print(newTodo.id)
      modelContext.insert(newTodo)
    }
    
    
    do {
        try modelContext.save()
    } catch {
        print("Failed to save task: \(error.localizedDescription)")
    }
    

    dismiss()
  }


    
    private func priorityColorFor(_ priority: String) -> Color {
        switch priority {
        case "High":
            print("Returning color for High: piaziii")
            return Color(.piaziii)
        case "Medium":
            print("Returning color for Medium: flatWhite2")
            return Color(.flatWhite2)
        case "Low":
            print("Returning color for Low: pink2")
            return Color(.pink2)
        default:
            print("Returning default color: gray")
            return .gray
        }
    }

  
  struct WeeklyCalendarView: View {
    @Binding var selectedDate: Date
    @State private var displayDate: Date = Date()

    var body: some View {
      VStack(spacing: 20) {
        headerView
        daysView
      }
      .padding()
      .onAppear {
        self.displayDate = selectedDate
      }
    }

    private var headerView: some View {
      HStack {
        Button(action: { changeWeek(by: -1) }) {
          Image(systemName: "chevron.left").font(.title3)
        }
        Spacer()
        Text(weekDateRange(for: displayDate))
          .font(.headline).fontWeight(.semibold)
        Spacer()
        Button(action: { changeWeek(by: 1) }) {
          Image(systemName: "chevron.right").font(.title3)
        }
      }
      .foregroundColor(Color.purple)
    }

    private var daysView: some View {
      HStack {
        ForEach(fetchWeekDays(for: displayDate), id: \.self) { day in
          DayView(date: day, isSelected: isSameDay(day, selectedDate))
            .onTapGesture { selectedDate = day }
        }
      }
    }

    private func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
      return Calendar.current.isDate(date1, inSameDayAs: date2)
    }

    private func changeWeek(by weeks: Int) {
      if let newDate = Calendar.current.date(
        byAdding: .weekOfYear,
        value: weeks,
        to: displayDate
      ) {
        displayDate = newDate
      }
    }

    private func weekDateRange(for date: Date) -> String {
      guard let weekInterval = Calendar.current.dateInterval(
        of: .weekOfYear,
        for: date
      ) else { return "" }
      let startDate = weekInterval.start
      let endDate = Calendar.current.date(
        byAdding: .day,
        value: 6,
        to: startDate
      )!
      let formatter = DateFormatter()
      formatter.dateFormat = "dd MMM"
      return "\(formatter.string(from: startDate)) - \(formatter.string(from: endDate))"
    }

    private func fetchWeekDays(for date: Date) -> [Date] {
      guard let weekInterval = Calendar.current.dateInterval(
        of: .weekOfYear,
        for: date
      ) else { return [] }
      var weekDays: [Date] = []
      for i in 0..<7 {
        if let day = Calendar.current.date(
          byAdding: .day,
          value: i,
          to: weekInterval.start
        ) {
          weekDays.append(day)
        }
      }
      return weekDays
    }
  }

  fileprivate struct DayView: View {
    let date: Date
    let isSelected: Bool

    var body: some View {
      VStack(spacing: 8) {
        Text(dayName(from: date)).font(.subheadline).fontWeight(.medium)
        Text(dayNumber(from: date)).font(.headline).fontWeight(.bold)
      }
      .foregroundColor(isSelected ? .white : .gray)
      .padding(.vertical, 10)
      .frame(maxWidth: .infinity)
      .background(
        ZStack {
          if isSelected {
            RoundedRectangle(cornerRadius: 12)
              .stroke(Color.purple, lineWidth: 2)
//              .overlay(
//                Circle()
//                  .fill(Color.purple)
//                  .frame(width: 6, height: 6)
//                  .offset(y: 26)
//              )
          }
        }
      )
    }

    private func dayName(from date: Date) -> String {
      let formatter = DateFormatter()
      formatter.dateFormat = "E"
      return formatter.string(from: date)
    }

    private func dayNumber(from date: Date) -> String {
      let formatter = DateFormatter()
      formatter.dateFormat = "dd"
      return formatter.string(from: date)
    }
  }
}

struct TimePickerCardView: View {
    @Binding var selection: Date
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedHour: Int
    @State private var selectedMinute: Int
    
    init(selection: Binding<Date>) {
        _selection = selection
        let calendar = Calendar.current
        _selectedHour = State(
            initialValue: calendar.component(.hour, from: selection.wrappedValue)
        )
        _selectedMinute = State(
            initialValue: calendar.component(.minute, from: selection.wrappedValue)
        )
    }
    
    var body: some View {
        ZStack {
            Color(white: 0.1).ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Time")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(white: 0.15))
                
                HStack(spacing: 0) {
                    Image(systemName: "clock")
                        .font(.largeTitle)
                        .foregroundColor(.purple)
                        .padding(.horizontal, 30)
                    
                    HStack(spacing: 0) {
                        Picker("Hour", selection: $selectedHour) {
                            ForEach(0..<24) { hour in
                                Text(String(format: "%02d", hour)).tag(hour)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 70)
                        .clipped()
                        
                        Text(":")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Picker("Minute", selection: $selectedMinute) {
                            ForEach(0..<60) { minute in
                                Text(String(format: "%02d", minute)).tag(minute)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 70)
                        .clipped()
                    }
                }
                .padding(.vertical, 20)
                
                Spacer()
                
                Button(action: DoneAction) {
                    Text("Done")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(12)
                        .padding()
                }
                .foregroundColor(.white)
            }
        }
    }
    private func DoneAction() {
        let calendar = Calendar.current
        let newDate = calendar.date(
          bySettingHour: selectedHour,
          minute: selectedMinute,
          second: 0,
          of: selection
        )!
        selection = newDate
          dismiss(
            
          )
    }

}


