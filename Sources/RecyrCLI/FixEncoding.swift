import ArgumentParser
import Foundation
import RecyrCore

public struct FixEncoding: AsyncParsableCommand {
  public static let configuration = CommandConfiguration(
    abstract: "Fix broken Cyrillic symbols caused by wrong encoding (e.g. Windows-1251 → UTF-8)."
  )

  @Argument(help: "Path to the input file.")
  var inputPath: String

  @Option(
    name: .shortAndLong,
    help: "Optional output path. If not provided, the input file will be overwritten.")
  var output: String?

  public init() {}

  public init(inputPath: String, output: String? = nil) {
    self.inputPath = inputPath
    self.output = output
  }

  public func run() async throws {
    let inputURL = URL(fileURLWithPath: inputPath)
    let outputURL = output.map { URL(fileURLWithPath: $0) } ?? inputURL

    do {
      try EncodingFixer.fix(input: inputURL, output: outputURL)
    } catch {
      throw ValidationError(error.localizedDescription)
    }

    print("Encoding fixed successfully!")
    print("Saved to: \(outputURL.path)")
  }
}
