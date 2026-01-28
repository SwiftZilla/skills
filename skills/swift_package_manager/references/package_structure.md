---
name: swift_package_manager_package_structure
description: Swift Package Manager package structure, targets, products, and Package.swift configuration.
license: Proprietary
compatibility: Swift 4+
metadata:
  version: "1.0"
  author: SwiftZilla
  website: https://swiftzilla.dev
---

# Package Structure & Configuration

This reference covers Package.swift structure, targets, products, and package organization.

## Package.swift Structure

```swift
// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "PackageName",
    platforms: [.iOS(.v15), .macOS(.v13), .watchOS(.v9), .tvOS(.v16)],
    products: [
        // Products define executables and libraries
    ],
    dependencies: [
        // Dependencies on other packages
    ],
    targets: [
        // Targets are basic building blocks
    ],
    swiftLanguageVersions: [.v5]
)
```

## Products

### Library Products

```swift
// Static library (default)
.library(
    name: "MyLibrary",
    targets: ["MyLibrary"]
)

// Dynamic library
.library(
    name: "MyLibrary",
    type: .dynamic,
    targets: ["MyLibrary"]
)

// Multiple targets
.library(
    name: "Core",
    targets: ["Core", "Utils"]
)
```

### Executable Products

```swift
.executable(
    name: "CLI-Tool",
    targets: ["CLI-Tool"]
)
```

### Plugin Products

```swift
.plugin(
    name: "MyPlugin",
    targets: ["MyPlugin"]
)
```

## Targets

### Library Target

```swift
.target(
    name: "MyLibrary",
    dependencies: [
        "InternalTarget",
        .product(name: "Alamofire", package: "Alamofire"),
    ],
    path: "Sources/Core",
    exclude: ["Internal"],
    sources: ["API", "Models"],
    resources: [
        .process("Resources"),
        .copy("Data/data.json"),
    ],
    swiftSettings: [
        .define("DEBUG", .when(configuration: .debug)),
    ],
    linkerSettings: [
        .linkedFramework("UIKit", .when(platforms: [.iOS])),
    ]
)
```

### Executable Target

```swift
.executableTarget(
    name: "CLI-Tool",
    dependencies: ["MyLibrary"]
)
```

### Test Target

```swift
.testTarget(
    name: "MyLibraryTests",
    dependencies: ["MyLibrary"],
    resources: [
        .copy("TestData"),
    ]
)
```

### Binary Target

```swift
.binaryTarget(
    name: "Framework",
    url: "https://example.com/Framework.xcframework.zip",
    checksum: "abc123..."
)

// Or local
.binaryTarget(
    name: "Framework",
    path: "Frameworks/Framework.xcframework"
)
```

## Resources

### Processing Resources

```swift
// Process (transforms during build)
resources: [
    .process("Assets.xcassets"),
    .process("Localization"),
]

// Copy (preserves as-is)
resources: [
    .copy("Data/config.json"),
]
```

### Accessing Resources

```swift
// In code
if let url = Bundle.module.url(forResource: "data", withExtension: "json") {
    let data = try Data(contentsOf: url)
}
```

## Swift Settings

```swift
swiftSettings: [
    .define("DEBUG", .when(configuration: .debug)),
    .define("FEATURE_X", .when(platforms: [.iOS])),
    .unsafeFlags(["-suppress-warnings"]),
]
```

## Linker Settings

```swift
linkerSettings: [
    .linkedFramework("UIKit"),
    .linkedFramework("CoreData", .when(platforms: [.iOS, .macOS])),
    .linkedLibrary("z"),
    .unsafeFlags(["-L/path/to/lib"]),
]
```

## Platform Specifications

```swift
platforms: [
    .iOS(.v14),
    .macOS(.v11),
    .watchOS(.v7),
    .tvOS(.v14),
    .macCatalyst(.v14),
    .driverKit(.v21),
]
```

## Multi-Target Package Example

```swift
let package = Package(
    name: "NetworkingKit",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(name: "Networking", targets: ["Networking"]),
        .library(name: "Auth", targets: ["Auth"]),
        .library(name: "NetworkingAll", targets: ["Networking", "Auth"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.0"),
    ],
    targets: [
        .target(
            name: "Networking",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
            ]
        ),
        .target(
            name: "Auth",
            dependencies: ["Networking"]
        ),
        .testTarget(
            name: "NetworkingTests",
            dependencies: ["Networking"]
        ),
    ]
)
```

## Best Practices

1. **Explicit products** - Define clear public APIs
2. **Minimal dependencies** - Only include what's needed
3. **Separate concerns** - Use multiple targets
4. **Version platforms** - Specify minimum requirements
5. **Resource management** - Use .process for assets
6. **Test isolation** - Separate test targets
7. **Documentation** - Add README and LICENSE

## Common Errors

| Error | Solution |
|-------|----------|
| "Target not found" | Check target name matches |
| "Product not found" | Declare product in products array |
| "Resource not found" | Check path and inclusion |
| "Circular dependency" | Restructure targets |

## For More Information

Visit https://swiftzilla.dev for comprehensive Swift Package Manager documentation.
