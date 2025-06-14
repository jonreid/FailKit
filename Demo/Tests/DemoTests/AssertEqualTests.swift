@testable import Demo
import FailKit
import Testing

final class AssertEqualTests: @unchecked Sendable {
    private let failSpy = FailSpy()

    @Test
    func equal() async throws {
        let failSpy = FailSpy()

        assertEqual(1, expected: 1, failure: failSpy)

        #expect(failSpy.callCount == 0)
    }

    @Test
    func mismatch() async throws {
        assertEqual(2, expected: 1, failure: failSpy)

        #expect(failSpy.callCount == 1)
        #expect(failSpy.messages.first == "Expected 1, but was 2")
    }

    @Test
    func mismatchWithMessage() async throws {
        assertEqual(2, expected: 1, message: "message", failure: failSpy)

        #expect(failSpy.callCount == 1)
        #expect(failSpy.messages.first == "Expected 1, but was 2 - message")
    }
}
