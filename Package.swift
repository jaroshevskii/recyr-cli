// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "RecyrCLI",
  platforms: [
    .macOS(.v13),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser", from: "1.6.2"),
    .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.0.0"),
    .package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay", from: "1.0.0"),
    .package(url: "https://github.com/pointfreeco/swift-custom-dump", from: "1.0.0"),
  ],
  targets: [
    .target(
      name: "RecyrCore",
      dependencies: [
        .product(name: "Dependencies", package: "swift-dependencies"),
        .product(name: "DependenciesMacros", package: "swift-dependencies"),
        .product(name: "IssueReporting", package: "xctest-dynamic-overlay"),
      ]
    ),
    .executableTarget(
      name: "RecyrCLI",
      dependencies: [
        "RecyrCore",
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
      ]
    ),
    .target(
      name: "RecyrTestSupport",
      dependencies: ["RecyrCore"]
    ),
    .testTarget(
      name: "RecyrCoreTests",
      dependencies: [
        "RecyrCore",
        "RecyrTestSupport",
        .product(name: "CustomDump", package: "swift-custom-dump"),
        .product(name: "IssueReportingTestSupport", package: "xctest-dynamic-overlay"),
      ]
    ),
    .testTarget(
      name: "RecyrCLITests",
      dependencies: [
        "RecyrCLI",
        "RecyrTestSupport",
        .product(name: "CustomDump", package: "swift-custom-dump"),
      ]
    ),
  ]
)
