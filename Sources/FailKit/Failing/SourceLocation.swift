// FailKit by Jon Reid, https://qualitycoding.org
// Copyright 2025 Jonathan M. Reid. https://github.com/jonreid/FailKit/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

#if canImport(Testing)
import Testing
#endif

public struct SourceLocation {
    public let fileID: String
    public let filePath: StaticString
    public let line: UInt
    public let column: UInt

    public init(fileID: String, filePath: StaticString, line: UInt, column: UInt) {
        self.fileID = fileID
        self.filePath = filePath
        self.line = line
        self.column = column
    }

#if canImport(Testing)
    public func toTestingSourceLocation() -> Testing.SourceLocation {
        Testing.SourceLocation(fileID: fileID, filePath: "\(filePath)", line: Int(line), column: Int(column))
    }
#endif
}
