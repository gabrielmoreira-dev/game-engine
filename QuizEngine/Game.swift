public class Game<Question, Answer, R: Routing> where R.Question == Question, R.Answer == Answer {
    private let flow: Flow<Question, Answer, R>
    
    init(flow: Flow<Question, Answer, R>) {
        self.flow = flow
    }
}

public func startGame<Question, Answer, R: Routing>(
    questions: [Question],
    router: R,
    correctAnswers: [Question: Answer]
) -> Game<Question, Answer, R> where R.Question == Question, R.Answer == Answer {
    let flow = Flow(router: router, questions: questions, scoring: { score($0, correctAnsers: correctAnswers) })
    flow.start()
    return Game(flow: flow)
}

private func score<Question: Hashable, Answer: Equatable>(_ answers: [Question: Answer], correctAnsers: [Question: Answer]) -> Int {
    answers.reduce(0) { (score, tuple) in
        score + (correctAnsers[tuple.key] == tuple.value ? 1 : 0)
    }
}
