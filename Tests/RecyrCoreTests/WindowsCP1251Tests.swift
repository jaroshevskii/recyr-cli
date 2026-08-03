import CustomDump
import Foundation
import Testing
@testable import RecyrCore

@Suite("String.Encoding.windowsCP1251")
struct WindowsCP1251Tests {
  @Test func decodesKnownCP1251Bytes() {
    expectNoDifference(
      String(data: Fixtures.cp1251Cyrillic, encoding: .windowsCP1251),
      Fixtures.utf8Text
    )
  }

  @Test func mapsIndividualCharacters() {
    expectNoDifference(String(data: Data([0xC0]), encoding: .windowsCP1251), "А")
    expectNoDifference(String(data: Data([0xFF]), encoding: .windowsCP1251), "я")
  }

  @Test func roundTripsCyrillicText() {
    let data = Fixtures.utf8Text.data(using: .windowsCP1251)
    expectNoDifference(String(data: data ?? Data(), encoding: .windowsCP1251), Fixtures.utf8Text)
  }

  @Test func roundTripsASCII() {
    let text = "The quick brown fox, 123!"
    let data = text.data(using: .windowsCP1251)
    expectNoDifference(String(data: data ?? Data(), encoding: .windowsCP1251), text)
  }
}