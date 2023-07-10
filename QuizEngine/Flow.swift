final class Flow<Question, Answer, R: Routing> where R.Question == Question, R.Answer == Answer {
    private let router: R
    private let questions: [Question]
    private var answers: [Question: Answer] = [:]
    private let scoring: ([Question: Answer]) -> Int
    
    init(
        router: R,
        questions: [Question] = [],
        scoring: @escaping ([Question: Answer]) -> Int
    ) {
        self.router = router
        self.questions = questions
        self.scoring = scoring
    }
    
    func start() {
        guard let firstQuestion = questions.first else {
            return router.routeTo(result: result)
        }
        router.routeTo(question: firstQuestion, completion: routeNext(from: firstQuestion))
    }
}

private extension Flow {
    var result: GameResult<Question, Answer> {
        GameResult(answers: answers, score: scoring(answers))
    }
    
    func routeNext(from question: Question) -> (Answer) -> Void {
        { [weak self] in self?.routeNext(question: question, answer: $0) }
    }
    
    func routeNext(question: Question, answer: Answer) {
        answers[question] = answer
        guard let questionIndex = self.questions.firstIndex(of: question),
              self.questions.count > questionIndex + 1 else {
            return router.routeTo(result: result)
        }
        let nextQuestion = self.questions[questionIndex + 1]
        self.router.routeTo(question: nextQuestion, completion: self.routeNext(from: nextQuestion))
    }
}
