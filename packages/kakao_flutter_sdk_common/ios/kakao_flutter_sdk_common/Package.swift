// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "kakao_flutter_sdk_common",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "kakao-flutter-sdk-common", targets: ["kakao_flutter_sdk_common"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "kakao_flutter_sdk_common",
            dependencies: [],
            resources: [
                .process("PrivacyInfo.xcprivacy")
            ]
        )
    ]
)
