

import SwiftUI
import SwiftData

struct HomeView: View {
 
  @Binding var isUserLoggedIn: Bool

  @Environment(\.modelContext) private var modelContext
  @Query(sort: \TodoItem.dueDate) private var allTodos: [TodoItem]
  @State private var searchText = ""

  @State private var todoToEdit: TodoItem?
  @State private var isEditLinkActive = false

  private var filteredTodos: [TodoItem] {
    if searchText.isEmpty {
      return allTodos
    } else {
      return allTodos.filter {
        $0.title.localizedCaseInsensitiveContains(searchText)
      }
    }
  }

  private var todayTodos: [TodoItem] {
    filteredTodos.filter { $0.isToday && !$0.isCompleted }
  }

  private var tomorrowTodos: [TodoItem] {
    filteredTodos.filter { $0.isTomorrow && !$0.isCompleted }
  }

  private var upcomingTodos: [TodoItem] {
    filteredTodos.filter { !$0.isToday && !$0.isTomorrow && !$0.isCompleted }
  }

  private var completedTodos: [TodoItem] {
    filteredTodos.filter { $0.isCompleted }
  }

  var completedTodayCount: Int {
    allTodos.filter { $0.isToday && $0.isCompleted }.count
  }

  var totalTodayCount: Int {
    allTodos.filter { $0.isToday }.count
  }

  var completionPercentage: Double {
    guard totalTodayCount > 0 else { return 0 }
    return Double(completedTodayCount) / Double(totalTodayCount)
  }

  var body: some View {
    NavigationStack {
      ZStack {
        Color.black.ignoresSafeArea()

        VStack(spacing: 0) {
          headerSection
            .padding(.horizontal, 20)

          searchSection
            .padding(.horizontal, 20)

          if allTodos.isEmpty {
            emptyStateView
          } else {
            todoListView
          }
        }

        plusButton

        backgroundNavigationLinks
      }
      .navigationBarHidden(true)
      .accentColor(.purple)
      .preferredColorScheme(.dark)
    }
    .tint(.purple2)
  }

  private var headerSection: some View {
    HStack {
      VStack(alignment: .leading, spacing: 4) {
        Text("Let's complete your goals")
          .font(.title2)
          .fontWeight(.semibold)
        HStack {
          Text("today!")
            .font(.title2)
            .fontWeight(.semibold)
          Text("✏️")
            .font(.title2)
        }
      }
      Spacer()

      
      Button(action: {
       
        isUserLoggedIn = false
      }) {
        Circle()
          .fill(Color.gray.opacity(0.3))
          .frame(width: 44, height: 44)
          .overlay(
            Image(systemName: "person.fill")
              .foregroundColor(.white)
          )
      }
    }
    .padding(.top, 10)
    .foregroundColor(.white)
  }

  private var searchSection: some View {
    HStack {
      Image(systemName: "magnifyingglass")
        .foregroundColor(.gray)
      TextField("Search Task Here", text: $searchText)
        .foregroundColor(.white)
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 12)
    .background(Color.gray.opacity(0.2))
    .cornerRadius(12)
    .padding(.top, 16)
  }

  private var todoListView: some View {
    List {
      if totalTodayCount > 0 {
        progressSection
          .listRowInsets(EdgeInsets())
          .listRowSeparator(.hidden)
          .listRowBackground(Color.black)
      }

      if !todayTodos.isEmpty {
        todayTasksSection
      }

      if !tomorrowTodos.isEmpty {
        tomorrowTasksSection
      }

      if !upcomingTodos.isEmpty {
        upcomingTasksSection
      }

      if !completedTodos.isEmpty {
        completedTasksSection
      }

      Color.clear
        .frame(height: 100)
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
        .listRowBackground(Color.black)
    }
    .listStyle(.plain)
    .padding(.horizontal, 20)
    .background(Color.black)
    .padding(.top)
  }

