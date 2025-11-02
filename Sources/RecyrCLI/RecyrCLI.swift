// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import ArgumentParser

@main
struct FixEncoding: ParsableCommand {
  static let configuration = CommandConfiguration(
    abstract: "Fix broken Cyrillic symbols caused by wrong encoding (e.g. Windows-1251 → UTF-8)."
  )
  
  @Argument(help: "Path to the input file.")
  var inputPath: String
  
  @Option(name: .shortAndLong, help: "Optional output path. If not provided, the input file will be overwritten.")
  var output: String?
  
  func run() throws {
    let inputURL = URL(fileURLWithPath: inputPath)
    let outputURL = output != nil ? URL(fileURLWithPath: output!) : inputURL
    
    // Read as Windows-1251 (Cyrillic)
    guard let data = try? Data(contentsOf: inputURL),
          let decoded = String(data: data, encoding: .windowsCP1251) else {
      throw ValidationError("Failed to decode file as Windows-1251. Check encoding or path.")
    }
    
    // Rewrite as UTF-8
    try decoded.write(to: outputURL, atomically: true, encoding: .utf8)
    
    print("Encoding fixed successfully!")
    print("Saved to: \(outputURL.path)")
  }
}

extension String.Encoding {
  static let windowsCP1251 = String.Encoding(
    rawValue: CFStringConvertEncodingToNSStringEncoding(
      CFStringEncoding(CFStringEncodings.windowsCyrillic.rawValue)
    )
  )
}
