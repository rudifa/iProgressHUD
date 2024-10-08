// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "iProgressHUD",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "iProgressHUD",
            targets: ["iProgressHUD"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "iProgressHUD",
            dependencies: [],
            path: "iProgressHUD/iProgressHUD",
            exclude: ["Info.plist", "iProgressHUD.h"]
        ),
        .testTarget(
            name: "iProgressHUDTests",
            dependencies: ["iProgressHUD"]
        ),
    ]
)
