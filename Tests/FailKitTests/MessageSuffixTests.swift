// FailKit by Jon Reid, https://qualitycoding.org
// Copyright 2025 Jonathan M. Reid. https://github.com/jonreid/FailKit/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

import FailKit
import Testing

final class MessageSuffixTests: @unchecked Sendable {
    @Test
    func noMessage() throws {
        #expect(messageSuffix(nil) == "")
    }
    
    @Test
    func message() throws {
        #expect(messageSuffix("message") == " - message")
    }
}
