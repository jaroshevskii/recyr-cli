import Foundation

/// Errors thrown while reading, decoding, or writing a file.
public enum EncodingError: Error, Equatable {
  case cannotRead(URL)
  case notCP1251(URL)
  case cannotWrite(URL)

  public var localizedDescription: String {
    switch self {
    case let .cannotRead(url):
      return "Failed to read file at \(url.path): invalid path or permissions."
    case let .notCP1251(url):
      return "Failed to decode file at \(url.path) as Windows-1251."
    case let .cannotWrite(url):
      return "Failed to write file at \(url.path)."
    }
  }
}