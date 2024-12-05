// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "MacSpeechApp",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "MacSpeechApp",
            targets: ["MacSpeechApp"]
        )
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "MacSpeechApp",
            dependencies: [],
            path: "Sources",
            resources: [
                .copy("../Resources")
            ],
            swiftSettings: [
                .unsafeFlags(["-Xlinker", "-rpath", "-Xlinker", "@executable_path/../Frameworks"])
            ]
        )
    ]
) 