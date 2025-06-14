// FailKit by Jon Reid, https://qualitycoding.org
// Copyright 2025 Jonathan M. Reid. https://github.com/jonreid/FailKit/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

/// Concatenate a message suffix to your test failure description.
public func messageSuffix(_ message: String) -> String {
    if message.isEmpty { return message }
    return " - \(message)"
}
