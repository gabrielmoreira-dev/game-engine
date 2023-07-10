public protocol Routing {
    associatedtype Question: Hashable
    associatedtype Answer: Equatable
    
    func routeTo(question: Question, completion: @escaping (Answer) -> Void)
    func routeTo(result: GameResult<Question, Answer>)
}
