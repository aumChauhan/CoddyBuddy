import SwiftUI

struct ShareFeedBack: View {
    @State var feedbackType: String = "Report Bug"
    @State var feedbackString: String = ""
    @AppStorage("selectedColor") var selectedColor: String = "Theme_Blue"
    @ObservedObject var feedbackObject = feedbackViewModel()
    @AppStorage("toggleHaptics") var toggleHaptics: Bool = true
    
    var body: some View {
        List {
            Section {
                Picker(selection: $feedbackType) {
                    Text("Report Bug").tag("Report Bug")
                    Text("Feedback").tag("Feedback")
                } label: {
                    Text("Feedback Category")
                }
                .pickerStyle(.menu)
                .tint(Color(selectedColor))
                
            }
            TextEditor(text: $feedbackString)
                .frame(height: UIScreen.main.bounds.width/1.7)
                .scrollContentBackground(.hidden)
                .background(Color(uiColor: .secondarySystemBackground).opacity(0.0))
                .cornerRadius(10)
                .scrollDismissesKeyboard(ScrollDismissesKeyboardMode.immediately)
                .tint(Color(selectedColor))
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Feedback")
        .navigationBarItems(
            trailing:
                Button {
                    feedbackObject.postFeedback(feedbackType: feedbackType, feedbackString: feedbackString.trimmingCharacters(in: .whitespaces))
                    feedbackString = ""
                    if toggleHaptics {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }
                } label: {
                    Text("Submit")
                        .foregroundColor(feedbackValidation(feedback: feedbackString) ? Color(selectedColor) : .gray)
                }.disabled(!feedbackValidation(feedback: feedbackString))
            
        )
        .navigationBarTitleDisplayMode(.inline)
        
        .alert(isPresented: $feedbackObject.isSubmitted) {
            Alert(title: Text("Thanks For Your Feedback"))
        }   
    }
    
    func feedbackValidation(feedback: String) -> Bool {
        if feedback.count >= 1 && feedback.count <= 500 && !(feedback.hasPrefix(" ") && feedback.hasSuffix(" ")) {
            return true
        }
        return false
    }
    
}

struct ShareFeedBack_Previews: PreviewProvider {
    static var previews: some View {
        ShareFeedBack()
    }
}
