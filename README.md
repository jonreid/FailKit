# FailKit

[![Build](https://github.com/jonreid/FailKit/actions/workflows/build.yml/badge.svg)](https://github.com/jonreid/FailKit/actions/workflows/build.yml)
[![Bluesky](https://img.shields.io/badge/Bluesky-0285FF?logo=bluesky&logoColor=fff)](https://bsky.app/profile/qualitycoding.org)
[![Mastodon](https://img.shields.io/mastodon/follow/109765011064804734?domain=https%3A%2F%2Fiosdev.space
)](https://iosdev.space/@qcoding)
[![YouTube](https://img.shields.io/youtube/channel/subscribers/UC69XtVGLRydpG7o1nkdQs8Q)](https://www.youtube.com/@QualityCoding)

Most projects should include custom test assertions to make tests more expressive and easier to write.

But when you write custom test assertions, how can you support both XCTest and Swift Testing? You can write them twice (with different names). Or you can use FailKit.

## Features

- **Test Failures**: Report failures consistently across testing frameworks
  - Works with both Swift Testing and XCTest
  - Includes source location information

- **Value Description**: Format values to make failure messages easier to read
  - Optional values are described without the `Optional(...)` wrapper
  - Strings are quoted and show escaped special characters

- **Test Your Assertions**: Test your assertion helpers with `FailSpy`
  - Confirm whether it reports a failure
  - Test the contents of the failure message

## Usage

### Fail.fail

Let’s say we want an equality assertion that improves on `XCTestAssertEqual` by identifying the expected value vs. the actual value.

One ordinarily writes an XCTest assertion by calling `XCTFail`:

```swift
func assertEqual<T: Equatable>(
    _ actual: T,
    expected: T,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    if actual == expected { return }
    XCTFail("Expected \(expected), but was \(actual)", file: file, line: line)
}
```

Note that we pass the location of the call site down to `XCTFail` so it reports the location correctly.

This works pretty well. We use it across several tests. But now, we want to migrate those tests from XCTest to Swift Testing. We can copy our assertion function and rework it for Swift Testing.  But this migration will take some time because we have many tests. So we have to give the duplicate function a slightly different name.

Or we use FailKit instead:

```swift
func assertEqual<T: Equatable>(
    _ actual: T,
    expected: T,
    fileID: String = #fileID,
    filePath: StaticString = #filePath,
    line: UInt = #line,
    column: UInt = #column
) {
    if actual == expected { return }
    Fail.fail(
        message: "Expected \(expected), but was \(actual)",
        location: SourceLocation(fileID: fileID, filePath: filePath, line: line, column: column)
    )
}
```

`Fail.fail(message:location:)` does the work of routing the failure to either XCTest or Swift Testing. Note the change in location parameters and how we pass them into `Fail`.

### Describe Values

In our example, the message is

```swift
"Expected \(expected), but was \(actual)"
```

It converts the `expected` and `actual` values into strings. Here are some examples of different string conversions, depending on the original type:

| Type   | Output                                        |
| ------ | --------------------------------------------- |
| Int    | Expected 123, but was 456                     |
| Int?   | Expected Optional(123), but was Optional(456) |
| String | Expected ab cd, but was de fg                 |

The integer is fine. But the optional integer is noisy in test output. When reporting differences in values, we want the boxed values. Our brains have to strip out the Optional(…) wrappers to find the parts we care about.

The string doesn’t look like a string. This makes it hard to distinguish spaces. And any special characters, like tab and newline, are converted into empty spaces.

We can improve value descriptions in test messages by calling FailKit’s `describe` function.

```swift
"Expected \(describe(expected)), but was \(describe(actual))"
```

| Type   | Output                            |
| ------ | --------------------------------- |
| Int    | Expected 123, but was 456         |
| Int?   | Expected 123, but was 456         |
| String | Expected "ab cd", but was "de fg" |

A string with a tab will look like `"ab\tcd"`, just as we’d write it in a string literal. Now we can distinguish special characters from spaces.

### Add a Distinguishing Message



### Testing Your Assertion Helpers

```swift
func assertEqual<T: Equatable>(_ actual: T, _ expected: T, failure: any Failing = Fail()) {
    if actual != expected {
        failure.fail(
            message: "Expected \(describe(expected)) but got \(describe(actual))",
            location: SourceLocation(fileID: #fileID, filePath: #filePath, line: #line, column: #column)
        )
    }
}

// In your tests
func testAssertEqual() {
    let spy = FailSpy()
    assertEqual(0, 42, failure: spy)
    #expect(spy.callCount == 1)
    #expect(spy.messages.first == "Expected 42 but got 0")
}
```

## Installation

### Swift Package Manager

Add FailKit to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/jonreid/FailKit.git", from: "1.0.0")
]
```
