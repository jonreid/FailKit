// FailKit by Jon Reid, https://qualitycoding.org
// Copyright 2025 Jonathan M. Reid. https://github.com/jonreid/FailKit/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

/// Describe a value, returning a string representation.
///
/// Use in your test failure description.
/// Strings are quoted, escaping special characters.
/// Optional values are described without the `Optional(...)` wrapper.
public func describe(_ value: Any) -> String {
    DescriberChain.head.handle(value)
}

/// Manage chain-of-responsibility for describing values.
private enum DescriberChain {
    static let head: Describer = {
        let fallback = FallbackDescriber()
        let stringHandler = StringDescriber(successor: fallback)
        let optionalHandler = OptionalDescriber(successor: stringHandler)
        return optionalHandler
    }()
}
