// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FinanzasDaniel",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .executable(name: "FinanzasDaniel", targets: ["FinanzasDaniel"])
    ],
    targets: [
        .executableTarget(
            name: "FinanzasDaniel",
            path: "FinanzasDaniel"
        )
    ]
)
