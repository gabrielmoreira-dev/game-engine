@testable import QuizEngine

final class RouterSpy: Routing {
    private(set) var routedQuestions: [String] = []
    private(set) var routedResult: GameResult<String, String>?
    var completion: (String) -> Void = { _ in }
    
    func routeTo(question: String, completion: @escaping (String) -> Void) {
        routedQuestions.append(question)
        self.completion = completion
    }
    
    func routeTo(result: GameResult<String, String>) {
        routedResult = result
    }
}
