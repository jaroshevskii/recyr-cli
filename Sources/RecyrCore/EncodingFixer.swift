import Dependencies
import Foundation
import IssueReporting

/// Orchestrates the fix: reads input, decodes CP1251, and writes UTF-8 output.
public struct EncodingFixer {
  @Dependency(\.encodingClient) var client

  public init() {}

  /// Reads `inputURL`, converts Windows-1251 content to UTF-8, and writes the result to `outputURL`.
  public func fix(inputURL: URL, outputURL: URL) throws(EncodingError) {
    let data: Data
    do {
      data = try client.read(url: inputURL)
    } catch {
      throw EncodingError.cannotRead(inputURL)
    }

    guard let decoded = client.decodeCP1251(data) else {
      reportIssue("Failed to decode file as Windows-1251: \(inputURL.path)")
      throw EncodingError.notCP1251(inputURL)
    }

    do {
      try client.write(data: Data(decoded.utf8), url: outputURL)
    } catch {
      throw EncodingError.cannotWrite(outputURL)
    }
  }
}
