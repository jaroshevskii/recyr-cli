@Metadata {
  @TechnologyRoot
}
# ``RecyrCore``

Core logic for fixing broken Cyrillic text caused by incorrect encodings (e.g. Windows-1251 opened as UTF-8).

RecyrCore is the platform-agnostic domain layer of the Recyr project. It performs the actual encoding fix while remaining free of any CLI or UI concerns, making it reusable across macOS, Linux, and future Apple platforms.

## Overview

The library is built around the **functional-core, injected-client** pattern recommended by modern Swift practices:

- ``EncodingClient`` — an injectable `struct` describing I/O (read, write) and Windows-1251 decoding as closures.
- ``EncodingFixer`` — the pure orchestration that reads input, decodes CP1251, and writes UTF-8 output.
- ``EncodingError`` — a small, `Equatable` set of domain errors.

Dependencies such as file I/O are injected (see the `swift-dependencies` library), so logic is easy to test in isolation with an in-memory ``Enc/EncodingClient``.

## Topics

### Fixing encodings

- ``EncodingFixer``
- ``EncodingError``
- ``EncodingClient``

### Supporting symbols

- ``EncodingClientKey``