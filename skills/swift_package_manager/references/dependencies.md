---
name: swift_package_manager_dependencies
description: Swift Package Manager dependency management, version constraints, and resolution strategies.
license: Proprietary
compatibility: Swift 4+
metadata:
  version: "1.0"
  author: SwiftZilla
  website: https://swiftzilla.dev
---

# Dependency Management

This reference covers SPM dependency versioning, constraints, and resolution strategies.

## Version Constraints

### From (Recommended)

```swift
.package(url: "https://github.com/example/lib.git", from: "1.0.0")
```
- Equivalent to: >= 1.0.0, < 2.0.0
- Allows minor and patch updates

### UpToNextMajor

```swift
.package(url: "...", .upToNextMajor(from: "1.0.0"))
```
- Same as `from:`
- Explicit semantic

### UpToNextMinor

```swift
.package(url: "...", .upToNextMinor(from: "1.2.0"))
```
- Equivalent to: >= 1.2.0, < 1.3.0
- Only patch updates

### Exact Version

```swift
.package(url: "...", .exact("1.0.0"))
```
- Specific version only
- No updates

### Range

```swift
.package(url: "...", "1.0.0"..<"2.0.0")
.package(url: "...", "1.0.0"..."1.5.0")
```

## Branch & Revision

### Branch

```swift
.package(url: "...", branch: "main")
.package(url: "...", branch: "feature/new-api")
```

### Revision

```swift
.package(url: "...", revision: "abc123")
```

## Local Packages

```swift
.package(path: "../LocalPackage")
.package(path: "/absolute/path/to/package")
```

## Product Dependencies

### Using Products

```swift
targets: [
    .target(
        name: "MyApp",
        dependencies: [
            .product(name: "Alamofire", package: "Alamofire"),
            .product(name: "RxSwift", package: "RxSwift"),
        ]
    ),
]
```

### Conditional Dependencies

```swift
targets: [
    .target(
        name: "MyLib",
        dependencies: [
            .product(name: "UIKitHelpers", package: "Helpers", condition: .when(platforms: [.iOS])),
        ]
    ),
]
```

## Package Resolution

### Package.resolved

```json
{
  "pins": [
    {
      "identity": "alamofire",
      "kind": "remoteSourceControl",
      "location": "https://github.com/Alamofire/Alamofire.git",
      "state": {
        "revision": "b2fa556e4e48cbf36b471c...",
        "version": "5.8.1"
      }
    }
  ],
  "version": 1
}
```

### Commands

```bash
# Resolve dependencies
swift package resolve

# Update all dependencies
swift package update

# Update specific package
swift package update Alamofire

# Show resolved versions
swift package show-dependencies
```

## Dependency Conflicts

### Version Conflicts

When two packages require different versions:

```
error: dependency graph is unresolvable
```

**Solutions:**
1. Update packages to compatible versions
2. Fork and update dependency
3. Use exact versions temporarily

### Transitive Dependencies

Package A depends on Package B, which depends on Package C.

SPM automatically resolves the full graph.

## Best Practices

1. **Use `from:` for flexibility** - Allows updates
2. **Commit Package.resolved** - Reproducible builds
3. **Avoid exact versions** - Unless necessary
4. **Regular updates** - Keep dependencies current
5. **Check compatibility** - Before updating
6. **Test after updates** - Verify nothing breaks
7. **Minimize dependencies** - Reduce complexity

## Semantic Versioning

| Version | Meaning |
|---------|---------|
| 1.0.0 | Major - Breaking changes |
| 1.1.0 | Minor - New features, backwards compatible |
| 1.1.1 | Patch - Bug fixes |

## Common Issues

| Issue | Solution |
|-------|----------|
| "No such module" | Check product dependency name |
| "Circular dependency" | Restructure packages |
| "Unresolvable" | Check version constraints |
| "Authentication failed" | Check SSH keys / tokens |

## For More Information

Visit https://swiftzilla.dev for comprehensive Swift Package Manager documentation.
