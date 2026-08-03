# 🌋 Recyr CLI

[![CI](https://github.com/jaroshevskii/recyr-cli/actions/workflows/ci.yml/badge.svg)](https://github.com/jaroshevskii/recyr-cli/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/jaroshevskii/recyr-cli/branch/main/graph/badge.svg?token=)](https://codecov.io/gh/jaroshevskii/recyr-cli)
[![Swift](https://img.shields.io/badge/Swift-6.2-F05138?logo=swift&logoColor=white)](https://www.swift.org)
[![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey)](https://github.com/jaroshevskii/recyr-cli)

**Recyr CLI** is a lightweight, modern CLI tool for fixing broken Cyrillic text caused by incorrect encodings (e.g., Windows-1251 opened as UTF-8). Quickly convert your files back to proper UTF-8 and restore readable text.

## 🚀 Features

- Automatically detect and fix Windows-1251 encoded files.
- Overwrite the original file or save to a new path.
- Simple CLI interface powered by Swift ArgumentParser.
- Cross-platform support (macOS, Linux).

## 💻 Installation

### Build from source

```zsh
git clone https://github.com/jaroshevskii/RecyrCLI.git
cd ReCyrillic
swift build -c release
```

### Make globally available (optional)

```zsh
sudo cp ./.build/release/RecyrCLI /usr/local/bin/recyr
```

Now you can run it from anywhere:

```zsh
recyr DemoBroken.txt
```

## ⚡ Usage

```zsh
# Fix a file and overwrite it
recyr path/to/file.txt

# Fix a file and save output to a new file
recyr path/to/file.txt --output fixed.txt
```

Example

```zsh
recyr DemoBroken.txt --output demo-fixed.txt
```

After running, demo-fixed.txt will contain correctly encoded UTF-8 text.

## 🧪 Demo file

You can test the tool with DemoBroken.txt provided in the repository. It contains intentionally broken Cyrillic text saved as Windows-1251.

## ⚙️ Swift Package

This project is built as a Swift Package:
- Dependency: `swift-argument-parser`
- Swift 6 compatible
- Executable target: RecyrCLI

## 📝 Contribution

Contributions are welcome! Feel free to submit issues, feature requests, or pull requests.


## 📄 License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE.md) file for details.
