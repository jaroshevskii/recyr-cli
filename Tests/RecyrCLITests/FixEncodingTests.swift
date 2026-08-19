import ArgumentParser
import CustomDump
import Dependencies
import Foundation
import RecyrCLI
import RecyrTestSupport
import Testing

@testable import RecyrCore

@Suite("FixEncoding")
struct FixEncodingTests {
  @Test func exposesConfiguration() {
    #expect(FixEncoding.configuration.abstract.contains("Cyrillic"))
    _ = FixEncoding()
  }

  @Test func writesOutputFile() async throws {
    let input = URL(fileURLWithPath: "/tmp/input.txt")
    let output = URL(fileURLWithPath: "/tmp/output.txt")
    let fs = TestFileSystem(storage: [input: Fixtures.cp1251Cyrillic])

    try await withDependencies {
      $0.encodingClient = fs.client
    } operation: {
      try await FixEncoding(inputPath: input.path, output: output.path).run()
    }

    expectNoDifference(String(data: fs.storage[output]!, encoding: .utf8), Fixtures.utf8Text)
    expectNoDifference(fs.storage[input], Fixtures.cp1251Cyrillic)
  }

  @Test func overwritesInputInPlaceWhenNoOutputProvided() async throws {
    let input = URL(fileURLWithPath: "/tmp/input.txt")
    let fs = TestFileSystem(storage: [input: Fixtures.cp1251Cyrillic])

    try await withDependencies {
      $0.encodingClient = fs.client
    } operation: {
      try await FixEncoding(inputPath: input.path).run()
    }

    expectNoDifference(String(data: fs.storage[input]!, encoding: .utf8), Fixtures.utf8Text)
  }

  @Test func throwsValidationErrorWhenInputCannotBeRead() async throws {
    let input = URL(fileURLWithPath: "/tmp/missing.txt")
    let fs = TestFileSystem(storage: [:], readError: TestFileError.missing(input))

    await withDependencies {
      $0.encodingClient = fs.client
    } operation: {
      do {
        try await FixEncoding(inputPath: input.path).run()
        Issue.record("Expected ValidationError")
      } catch is ValidationError {
      } catch {
        Issue.record("Unexpected error: \(error)")
      }
    }
  }

  @Test func fixesCommittedDemoFile() async throws {
    let repoRoot = URL(fileURLWithPath: #filePath)
      .deletingLastPathComponent()
      .deletingLastPathComponent()
      .deletingLastPathComponent()
    let input = repoRoot.appendingPathComponent("DemoBroken.txt")

    let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
    defer { try? FileManager.default.removeItem(at: dir) }
    let output = dir.appendingPathComponent("demo-fixed.txt")

    try await withDependencies {
      $0.encodingClient = .live
    } operation: {
      try await FixEncoding(inputPath: input.path, output: output.path).run()
    }

    let fixed = try String(contentsOf: output, encoding: .utf8)
    #expect(fixed.hasPrefix("#include <iostream>"))
    #expect(fixed.contains("Конец"))
  }
}
