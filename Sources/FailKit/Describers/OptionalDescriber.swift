// FailKit by Jon Reid, https://qualitycoding.org
// Copyright 2025 Jonathan M. Reid. https://github.com/jonreid/FailKit/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

final class OptionalDescriber: Describer, @unchecked Sendable {
    override func willHandle(_ value: Any) -> Bool {
        Mirror(reflecting: value).displayStyle == .optional
    }

    override func describe(_ value: Any) -> String {
        let mirror = Mirror(reflecting: value)
        if let child = mirror.children.first {
            return String(describing: child.value)
        }
        return "nil"
    }
}
