import XCTest

@testable import iProgressHUD

final class iProgressHUDTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(iProgressHUD().boxSize, 50)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
