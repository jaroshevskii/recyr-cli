import ArgumentParser
import CustomDump
import Dependencies
import Foundation
import Testing
@testable import RecyrCore

@Suite("FixEncoding")
struct FixEncodingTests {
  @Test func exposesConfiguration() {
    #expect(FixEncoding.configuration.abstract.contains("Cyrillic"))
    _ = FixEncoding()
  }

  @Test func writesOutputFile() throws {
    let input = URL(fileURLWithPath: "/tmp/input.txt")
    let output = URL(fileURLWithPath: "/tmp/output.txt")
    let fs = TestFileSystem(storage: [input: Fixtures.cp1251Cyrillic])
    let command = FixEncoding(inputPath: input.path, output: output.path)

    try withDependencies { $0.encodingClient = fs.client } operation: {
      try command.run()
    }

    expectNoDifference(String(data: fs.storage[output]!, encoding: .utf8), Fixtures.utf8Text)
    expectNoDifference(fs.storage[input], Fixtures.cp1251Cyrillic)
  }

  @Test func overwritesInputInPlaceWhenNoOutputProvided() throws {
    let input = URL(fileURLWithPath: "/tmp/input.txt")
    let fs = TestFileSystem(storage: [input: Fixtures.cp1251Cyrillic])
    let command = FixEncoding(inputPath: input.path)

    try withDependencies { $0.encodingClient = fs.client } operation: {
      try command.run()
    }

    expectNoDifference(String(data: fs.storage[input]!, encoding: .utf8), Fixtures.utf8Text)
  }

  @Test func throwsValidationErrorWhenInputCannotBeRead() {
    let input = URL(fileURLWithPath: "/tmp/missing.txt")
    let fs = TestFileSystem(storage: [:], readError: TestFileError.missing(input))
    let command = FixEncoding(inputPath: input.path)

    withDependencies { $0.encodingClient = fs.client } operation: {
      #expect(throws: ValidationError.self) { try command.run() }
    }
  }

  @Test func fixesCommittedDemoFile() throws {
    let repoRoot = URL(fileURLWithPath: #filePath)
      .deletingLastPathComponent()
      .deletingLastPathComponent()
      .deletingLastPathComponent()
    let input = repoRoot.appendingPathComponent("DemoBroken.txt")

    let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
    defer { try? FileManager.default.removeItem(at: dir) }
    let output = dir.appendingPathComponent("demo-fixed.txt")

    try withDependencies { $0.encodingClient = .live } operation: {
      try FixEncoding(inputPath: input.path, output: output.path).run()
    }

    let fixed = try String(contentsOf: output, encoding: .utf8)
    #expect(fixed.hasPrefix("#include <iostream>"))
    #expect(fixed.contains("Конец"))
  }
}
