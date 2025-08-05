//import SwiftUI
//
//struct TimePickerCardView: View {
//    @State private var selectedTime = Date()
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            Text("Time")
//                .font(.headline)
//
//            TimePickerTextField(selectedTime: $selectedTime)
//                .frame(height: 50)
//        }
//        .padding()
//    }
//}
//
//struct TimePickerTextField: UIViewRepresentable {
//    @Binding var selectedTime: Date
//
//    func makeUIView(context: Context) -> UITextField {
//        let textField = UITextField()
//        textField.tintColor = .clear // Hide cursor
//
//        let picker = UIDatePicker()
//        picker.datePickerMode = .time
//        picker.preferredDatePickerStyle = .wheels
//        picker.addTarget(context.coordinator, action: #selector(Coordinator.timeChanged(_:)), for: .valueChanged)
//
//        textField.inputView = picker
//
//        // Custom styling (icon + text inside padding)
//        let icon = UIImage(systemName: "clock")!
//        let imageView = UIImageView(image: icon)
//        imageView.tintColor = UIColor.systemPurple
//        imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//
//        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
//        paddingView.addSubview(imageView)
//        textField.leftView = paddingView
//        textField.leftViewMode = .always
//
//        textField.backgroundColor = UIColor.systemGray5
//        textField.layer.cornerRadius = 10
//        textField.text = formattedTime(selectedTime)
//        textField.textColor = UIColor.label
//        textField.textAlignment = .left
//        textField.font = UIFont.systemFont(ofSize: 16)
//        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
//
//        context.coordinator.picker = picker
//        context.coordinator.textField = textField
//
//        return textField
//    }
//
//    func updateUIView(_ uiView: UITextField, context: Context) {
//        uiView.text = formattedTime(selectedTime)
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject {
//        var parent: TimePickerTextField
//        weak var picker: UIDatePicker?
//        weak var textField: UITextField?
//
//        init(_ parent: TimePickerTextField) {
//            self.parent = parent
//        }
//
//        @objc func timeChanged(_ sender: UIDatePicker) {
//            parent.selectedTime = sender.date
//            textField?.text = formattedTime(sender.date)
//        }
//    }
//
//    func formattedTime(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.timeStyle = .short
//        return formatter.string(from: date)
//    }
//   static func formattedTime(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.timeStyle = .short
//        return formatter.string(from: date)
//    }
//}
