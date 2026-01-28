---
name: swift_package_manager_publishing
description: Publishing Swift packages to GitHub, GitLab, and Swift Package Index.
license: Proprietary
compatibility: Swift 4+
metadata:
  version: "1.0"
  author: SwiftZilla
  website: https://swiftzilla.dev
---

# Publishing Packages

This reference covers publishing Swift packages to GitHub, registries, and best practices for distribution.

## Preparing for Publication

### Required Files

```
MyPackage/
├── Package.swift
├── README.md          # Required
├── LICENSE            # Required for open source
├── Sources/
└── Tests/
```

### README.md Template

```markdown
# MyPackage

Short description of what the package does.

## Installation

Add to Package.swift:
\`\`\`swift
dependencies: [
    .package(url: "https://github.com/username/MyPackage.git", from: "1.0.0")
]
\`\`\`

## Usage

\`\`\`swift
import MyPackage

// Example code
\`\`\`

## Requirements

- iOS 15.0+
- macOS 12.0+
- Swift 5.9+

## License

MIT
```

### LICENSE

Common licenses for Swift packages:
- MIT (most permissive)
- Apache 2.0
- BSD

## Version Tagging

### Semantic Versioning

```bash
# Create version tag
git tag 1.0.0
git push origin 1.0.0

# Or with message
git tag -a 1.0.0 -m "Initial release"
git push origin 1.0.0
```

### Pre-release Versions

```bash
# Beta
git tag 1.0.0-beta.1

# Release Candidate
git tag 1.0.0-rc.1
```

## GitHub Publishing

### Steps

1. **Create repository**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/username/MyPackage.git
   git push -u origin main
   ```

2. **Add topics**
   - Go to repository settings
   - Add topics: `swift`, `swift-package`, `ios`, etc.

3. **Create release**
   - Go to Releases tab
   - Click "Draft new release"
   - Choose tag or create new
   - Add release notes

### Release Notes Template

```markdown
## What's New

### Features
- Added X functionality
- Improved Y performance

### Bug Fixes
- Fixed Z issue

### Breaking Changes
- Changed API from A to B

## Migration Guide

Update your Package.swift:
\`\`\`swift
.package(url: "...", from: "2.0.0")
\`\`\`
```

## Swift Package Index

### Adding Your Package

1. Go to https://swiftpackageindex.com/add-a-package
2. Enter GitHub repository URL
3. Follow validation steps

### Requirements

- Public GitHub repository
- Valid Package.swift
- Semantic version tags
- Swift tools version specified

## Binary Targets

### XCFramework

```bash
# Build XCFramework
xcodebuild -create-xcframework \
    -framework MyFramework.framework \
    -output MyFramework.xcframework

# Zip for distribution
zip -r MyFramework.xcframework.zip MyFramework.xcframework

# Calculate checksum
swift package compute-checksum MyFramework.xcframework.zip
```

### Package.swift with Binary

```swift
.binaryTarget(
    name: "MyBinary",
    url: "https://example.com/MyBinary.xcframework.zip",
    checksum: "abc123..."
)
```

## Documentation

### DocC

```swift
/// A network manager for API requests
///
/// Use `NetworkManager` to make HTTP requests:
///
/// ```swift
/// let manager = NetworkManager()
/// let data = try await manager.fetch(url)
/// ```
public class NetworkManager {
    // ...
}
```

### Hosting Documentation

```bash
# Generate documentation
swift build --target MyPackage
swift package generate-documentation

# Or use DocC
xcrun docc convert MyPackage.docc \
    --fallback-display-name MyPackage \
    --fallback-bundle-identifier com.example.MyPackage \
    --output-dir docs
```

## Best Practices

1. **Use semantic versioning** - Follow SemVer strictly
2. **Write good README** - Clear usage examples
3. **Add LICENSE** - Required for open source
4. **Document public API** - Use DocC comments
5. **Test thoroughly** - Include test targets
6. **Platform support** - Declare minimum versions
7. **Regular updates** - Keep dependencies current
8. **Changelog** - Document all changes
9. **Version tags** - Always tag releases
10. **Compatibility** - Test on all platforms

## Version Strategy

| Situation | Version |
|-----------|---------|
| Bug fixes | Patch (1.0.1) |
| New features | Minor (1.1.0) |
| Breaking changes | Major (2.0.0) |
| Pre-release | 1.0.0-beta.1 |

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| No LICENSE | Add LICENSE file |
| Missing README | Create comprehensive README |
| No version tags | Use git tags |
| Wrong tools version | Update Package.swift header |
| Private repository | Make public or use alternative |

## For More Information

- Swift Package Index: https://swiftpackageindex.com
- Swift.org: https://swift.org/package-manager/
- GitHub Docs: https://docs.github.com/en/packages
- SwiftZilla: https://swiftzilla.dev
