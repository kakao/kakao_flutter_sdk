// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "kakao_flutter_sdk_auth",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "kakao-flutter-sdk-auth", targets: ["kakao_flutter_sdk_auth"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "kakao_flutter_sdk_auth",
            dependencies: [],
            resources: [
                .process("Resources")
            ]
        )
    ]
)
