# FailKit

[![Build](https://github.com/jonreid/FailKit/actions/workflows/build.yml/badge.svg)](https://github.com/jonreid/FailKit/actions/workflows/build.yml)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fjonreid%2FFailKit%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/jonreid/FailKit)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fjonreid%2FFailKit%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/jonreid/FailKit)

Writing custom test assertions makes your tests more expressive and easier to maintain.

But how do you support both **XCTest** and **Swift Testing?**

XCTest uses `XCTFail`. Swift Testing uses `Issue.record`. You can’t just call one from the other. You could write your assertions twice — or use **FailKit.**

<!-- toc -->
## Contents

  * [Features](#features)
  * [Usage](#usage)
    * [`Fail.fail`](#failfail)
    * [Better Value Descriptions with `describe`](#better-value-descriptions-with-describe)
    * [Add a Distinguishing Message](#add-a-distinguishing-message)
    * [Test Your Custom Assertions](#test-your-custom-assertions)
      * [✅ Success Case (No Failure)](#-success-case-no-failure)
      * [❌ Failure Case (Should Fail)](#-failure-case-should-fail)
  * [`describe` Details](#describe-details)
  * [Installation](#installation)
  * [About the Author](#about-the-author)<!-- endToc -->

## Features

- **Unified Failure Reporting**:  
Works with **XCTest** and **Swift Testing,** including source location.

- **Cleaner Value Descriptions**:  
Optional values without `Optional(…)`; strings quoted and escaped.

- **Assertion Testing**:  
Use `FailSpy` to test your custom assertions: did they fail, and how?

## Usage

### `Fail.fail`

Let’s say we want a custom equality assertion that’s clearer than `XCTestAssertEqual`:

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

This works — until you start migrating to Swift Testing. You’ll need to duplicate the function, rename it, and re-implement the failure logic.

With **FailKit,** you can write one assertion that works in both worlds:

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

`Fail.fail` automatically routes to the appropriate testing framework.

### Better Value Descriptions with `describe`

Consider this failure message:

```swift
"Expected \(expected), but was \(actual)"
```

Depending on the type, the results may be unclear:


| Type   | Without FailKit                               | With `describe()`                 |
| ------ | --------------------------------------------- | --------------------------------- |
| Int    | Expected 123, but was 456                     | Expected 123, but was 456         |
| Int?   | Expected Optional(123), but was Optional(456) | Expected 123, but was 456         |
| String | Expected ab cd, but was de fg                 | Expected "ab cd", but was "de fg" |

Improve this by using:

```swift
"Expected \(describe(expected)), but was (describe(actual))"
```

Optional values are unwrapped. Strings are quoted and escaped, making special characters visible.

### Add a Distinguishing Message

When a test has multiple assertions, it helps to add a short distinguishing message:

```swift
let result = 6 * 9
assertEqual(result, 42, "answer to the ultimate question")
```

To support this, add a `message` parameter with a default:


When a test has multiple assertions, it’s often helpful to add a distinguishing message. This helps us identify the point of failure even from raw console output, as you get from a build server.

To separate this distinguishing message from the main message, use FailKit’s `messageSuffix` function. First, add a `String` parameter with a default value of empty string:

```swift
func assertEqual<T: Equatable>(
    _ actual: T,
    expected: T,
    message: String = "",
    ...
)
```

And append it using `messageSuffix`:

```swift
"Expected \(expected), but was \(actual)" + messageSuffix(message)
```

FailKit will insert a separator if the message is non-empty:

> Expected 42, but was 54 - answer to the ultimate question


### Test Your Custom Assertions

You can test your assertion helpers using `FailSpy`. First, modify your function to take a `Failing` parameter:

```swift
func assertEqual<T: Equatable>(
    _ actual: T,
    expected: T,
    ...,
    failure: any Failing = Fail()
)
```

Then, call `failure.fail(…)` instead of `Fail.fail(…)`.

To test it:

#### ✅ Success Case (No Failure)

```swift
@Test
func equal() async throws {
    let failSpy = FailSpy()
    
    assertEqual(1, expected: 1, failure: failSpy)

    #expect(failSpy.callCount == 0)
}
```

#### ❌ Failure Case (Should Fail)

```swift
@Test
func mismatch() async throws {
    let failSpy = FailSpy()

    assertEqual(2, expected: 1, failure: failSpy)

    #expect(failSpy.callCount == 1)
    #expect(failSpy.messages.first == "Expected 1, but was 2")
}
```

You can now test your own test helpers — and TDD them, too.

## `describe` Details

The `describe()` function formats values to improve test output:

- **Optionals:** Removes `Optional(…)` wrapper
- **Strings:** Adds quotes and escapes
	- `\\"` (quote)
	- `\n`, `\r`, `\t` (newline, carriage return, tab)
- **Other types:** Use default Swift description

## Installation

Use Swift Package Manager:

<!-- snippet: dependency-declaration -->

And in your target:

<!-- snippet: dependency-use -->

## About the Author

Jon Reid is the author of _[iOS Unit Testing by Example](https://iosunittestingbyexample.com)._ Find more at [Quality Coding](https://qualitycoding.org).

[![Bluesky](https://img.shields.io/badge/Bluesky-0285FF?logo=bluesky&logoColor=fff)](https://bsky.app/profile/qualitycoding.org)
[![Mastodon](https://img.shields.io/mastodon/follow/109765011064804734?domain=https%3A%2F%2Fiosdev.space
)](https://iosdev.space/@qcoding)
[![YouTube](https://img.shields.io/youtube/channel/subscribers/UC69XtVGLRydpG7o1nkdQs8Q)](https://www.youtube.com/@QualityCoding)
