// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "CareDriverPackages",
  platforms: [
    .iOS(.v17),
  ],
  products: [
    .library(
      name: "ApiClient",
      targets: ["ApiClient"]
    ),
    .library(
      name: "ConfirmationAlert",
      targets: ["ConfirmationAlert"]
    ),
    .library(
      name: "Models",
      targets: ["Models"]
    ),
    .library(
      name: "MyRidesFeature",
      targets: ["MyRidesFeature"]
    ),
    .library(
      name: "StyleSheet",
      targets: ["StyleSheet"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1")),
  ],
  targets: [
    .target(
      name: "ApiClient",
      dependencies: ["Models"]
    ),
    .testTarget(
      name: "ApiClientTests",
      dependencies: ["ApiClient"]
    ),
    .target(
      name: "ConfirmationAlert",
      dependencies: ["StyleSheet", "SnapKit"]
    ),
    .target(
      name: "Models"),
    .testTarget(
      name: "ModelsTests",
      dependencies: ["Models"]
    ),
    .target(
      name: "MyRidesFeature",
      dependencies: ["ApiClient", "ConfirmationAlert", "Models", "StyleSheet", "SnapKit"]
    ),
    .testTarget(
      name: "MyRidesFeatureTests",
      dependencies: ["MyRidesFeature"]
    ),
    .target(
      name: "StyleSheet"
    ),
  ]
)

for target in package.targets {
  var settings = target.swiftSettings ?? []
  settings.append(.enableExperimentalFeature("StrictConcurrency"))
  target.swiftSettings = settings
}
