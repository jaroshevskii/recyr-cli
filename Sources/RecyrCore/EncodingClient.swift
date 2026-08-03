import Dependencies
import Foundation

struct EncodingClient: Sendable {
  var read: @Sendable (URL) throws -> Data
  var write: @Sendable (Data, URL) throws -> Void
  var decodeCP1251: @Sendable (Data) -> String?
}

extension EncodingClient {
  static let live = EncodingClient(
    read: { url in try Data(contentsOf: url) },
    write: { data, url in try data.write(to: url, options: .atomic) },
    decodeCP1251: { data in String(data: data, encoding: .windowsCP1251) }
  )
}

enum EncodingClientKey: DependencyKey {
  static var liveValue: EncodingClient {
    EncodingClient.live
  }
}

extension DependencyValues {
  var encodingClient: EncodingClient {
    get { self[EncodingClientKey.self] }
    set { self[EncodingClientKey.self] = newValue }
  }
}