import Dependencies
import Foundation

/// Injectable file I/O and Windows-1251 decoding, described as closures so it can be
/// swapped for an in-memory fake during testing.
public struct EncodingClient: Sendable {
  /// Reads raw bytes from a file.
  public var read: @Sendable (URL) throws -> Data
  /// Writes data, atomically, to a file.
  public var write: @Sendable (Data, URL) throws -> Void
  /// Decodes bytes as Windows-1251, returning `nil` if decoding fails.
  public var decodeCP1251: @Sendable (Data) -> String?

  public init(
    read: @escaping @Sendable (URL) throws -> Data,
    write: @escaping @Sendable (Data, URL) throws -> Void,
    decodeCP1251: @escaping @Sendable (Data) -> String?
  ) {
    self.read = read
    self.write = write
    self.decodeCP1251 = decodeCP1251
  }
}

extension EncodingClient {
  /// The production implementation backed by the real file system.
  public static let live = EncodingClient(
    read: { url in try Data(contentsOf: url) },
    write: { data, url in try data.write(to: url, options: .atomic) },
    decodeCP1251: { data in String(data: data, encoding: .windowsCP1251) }
  )
}

/// The ``DependencyKey`` that registers ``EncodingClient`` with `swift-dependencies`.
public enum EncodingClientKey: DependencyKey {
  public static var liveValue: EncodingClient {
    EncodingClient.live
  }
}

extension DependencyValues {
  public var encodingClient: EncodingClient {
    get { self[EncodingClientKey.self] }
    set { self[EncodingClientKey.self] = newValue }
  }
}