import XCTest
@testable import QuizEngine

final class GameTest: XCTestCase {
    private let router = RouterSpy()
    private var game: Game<String, String, RouterSpy>!
    
    override func setUp() {
        super.setUp()
        game = startGame(questions: ["Q1", "Q2"], router: router, correctAnswers: ["Q1": "A1", "Q2": "A2"])
    }
    
    override func tearDown() {
        game = nil
        super.tearDown()
    }
    
    func test_startGame_whenAnswerZeroOutOfTwoCorrectly_ShouldScoreZero() {
        router.completion("wrong")
        router.completion("wrong")
        
        XCTAssertEqual(router.routedResult?.score, 0)
    }
    
    func test_startGame_whenAnswerOneOutOfTwoCorrectly_ShouldScoreOne() {
        router.completion("A1")
        router.completion("wrong")
        
        XCTAssertEqual(router.routedResult?.score, 1)
    }
    
    func test_startGame_whenAnswerTwoOutOfTwoCorrectly_ShouldScoreTwo() {
        router.completion("A1")
        router.completion("A2")
        
        XCTAssertEqual(router.routedResult?.score, 2)
    }
}
