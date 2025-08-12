// FailKit by Jon Reid, https://qualitycoding.org
// Copyright 2025 Jonathan M. Reid. https://github.com/jonreid/FailKit/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

final class StringDescriber: Describer, @unchecked Sendable {
    override func willHandle(_ value: Any) -> Bool {
        value is String
    }

    override func describe(_ value: Any) -> String {
        toFormattedString(value as! String)
    }

    private func toFormattedString(_ unformatted: String) -> String {
        let formattedChars = unformatted.map { escapeSpecialCharacter($0) }
        return "\"\(formattedChars.joined())\""
    }

    private func escapeSpecialCharacter(_ char: Character) -> String {
        switch char {
        case "\"":
            return "\\\""
        case "\n":
            return "\\n"
        case "\r":
            return "\\r"
        case "\t":
            return "\\t"
        default:
            return String(char)
        }
    }
}
