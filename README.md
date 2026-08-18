# Recyr CLI

[![CI](https://github.com/jaroshevskii/recyr-cli/actions/workflows/ci.yml/badge.svg)](https://github.com/jaroshevskii/recyr-cli/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/jaroshevskii/recyr-cli/branch/main/graph/badge.svg?token=)](https://codecov.io/gh/jaroshevskii/recyr-cli)
[![Swift](https://img.shields.io/badge/Swift-6.2-F05138?logo=swift&logoColor=white)](https://www.swift.org)
[![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey)](https://github.com/jaroshevskii/recyr-cli)

Fix broken Cyrillic text caused by wrong encodings. Windows-1251 files opened as UTF-8 turn into garbage — Recyr converts them back to readable UTF-8.

## Quick start

```bash
git clone https://github.com/jaroshevskii/recyr-cli.git
cd recyr-cli
swift build -c release
sudo cp .build/release/RecyrCLI /usr/local/bin/recyr
```

## Usage

```bash
recyr file.txt                  # fix and overwrite
recyr file.txt --output fixed   # fix and save to new file
```

Try it with the included demo file:

```bash
recyr DemoBroken.txt --output demo-fixed.txt
```

## Contributing

Contributions are welcome. Open an issue or submit a pull request.

## License

MIT — see [LICENSE](LICENSE.md).
