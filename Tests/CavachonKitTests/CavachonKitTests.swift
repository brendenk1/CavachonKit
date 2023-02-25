import Combine
import XCTest
@testable import CavachonKit

final class CavachonKitTests: XCTestCase {
    var sequenceTest: SequentialProcessor<XCTestExpectation>?
    var tests = Set<AnyCancellable>()
    
    func testAsyncReduce() async {
        // Given
        let items = Array(repeating: 0, count: 5)
        let expecation = XCTestExpectation(description: "Waiting for all to complete")
        
        // Then
        let reducer: (Int, Int) async -> Int = { cumulative, next in
            try! await Task.sleep(for: .seconds(0.1))
            return cumulative + 1
        }
        
        // Finally
        let count = await items.asyncReduce(0, reducer)
        XCTAssertEqual(count, 5)
        expecation.fulfill()
        
        wait(for: [expecation], timeout: 1.0)
    }
    
    func testSequencialProcessor() {
        // Given
        let completeExpectation = XCTestExpectation(description: "The subscription completes.")
        
        sequenceTest = SequentialProcessor<XCTestExpectation> { expectation in
            try! await Task.sleep(for: .seconds(0.1))
            expectation.fulfill()
        } onProcessError: { _, _ in
            true
        } onCompletion: {
            completeExpectation.fulfill()
        }
        
        // Then
        let expecationOne = XCTestExpectation(description: "Some event...")
        let expecationTwo = XCTestExpectation(description: "Some other event...")
        
        // Finally
        [expecationOne, expecationTwo]
            .publisher
            .subscribe(sequenceTest!)
        
        
        wait(for: [expecationOne, expecationTwo, completeExpectation], timeout: 1.0)
    }
    
    func testDiffingPublisher() {
        // Given
        let left = Set([1, 2])
        let right = Set([1, 2, 3])
        let leftOne = [
            Set([1, 2]),
            Set([1, 2, 3])
        ]
        let rightTwo = [
            Set([1, 2]),
            Set([1, 2, 3, 4])
        ]
        
        // Then
        let expectationOne = XCTestExpectation(description: "Check for added value in right")
        let expectationOneCollection = XCTestExpectation(description: "Check for added value in right chain")
        let expectationTwo = XCTestExpectation(description: "Check for added value in left")
        let expectationTwoCollection = XCTestExpectation(description: "Check for added value in left chain")
        
        // Finally
        DiffingPublisher(left, right, rightToLeft: true)
            .sink {
                XCTAssertEqual($0, [3])
                expectationOne.fulfill()
            }
            .store(in: &tests)
        
        DiffingPublisher(left, right, rightToLeft: false)
            .sink {
                XCTAssertEqual($0, [])
                expectationTwo.fulfill()
            }
            .store(in: &tests)
        
        Just(leftOne).combineLatest(Just(rightTwo))
            .map { $0.0.publisher.combineLatest($0.1.publisher) }
            .switchToLatest()
            .diff(rightToLeft: true)
            .collect(2)
            .sink {
                XCTAssertEqual([Set([]), Set([4])], $0)
                expectationOneCollection.fulfill()
            }
            .store(in: &tests)
        
        Just(leftOne).combineLatest(Just(rightTwo))
            .map { $0.0.publisher.combineLatest($0.1.publisher) }
            .switchToLatest()
            .diff(rightToLeft: false)
            .collect(2)
            .sink {
                XCTAssertEqual([Set([3]), Set([])], $0)
                expectationTwoCollection.fulfill()
            }
            .store(in: &tests)
        
        wait(for: [expectationOne, expectationTwo, expectationOneCollection, expectationTwoCollection], timeout: 0.1)
        
        
    }
}
