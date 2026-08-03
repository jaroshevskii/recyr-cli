import ArgumentParser
import CustomDump
import Dependencies
import Foundation
import Testing
@testable import RecyrCore

@Suite("EncodingFixer")
struct EncodingFixerTests {
  @Test func convertsCP1251DataToUTF8AtOutputURL() throws {
    let input = URL(fileURLWithPath: "/in.txt")
    let output = URL(fileURLWithPath: "/out.txt")
    let fs = TestFileSystem(storage: [input: Fixtures.cp1251Cyrillic])

    try withDependencies { $0.encodingClient = fs.client } operation: {
      try EncodingFixer().fix(inputURL: input, outputURL: output)
    }

    expectNoDifference(String(data: fs.storage[output]!, encoding: .utf8), Fixtures.utf8Text)
    expectNoDifference(fs.storage[input], Fixtures.cp1251Cyrillic)
  }

  @Test func overwritesExistingOutputFile() throws {
    let input = URL(fileURLWithPath: "/in.txt")
    let output = URL(fileURLWithPath: "/out.txt")
    let fs = TestFileSystem(storage: [input: Fixtures.cp1251Cyrillic, output: Data("old".utf8)])

    try withDependencies { $0.encodingClient = fs.client } operation: {
      try EncodingFixer().fix(inputURL: input, outputURL: output)
    }

    expectNoDifference(String(data: fs.storage[output]!, encoding: .utf8), Fixtures.utf8Text)
  }

  @Test func fixesInputInPlace() throws {
    let input = URL(fileURLWithPath: "/in.txt")
    let fs = TestFileSystem(storage: [input: Fixtures.cp1251Cyrillic])

    try withDependencies { $0.encodingClient = fs.client } operation: {
      try EncodingFixer().fix(inputURL: input, outputURL: input)
    }

    expectNoDifference(String(data: fs.storage[input]!, encoding: .utf8), Fixtures.utf8Text)
  }

  @Test func throwsWhenInputCannotBeRead() {
    let input = URL(fileURLWithPath: "/missing.txt")
    let fs = TestFileSystem(storage: [:], readError: TestFileError.missing(input))

    #expect(throws: ValidationError.self) {
      try withDependencies { $0.encodingClient = fs.client } operation: {
        try EncodingFixer().fix(inputURL: input, outputURL: URL(fileURLWithPath: "/out.txt"))
      }
    }
  }

  @Test func reportsIssueAndThrowsWhenDataIsNotDecodable() {
    let input = URL(fileURLWithPath: "/in.txt")
    let fs = TestFileSystem(storage: [input: Data("raw".utf8)], forceUndecodable: true)

    withKnownIssue {
      #expect(throws: ValidationError.self) {
        try withDependencies { $0.encodingClient = fs.client } operation: {
          try EncodingFixer().fix(inputURL: input, outputURL: URL(fileURLWithPath: "/out.txt"))
        }
      }
    }
  }

  @Test func throwsWhenWriteFails() {
    let input = URL(fileURLWithPath: "/in.txt")
    let fs = TestFileSystem(storage: [input: Fixtures.cp1251Cyrillic], writeError: TestFileError.write)

    #expect(throws: TestFileError.self) {
      try withDependencies { $0.encodingClient = fs.client } operation: {
        try EncodingFixer().fix(inputURL: input, outputURL: URL(fileURLWithPath: "/out.txt"))
      }
    }
  }

  @Test func usesLiveFileSystem() throws {
    let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
    defer { try? FileManager.default.removeItem(at: dir) }

    let input = dir.appendingPathComponent("in.txt")
    let output = dir.appendingPathComponent("out.txt")
    try Fixtures.cp1251Cyrillic.write(to: input)

    try withDependencies { $0.encodingClient = .live } operation: {
      try EncodingFixer().fix(inputURL: input, outputURL: output)
    }

    let outputData = try Data(contentsOf: output)
    expectNoDifference(String(data: outputData, encoding: .utf8), Fixtures.utf8Text)
  }

  @Test func defaultLiveClientIsFunctional() throws {
    let live = EncodingClientKey.liveValue

    expectNoDifference(
      live.decodeCP1251(Fixtures.cp1251Cyrillic),
      Fixtures.utf8Text
    )

    let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
    defer { try? FileManager.default.removeItem(at: dir) }
    let url = dir.appendingPathComponent("file.txt")
    let utf8Data = Data(Fixtures.utf8Text.utf8)

    try live.write(utf8Data, url)
    expectNoDifference(try live.read(url), utf8Data)
  }
}
