// FailKit by Jon Reid, https://qualitycoding.org
// Copyright 2025 Jonathan M. Reid. https://github.com/jonreid/FailKit/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

/// Test your assertion helpers by spying on the `Failing` protocol.
///
/// In your assertion helper, include this parameter:
/// ```swift
/// failure: any Failing = Fail()
/// ```
/// Then you can pass an instance of `FailSpy` to your assertion helper in tests.
public final class FailSpy: Failing {
    public private(set) var callCount = 0
    public private(set) var messages: [String] = []
    public private(set) var locations: [SourceLocation] = []

    public init() {}

    public func fail(message: String, location: SourceLocation) {
        callCount += 1
        self.messages.append(message)
        self.locations.append(location)
    }
}
