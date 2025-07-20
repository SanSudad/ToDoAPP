import SwiftUI

struct TaskRowView: View {
    @Bindable var todo: TodoItem
    
    private var accentColor: Color {
        let colors: [Color] = [.orange, .blue, .purple, .pink, .green]
        return colors[abs(todo.title.hashValue) % colors.count]
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        return formatter
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Left accent bar
            Rectangle()
                .fill(accentColor)
                .frame(width: 4)
                .cornerRadius(2)
            
            // Content
            VStack(alignment: .leading, spacing: 6) {
                Text(todo.title)
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                
                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text(dateFormatter.string(from: todo.dueDate))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            // Completion button
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    todo.isCompleted.toggle()
                }
            }) {
                ZStack {
                    Circle()
                        .stroke(todo.isCompleted ? Color.purple : Color.gray.opacity(0.5), lineWidth: 2)
                        .frame(width: 28, height: 28)
                    
                    if todo.isCompleted {
                        Circle()
                            .fill(Color.purple)
                            .frame(width: 28, height: 28)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(16)
        .opacity(todo.isCompleted ? 0.7 : 1.0)
    }
}

#Preview {
    TaskRowView(todo: TodoItem(title: "Sample Task", dueDate: Date(), isToday: true))
        .preferredColorScheme(.dark)
        .padding()
        .background(Color.black)
}
