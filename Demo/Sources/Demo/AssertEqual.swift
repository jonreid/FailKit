import FailKit

public func assertEqual<T: Equatable>(
    _ actual: T,
    expected: T,
    message: String = "",
    fileID: String = #fileID,
    filePath: StaticString = #filePath,
    line: UInt = #line,
    column: UInt = #column,
    failure: any Failing = Fail()
) {
    if actual == expected { return }
    failure.fail(
        message: "Expected \(describe(expected)), but was \(describe(actual))" + messageSuffix(message),
        location: SourceLocation(fileID: fileID, filePath: filePath, line: line, column: column)
    )
}
