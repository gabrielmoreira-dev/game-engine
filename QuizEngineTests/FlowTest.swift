@testable import QuizEngine
import XCTest

final class FlowTest: XCTestCase {
    private lazy var routerSpy = RouterSpy()
    
    func testStart_WhenNoQuestions_ShouldNotRouteToQuestion() {
        let sut = makeSUT()
        
        sut.start()
        
        XCTAssert(routerSpy.routedQuestions.isEmpty)
    }
    
    func testStart_WhenOneQuestion_ShouldRouteToQuestion() {
        let questions = ["Q1"]
        let sut = makeSUT(questions: questions)
        
        sut.start()
        
        XCTAssertEqual(routerSpy.routedQuestions, questions)
    }
    
    func testStart_WhenTwoQuestions_ShouldRouteToQuestion() {
        let questions = ["Q2", "Q3"]
        let sut = makeSUT(questions: questions)
        
        sut.start()
        
        XCTAssertEqual(routerSpy.routedQuestions, [questions[0]])
    }
    
    func testStartTwice_WhenTwoQuestions_ShouldRouteToQuestion() {
        let questions = ["Q1", "Q2"]
        let sut = makeSUT(questions: questions)
        
        sut.start()
        sut.start()
        
        XCTAssertEqual(routerSpy.routedQuestions, [questions[0], questions[0]])
    }
    
    func testAnswerFirstQuestion_WhenOneQuestion_ShouldNotRouteToAnotherQuestion() {
        let questions = ["Q1"]
        let sut = makeSUT(questions: questions)
        
        sut.start()
        routerSpy.completion("A1")
        
        XCTAssertEqual(routerSpy.routedQuestions, questions)
    }
    
    func testAnswerFirstQuestion_WhenTwoQuestions_ShouldRouteToQuestion() {
        let questions = ["Q1", "Q2"]
        let sut = makeSUT(questions: questions)
        
        sut.start()
        routerSpy.completion("A1")
        
        XCTAssertEqual(routerSpy.routedQuestions, questions)
    }
    
    func testAnswerFirstQuestion_WhenTwoQuestions_ShouldNotRouteToResult() {
        let questions = ["Q1", "Q2"]
        let sut = makeSUT(questions: questions)
        
        sut.start()
        routerSpy.completion("A1")
        
        XCTAssertNil(routerSpy.routedResult)
    }
    
    func testAnswerFirstAndSecondQuestion_WhenThreeQuestions_ShouldRouteToQuestion() {
        let questions = ["Q1", "Q2", "Q3"]
        let sut = makeSUT(questions: questions)
        
        sut.start()
        routerSpy.completion("A1")
        routerSpy.completion("A2")
        
        XCTAssertEqual(routerSpy.routedQuestions, questions)
    }
    
    func testStart_WhenNoQuestions_ShouldRouteToResult() {
        let sut = makeSUT()
        
        sut.start()
        
        XCTAssertEqual(routerSpy.routedResult?.answers, [:])
    }
    
    func testAnswerFirstQuestion_WhenOneQuestion_ShouldRouteToResult() {
        let questions = ["Q1"]
        let sut = makeSUT(questions: questions)
        
        sut.start()
        routerSpy.completion("A1")
        
        XCTAssertEqual(routerSpy.routedResult?.answers, ["Q1": "A1"])
    }
    
    func testAnswerFirstAndSecondQuestion_WhenTwoQuestions_ShouldRouteToResult() {
        let questions = ["Q1", "Q2"]
        let sut = makeSUT(questions: questions)
        
        sut.start()
        routerSpy.completion("A1")
        routerSpy.completion("A2")
        
        XCTAssertEqual(routerSpy.routedResult?.answers, ["Q1": "A1", "Q2": "A2"])
    }
    
    func testAnswerFirstAndSecondQuestion_WhenTwoQuestions_ShouldScore() {
        let questions = ["Q1", "Q2"]
        let sut = makeSUT(questions: questions) { _ in 10 }
        
        sut.start()
        routerSpy.completion("A1")
        routerSpy.completion("A2")
        
        XCTAssertEqual(routerSpy.routedResult?.score, 10)
    }
    
    func testAnswerFirstAndSecondQuestion_WhenTwoQuestions_ShouldScoreWithRightAnswers() {
        var receivedAnsers: [String:String] = [:]
        let questions = ["Q1", "Q2"]
        let sut = makeSUT(questions: questions) { answers in
            receivedAnsers = answers
            return 20
        }
        
        sut.start()
        routerSpy.completion("A1")
        routerSpy.completion("A2")
        
        XCTAssertEqual(receivedAnsers,["Q1": "A1", "Q2": "A2"])
    }
}

private extension FlowTest {
    func makeSUT(
        questions: [String] = [],
        scoring: @escaping ([String: String]) -> Int = { _ in 0 }
    ) -> Flow<String, String, RouterSpy> {
        Flow(router: routerSpy, questions: questions, scoring: scoring)
    }
}
