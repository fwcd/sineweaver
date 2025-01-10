// swift-tools-version: 6.0

// WARNING:
// This file is automatically generated.
// Do not edit it by hand because the contents will be replaced.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "Sineweaver",
    platforms: [
        .iOS("18.0")
    ],
    products: [
        .iOSApplication(
            name: "Sineweaver",
            targets: ["AppModule"],
            bundleIdentifier: "dev.fwcd.Sineweaver",
            teamIdentifier: "SS8V8UGLY8",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .asset("AppIcon"),
            accentColor: .asset("AccentColor"),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ],
            capabilities: [
                .fileAccess(.userSelectedFiles, mode: .readWrite),
                .fileAccess(.musicFolder, mode: .readWrite)
            ],
            additionalInfoPlistContentFilePath: "Resources/CustomInfo.plist"
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: ".",
            swiftSettings: [
                .unsafeFlags(["-O"])
            ]
        )
    ],
    swiftLanguageVersions: [.version("6")]
)