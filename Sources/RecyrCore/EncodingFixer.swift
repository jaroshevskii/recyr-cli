import Dependencies
import Foundation
import IssueReporting

/// Orchestrates the fix: reads input, decodes CP1251, and writes UTF-8 output.
public struct EncodingFixer {
  @Dependency(\.encodingClient) var client

  init() {}

  /// Reads `input`, converts Windows-1251 content to UTF-8, and writes the result to `output`.
  public static func fix(input: URL, output: URL) throws(EncodingError) {
    let fixer = EncodingFixer()
    let data: Data
    do {
      data = try fixer.client.read(url: input)
    } catch {
      throw EncodingError.cannotRead(input)
    }

    guard let decoded = fixer.client.decodeCP1251(data) else {
      reportIssue("Failed to decode file as Windows-1251: \(input.path)")
      throw EncodingError.notCP1251(input)
    }

    do {
      try fixer.client.write(data: Data(decoded.utf8), url: output)
    } catch {
      throw EncodingError.cannotWrite(output)
    }
  }
}
