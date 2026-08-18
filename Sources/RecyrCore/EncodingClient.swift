import Dependencies
import DependenciesMacros
import Foundation

/// Injectable file I/O and Windows-1251 decoding, described as closures so it can be
/// swapped for an in-memory fake during testing.
@DependencyClient
public struct EncodingClient: Sendable {
  public var read: @Sendable (URL) throws -> Data
  public var write: @Sendable (Data, URL) throws -> Void
  public var decodeCP1251: @Sendable (Data) -> String? = { _ in nil }
}

extension EncodingClient {
  /// The production implementation backed by the real file system.
  public static let live = EncodingClient(
    read: { url in try Data(contentsOf: url) },
    write: { data, url in try data.write(to: url, options: .atomic) },
    decodeCP1251: { data in String(data: data, encoding: .windowsCP1251) }
  )
}

extension DependencyValues {
  @DependencyEntry(liveValue: EncodingClient.live)
  public var encodingClient: EncodingClient
}
