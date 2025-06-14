# FailKit

[![Build](https://github.com/jonreid/FailKit/actions/workflows/build.yml/badge.svg)](https://github.com/jonreid/FailKit/actions/workflows/build.yml)

Most projects should include custom test assertions to make tests more expressive and easier to write.

But when you write custom test assertions, how can you support both XCTest and Swift Testing? You can write them twice (with different names). Or you can use FailKit.

## Features

- **Test Failures**: Report failures consistently across testing frameworks
  - Works with both Swift Testing and XCTest
  - Includes source location information

- **Value Description**: Format values to make failure messages easier to read
  - Optional values are described without the `Optional(…)` wrapper
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

| Type   | Swift conversion                              |
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

| Type   | Swift conversion                              | FailKit describe()                |
| ------ | --------------------------------------------- | --------------------------------- |
| Int    | Expected 123, but was 456                     | Expected 123, but was 456         |
| Int?   | Expected Optional(123), but was Optional(456) | Expected 123, but was 456         |
| String | Expected ab cd, but was de fg                 | Expected "ab cd", but was "de fg" |

A string with a tab will look like `"ab\tcd"`, just as we’d write it in a string literal. Now we can distinguish special characters from spaces.

### Add a Distinguishing Message

When a test has multiple assertions, it’s often helpful to add a distinguishing message. This helps us identify the point of failure even from raw console output, as you get from a build server.

To separate this distinguishing message from the main message, use FailKit’s `messageSuffix` function. First, add a `String` parameter with a default value of empty string:

```swift
func assertEqual<T: Equatable>(
    _ actual: T,
    expected: T,
    message: String = "", // 👈 like this
    fileID: String = #fileID,
    filePath: StaticString = #filePath,
    line: UInt = #line,
    column: UInt = #column
)
```

Concatenate `messageSuffix(message)` to your failure message:

```swift
"Expected \(expected), but was \(actual)" + messageSuffix(message)
```

When the distinguishing message is non-empty, `messageSuffix` adds a separator. So for this assertion,

```swift
let result = 6 * 9
assertEqual(result, 42, "answer to the ultimate question")
```

the output will be,

> Expected 42, but was 54 - answer to the ultimate question


### Testing Your Assertion Helpers

Finally, what if you want to release your assertion helper in its own module? It should have its own tests. How do you test:

- when it succeeds?
- when it fails?
- different failure messages it reports?

To do that, add an `any Failing` parameter with `Fail()` as the default value.

```swift
func assertEqual<T: Equatable>(
    _ actual: T,
    expected: T,
    message: String = "",
    fileID: String = #fileID,
    filePath: StaticString = #filePath,
    line: UInt = #line,
    column: UInt = #column,
    failure: any Failing = Fail() // 👈 like this
)
```

In the body of your assertion, replace the call to `Fail.fail` with `failure.fail`:

```swift
failure.fail( // 👈 like this
    message: "Expected \(describe(expected)), but was \(describe(actual))" + messageSuffix(message),
    location: SourceLocation(fileID: fileID, filePath: filePath, line: line, column: column)
)
```

To test this, create a `FailSpy` and inject it. To test a passing scenario, the spy’s `callCount` should be 0.

```swift
@Test
func equal() async throws {
    let failSpy = FailSpy()
    
    assertEqual(1, expected: 1, failure: failSpy)

    #expect(failSpy.callCount == 0)
}
```

To test a failing scenario, confirm that the `callCount` is 1 and check the first value in `messages`.

```swift
@Test
func mismatch() async throws {
    let failSpy = FailSpy()

    assertEqual(2, expected: 1, failure: failSpy)

    #expect(failSpy.callCount == 1)
    #expect(failSpy.messages.first == "Expected 1, but was 2")
}
```

With this knowledge, you can now TDD your custom assertions!

## Describe Value Details

FailKit’s `describe` function converts values for ease of reading in test failures.

If the value is optional, it removes the `Optional(…)` wrapper.

If the value is a string, it’s shown in double quotes with the following characters represented as escaped special characters:

- \\" (double quotation mark)
- \n (line feed)
- \r (carriage return)
- \t (horizontal tab)

Other types of values use normal Swift conversion.

## How to Install

### Swift Package Manager

If you have a `Package.swift` file, declare the following dependency:

```swift
dependencies: [
    .package(url: "https://github.com/jonreid/FailKit.git", from: "1.0.0")
]
```

Then add it to the appropriate target:

```swift
dependencies: ["FailKit"]
```

## Author

Jon Reid is the author of _[iOS Unit Testing by Example](https://iosunittestingbyexample.com)._ His website is [Quality Coding](https://qualitycoding.org).

[![Bluesky](https://img.shields.io/badge/Bluesky-0285FF?logo=bluesky&logoColor=fff)](https://bsky.app/profile/qualitycoding.org)
[![Mastodon](https://img.shields.io/mastodon/follow/109765011064804734?domain=https%3A%2F%2Fiosdev.space
)](https://iosdev.space/@qcoding)
[![YouTube](https://img.shields.io/youtube/channel/subscribers/UC69XtVGLRydpG7o1nkdQs8Q)](https://www.youtube.com/@QualityCoding)