public struct GameResult<Question: Hashable, Answer: Equatable>: Equatable {
    public let answers: [Question: Answer]
    public let score: Int
}
