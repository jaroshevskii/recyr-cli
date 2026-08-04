import Foundation
import RecyrCore

public enum TestFileError: Error, Sendable {
  case missing(URL)
  case write
}

public final class TestFileSystem: @unchecked Sendable {
  public var storage: [URL: Data]
  public var readError: (any Error & Sendable)?
  public var writeError: (any Error & Sendable)?
  public var forceUndecodable = false

  public init(
    storage: [URL: Data] = [:],
    readError: (any Error & Sendable)? = nil,
    writeError: (any Error & Sendable)? = nil,
    forceUndecodable: Bool = false
  ) {
    self.storage = storage
    self.readError = readError
    self.writeError = writeError
    self.forceUndecodable = forceUndecodable
  }

  public var client: EncodingClient {
    EncodingClient(
      read: { [self] url in
        if let readError { throw readError }
        guard let data = storage[url] else { throw TestFileError.missing(url) }
        return data
      },
      write: { [self] data, url in
        if let writeError { throw writeError }
        storage[url] = data
      },
      decodeCP1251: { [self] data in
        if forceUndecodable { return nil }
        return String(data: data, encoding: .windowsCP1251)
      }
    )
  }
}
