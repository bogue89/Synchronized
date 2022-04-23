import XCTest
@testable import Synchronized

final class SynchronizedTests: XCTestCase {
    @Synchronized
    var array: [Int] = []

    func testRaceCondition() throws {
        // A concurrent queue is created to run operations in parallel
        let queue = DispatchQueue(label: "test.queue", attributes: .concurrent)

        (0..<10000).forEach { n in

            let write = self.expectation(description: "w-\(n)")
            let read = self.expectation(description: "r-\(n)")
            queue.async {
                self.array.append(n)
                write.fulfill()


            }
            queue.async {
                self.array = []
                read.fulfill()
            }

        }
        self.waitForExpectations(timeout: 2)
        XCTAssert(true, "Race condition")
    }
}