  private var emptyStateView: some View {
    VStack(spacing: 20) {
      Spacer()
      Image("emptyStateIllustration")
        .resizable()
        .scaledToFit()
        .frame(width: 250)
      Text("What do you want to do today?")
        .font(.title2)
        .fontWeight(.bold)
        .foregroundColor(.white)
      Text("Tap + to add your tasks")
        .font(.headline)
        .fontWeight(.regular)
        .foregroundColor(.gray)
      Spacer()
      Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }

  private var plusButton: some View {
    VStack {
      Spacer()
      HStack {
        Spacer()

        NavigationLink(destination: ThePlusPageView()) {
          Image(systemName: "plus")
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(width: 56, height: 56)
//            .background(Color.pink2.opacity(0.8))
            .background(
              LinearGradient(
                colors: [Color.purple3, Color.purple2],
                startPoint: .leading,
                endPoint: .trailing
              )
            )

            .clipShape(Circle())
            .shadow(radius: 4)
        }
        .padding(.trailing, 20)
        .padding(.bottom, 30)
      }
    }
  }

  @ViewBuilder
  private var backgroundNavigationLinks: some View {
    if let todo = todoToEdit {
      NavigationLink(
        destination: ThePlusPageView(todoToEdit: todo),
        isActive: $isEditLinkActive
      ) {
        EmptyView()
      }
    }
  }

  private var progressSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Progress")
        .font(.title3)
        .fontWeight(.semibold)
        .foregroundColor(.white)

      VStack(alignment: .leading, spacing: 12) {
        Text("Daily Task")
          .font(.headline)
          .foregroundColor(.white)
        Text("\(completedTodayCount)/\(totalTodayCount) Task Completed")
          .font(.subheadline)
          .foregroundColor(.gray)
        Text("You are almost done go ahead")
          .font(.caption)
          .foregroundColor(.gray)
        HStack {
          GeometryReader { geometry in
            ZStack(alignment: .leading) {
              Rectangle()
                .fill(Color.purple.opacity(0.4))
                .frame(height: 8)
                .cornerRadius(4)
              Rectangle()
                .fill(
                  LinearGradient(
                    gradient: Gradient(colors: [
                      .purple, .purple.opacity(0.7),
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                  )
                )
                .frame(
                  width: geometry.size.width * completionPercentage,
                  height: 8
                )
                .cornerRadius(4)
            }
          }
          .frame(height: 8)
          Text("\(Int(completionPercentage * 100))%")
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.leading, 8)
        }
      }
      .padding(16)
      .background(Color.gray.opacity(0.1))
      .cornerRadius(16)
    }
    .padding(.bottom)
  }

  private func taskSection(
    title: String,
    todos: [TodoItem]
  ) -> some View {
    Section(
      header: Text(title)
        .font(.title3)
        .fontWeight(.semibold)
        .foregroundColor(.white)
        .padding(.top, 12)
    ) {
      ForEach(todos) { todo in
        TaskRowView(todo: todo)
          .padding(.bottom, 12)
          .swipeActions(allowsFullSwipe: false) {
            Button(role: .destructive) {
              deleteTodo(todo)
            } label: {
              Label("Delete", systemImage: "xmark")
            }

            Button {
              self.todoToEdit = todo
              self.isEditLinkActive = true
            } label: {
              Label("Edit", systemImage: "pencil")
            }
            .tint(.blue)
          }
      }
    }
    .listRowInsets(EdgeInsets())
    .listRowSeparator(.hidden)
    .listRowBackground(Color.black)
  }

  private var todayTasksSection: some View {
    taskSection(title: "Today's Task", todos: todayTodos)
  }

  private var tomorrowTasksSection: some View {
    taskSection(title: "Tomorrow's Task", todos: tomorrowTodos)
  }

  private var upcomingTasksSection: some View {
    taskSection(title: "Upcoming", todos: upcomingTodos)
  }

  private var completedTasksSection: some View {
    taskSection(title: "Completed", todos: completedTodos)
  }

  private func deleteTodo(_ todo: TodoItem) {
    modelContext.delete(todo)
  }
}

#Preview {
 
  HomeView(isUserLoggedIn: .constant(true))
    .modelContainer(for: TodoItem.self, inMemory: true)
}
