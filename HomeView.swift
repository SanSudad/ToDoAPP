import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var todos: [TodoItem]
    @State private var searchText = ""
    
    // Sample data for initial setup
    private func addSampleData() {
        let calendar = Calendar.current
        let today = Date()
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        
        let sampleTodos = [
            TodoItem(title: "Mobile App Research", dueDate: today, isToday: true),
            TodoItem(title: "Prepare Wireframe for Main Flow", dueDate: today, isToday: true),
            TodoItem(title: "Prepare Screens", dueDate: today, isToday: true),
            TodoItem(title: "Website Research", dueDate: tomorrow, isTomorrow: true),
            TodoItem(title: "Prepare Wireframe for Main Flow", dueDate: tomorrow, isTomorrow: true),
            TodoItem(title: "Prepare Screens", dueDate: tomorrow, isTomorrow: true)
        ]
        
        // Mark first two as completed for demo
        sampleTodos[0].isCompleted = true
        sampleTodos[1].isCompleted = true
        
        for todo in sampleTodos {
            modelContext.insert(todo)
        }
    }
    
    var todayTodos: [TodoItem] {
        todos.filter { $0.isToday }
    }
    
    var tomorrowTodos: [TodoItem] {
        todos.filter { $0.isTomorrow }
    }
    
    var completedTodayCount: Int {
        todayTodos.filter { $0.isCompleted }.count
    }
    
    var totalTodayCount: Int {
        todayTodos.count
    }
    
    var completionPercentage: Double {
        guard totalTodayCount > 0 else { return 0 }
        return Double(completedTodayCount) / Double(totalTodayCount)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Dark background
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        headerSection
                        
                        // Search Bar
                        searchSection
                        
                        // Progress Section
                        progressSection
                        
                        // Today's Tasks
                        todayTasksSection
                        
                        // Tomorrow Tasks
                        tomorrowTasksSection
                        
                        Spacer(minLength: 100) // Space for floating button
                    }
                    .padding(.horizontal, 20)
                }
                
                // Floating Add Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                .frame(width: 56, height: 56)
                                .background(Color.purple.opacity(0.8))
                                .clipShape(Circle())
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 30)
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            if todos.isEmpty {
                addSampleData()
            }
        }
    }
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Let's complete your goals")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                HStack {
                    Text("today!")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Text("✏️")
                        .font(.title2)
                }
            }
            
            Spacer()
            
            // Profile Image
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: "person.fill")
                        .foregroundColor(.white)
                )
        }
        .padding(.top, 10)
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
                    // Progress Bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 8)
                                .cornerRadius(4)
                            
                            Rectangle()
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [Color.purple, Color.pink]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ))
                                .frame(width: geometry.size.width * completionPercentage, height: 8)
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
    }
    
    private var todayTasksSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Today's Task")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            LazyVStack(spacing: 12) {
                ForEach(todayTodos) { todo in
                    TaskRowView(todo: todo)
                }
            }
        }
    }
    
    private var tomorrowTasksSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tomorrow Task")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            LazyVStack(spacing: 12) {
                ForEach(tomorrowTodos) { todo in
                    TaskRowView(todo: todo)
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
