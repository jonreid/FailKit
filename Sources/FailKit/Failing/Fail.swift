// FailKit by Jon Reid, https://qualitycoding.org
// Copyright 2025 Jonathan M. Reid. https://github.com/jonreid/FailKit/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

import XCTest

#if canImport(Testing)
import Testing
#endif

public struct Fail: Failing {
    public init() {}

    public func fail(message: String, location: SourceLocation) {
        if isRunningSwiftTest() {
#if canImport(Testing)
            Issue.record(Testing.Comment(rawValue: message), sourceLocation: location.toTestingSourceLocation())
#endif
            return
        }

        XCTFail(message, file: location.filePath, line: location.line)
    }

    private func isRunningSwiftTest() -> Bool {
#if canImport(Testing)
        Test.current != nil
#else
        false
#endif
    }
}
