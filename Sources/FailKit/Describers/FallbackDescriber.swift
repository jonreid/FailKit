// FailKit by Jon Reid, https://qualitycoding.org
// Copyright 2025 Jonathan M. Reid. https://github.com/jonreid/FailKit/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

final class FallbackDescriber: Describer, @unchecked Sendable {
    override func willHandle(_ value: Any) -> Bool {
        true
    }

    override func describe(_ value: Any) -> String {
        String(describing: value)
    }
}
