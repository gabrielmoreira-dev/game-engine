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
        
        XCTAssertEqual(routerSpy.routedResult, [:])
    }
    
    func testAnswerFirstQuestion_WhenOneQuestion_ShouldRouteToResult() {
        let questions = ["Q1"]
        let sut = makeSUT(questions: questions)
        
        sut.start()
        routerSpy.completion("A1")
        
        XCTAssertEqual(routerSpy.routedResult, ["Q1": "A1"])
    }
    
    func testAnswerFirstAndSecondQuestion_WhenTwoQuestions_ShouldRouteToResult() {
        let questions = ["Q1", "Q2"]
        let sut = makeSUT(questions: questions)
        
        sut.start()
        routerSpy.completion("A1")
        routerSpy.completion("A2")
        
        XCTAssertEqual(routerSpy.routedResult, ["Q1": "A1", "Q2": "A2"])
    }
}

private extension FlowTest {
    func makeSUT(questions: [String] = []) -> Flow {
        Flow(router: routerSpy, questions: questions)
    }
}

private final class RouterSpy: RouterType {
    private(set) var routedQuestions: [String] = []
    private(set) var routedResult: [String: String]?
    var completion: RouterType.Completion = { _ in }
    
    func routeTo(question: String, completion: @escaping (String) -> Void) {
        routedQuestions.append(question)
        self.completion = completion
    }
    
    func routeTo(result: [String : String]) {
        routedResult = result
    }
}
