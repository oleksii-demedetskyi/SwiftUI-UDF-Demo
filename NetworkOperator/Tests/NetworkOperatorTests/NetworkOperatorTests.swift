import XCTest
@testable import NetworkOperator

final class NetworkOperatorTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(NetworkOperator().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
