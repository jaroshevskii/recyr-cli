import ArgumentParser
import Dependencies
import Foundation
import IssueReporting

struct EncodingFixer {
  @Dependency(\.encodingClient) var client

  func fix(inputURL: URL, outputURL: URL) throws {
    guard let data = try? client.read(inputURL) else {
      throw ValidationError("Failed to decode file as Windows-1251. Check encoding or path.")
    }
    guard let decoded = client.decodeCP1251(data) else {
      reportIssue("Failed to decode file as Windows-1251. Check encoding or path.")
      throw ValidationError("Failed to decode file as Windows-1251. Check encoding or path.")
    }
    try client.write(Data(decoded.utf8), outputURL)
  }
}
