// FailKit by Jon Reid, https://qualitycoding.org
// Copyright 2025 Jonathan M. Reid. https://github.com/jonreid/FailKit/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

import FailKit
import Testing

final class DescribeTests: @unchecked Sendable {
    @Test
    func boolean() throws {
        #expect(describe(true) == "true")
    }

    @Test
    func integer() throws {
        #expect(describe(42) == "42")
    }

    @Test
    func optionalInteger() throws {
        let optional: Int? = 42
        #expect(describe(optional as Any) == "42", "remove optional from description")
    }

    @Test
    func describeNil() throws {
        let optional: String? = nil
        #expect(describe(optional as Any) == "nil")
    }

    @Test
    func plainString() throws {
        #expect(describe("plain") == #""plain""#, "surround with quotes")
    }

    @Test
    func stringWithQuote() throws {
        #expect(describe("a\"b") == #""a\"b""#, "escape double quotes")
    }

    @Test
    func stringWithNewline() throws {
        #expect(describe("a\nb") == #""a\nb""#, "escape newline")
    }

    @Test
    func stringWithCarriageReturn() throws {
        #expect(describe("a\rb") == #""a\rb""#, "escape carriage return")
    }

    @Test
    func stringWithTab() throws {
        #expect(describe("a\tb") == #""a\tb""#, "escape tab")
    }

    @Test
    func describeCustomType() throws {
        struct TestStruct { let value = 42 }
        #expect(describe(TestStruct()) == "TestStruct(value: 42)")
    }
}
