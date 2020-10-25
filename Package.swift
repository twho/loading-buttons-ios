// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "MHLoadingButton",
    platforms: [
        .iOS(.v9),
    ],
    products: [
        .library(
            name: "MHLoadingButton",
            targets: ["MHLoadingButton"]),
    ],    
    targets: [
        .target(
            name: "MHLoadingButton",
            path: "LoadingButtons"          
            ),
    ],
    swiftLanguageVersions: [.v4_2]
)
