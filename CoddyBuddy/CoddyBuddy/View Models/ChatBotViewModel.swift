import Foundation
import OpenAISwift

class ChatBotViewModel: ObservableObject {
    init() {setup()}
    private var user: OpenAISwift?
    
    func setup() {
        user = OpenAISwift(authToken: "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")
        // MARK: DEPRACTED API KEYS
        //user = OpenAISwift(authToken: "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")
        //user = OpenAISwift(authToken: "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")
    }
    
    func userMessage(message: String, completionHadler: @escaping (String) -> Void) {
        user?.sendCompletion(with: message, maxTokens: 500, completionHandler: { output in
            switch output {
            case .success(let model):
                let output = model.choices?.first?.text.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                completionHadler(output)
                print(output)
            case .failure:
                print("Error On Fetching ChatBot Response")
                break
            }
        })
    }
}
