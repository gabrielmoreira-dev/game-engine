public struct GameResult<Question: Hashable, Answer: Equatable>: Equatable {
    let answers: [Question: Answer]
    let score: Int
}
