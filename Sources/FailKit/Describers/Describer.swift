// FailKit by Jon Reid, https://qualitycoding.org
// Copyright 2025 Jonathan M. Reid. https://github.com/jonreid/FailKit/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

/// Chain-of-responsibility for describing values.
class Describer: @unchecked Sendable {
    private let successor: Describer?

    init(successor: Describer? = nil) {
        self.successor = successor
    }

    func handle(_ value: Any) -> String {
        if willHandle(value) {
            return describe(value)
        }
        if let successor {
            return successor.handle(value)
        }
        return "error: no describer for value"
    }

    func willHandle(_ value: Any) -> Bool {
        fatalError("Subclasses must override willHandle(_:)")
    }

    func describe(_ value: Any) -> String {
        fatalError("Subclasses must override describe(_:)")
    }
}
