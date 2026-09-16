// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "PlantOrganizer",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "PlantOrganizer",
            targets: ["PlantOrganizer"]
        ),
    ],
    targets: [
        .target(
            name: "PlantOrganizer",
            path: "Sources/PlantOrganizer"
        ),
    ]
)
