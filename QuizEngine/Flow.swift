protocol RouterType {
    typealias Completion = (String) -> Void
    
    func routeTo(question: String, completion: @escaping Completion)
    func routeTo(result: [String: String])
}

final class Flow {
    private let router: RouterType
    private let questions: [String]
    private var result: [String: String] = [:]
    
    init(router: RouterType, questions: [String] = []) {
        self.router = router
        self.questions = questions
    }
    
    func start() {
        guard let firstQuestion = questions.first else {
            return router.routeTo(result: result)
        }
        router.routeTo(question: firstQuestion, completion: routeNext(from: firstQuestion))
    }
}

private extension Flow {
    func routeNext(from question: String) -> RouterType.Completion {
        { [weak self] in self?.routeNext(question: question, answer: $0) }
    }
    
    func routeNext(question: String, answer: String) {
        result[question] = answer
        guard let questionIndex = self.questions.firstIndex(of: question),
              self.questions.count > questionIndex + 1 else {
            return router.routeTo(result: result)
        }
        let nextQuestion = self.questions[questionIndex + 1]
        self.router.routeTo(question: nextQuestion, completion: self.routeNext(from: nextQuestion))
    }
}
