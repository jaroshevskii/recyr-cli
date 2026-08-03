import Foundation
@testable import RecyrCore

enum TestFileError: Error, Sendable {
  case missing(URL)
  case write
}

final class TestFileSystem: @unchecked Sendable {
  var storage: [URL: Data]
  var readError: (any Error & Sendable)?
  var writeError: (any Error & Sendable)?
  var forceUndecodable = false

  init(
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

  var client: EncodingClient {
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
