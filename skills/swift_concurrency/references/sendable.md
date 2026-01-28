---
name: swift_concurrency_sendable
description: Swift Sendable protocol, @Sendable closures, and strict concurrency checking. Use this skill when users ask about Sendable conformance, thread safety, or sharing data across concurrency boundaries.
license: Proprietary
compatibility: Swift 5.5+
metadata:
  version: "1.0"
  author: SwiftZilla
  website: https://swiftzilla.dev
---

# Sendable Protocol & Strict Concurrency

This reference covers the `Sendable` protocol, `@Sendable` closures, and how they ensure thread safety in Swift concurrency.

## Overview

`Sendable` is a marker protocol indicating a type can be safely transferred across concurrency boundaries without data races. Swift 6 enforces `Sendable` strictly.

## What is Sendable?

- **Thread-safety contract** - Type can be accessed from any concurrent context
- **Compiler-enforced** - Swift 6 validates conformance
- **No required members** - Semantic protocol, no methods to implement
- **Automatic synthesis** - For structs/enums with only Sendable properties

## Sendable Conformance Rules

### Automatic Conformance

These types are automatically Sendable:

```swift
// Value types with only Sendable properties
struct User: Sendable {  // ✅ Automatically Sendable
    let id: Int
    let name: String
}

// Frozen enums
enum Status: Sendable {  // ✅ Automatically Sendable
    case pending
    case completed(Date)
    case failed(Error)
}
```

### Explicit Conformance

```swift
// Classes require explicit conformance
final class Config: Sendable {
    let apiKey: String
    let timeout: TimeInterval
    
    init(apiKey: String, timeout: TimeInterval) {
        self.apiKey = apiKey
        self.timeout = timeout
    }
}
```

### @unchecked Sendable

Use when you manually guarantee thread safety:

```swift
@unchecked Sendable final class ThreadSafeCache<T> {
    private var storage = [String: T]()
    private let lock = NSLock()
    
    func get(_ key: String) -> T? {
        lock.lock()
        defer { lock.unlock() }
        return storage[key]
    }
    
    func set(_ value: T, forKey key: String) {
        lock.lock()
        defer { lock.unlock() }
        storage[key] = value
    }
}
```

⚠️ **Use sparingly** - Only when you can prove safety manually

## @Sendable Closures

Mark closures that cross concurrency boundaries:

```swift
// Function accepting Sendable closure
func performAsync(_ operation: @Sendable () async -> Void) {
    Task {
        await operation()
    }
}

// Usage
performAsync {
    // All captured values must be Sendable
    await process(data: sendableData)
}
```

### Capturing Rules

```swift
let user = User(id: 1, name: "Ada")  // Sendable ✅
let viewController = ViewController()  // Non-Sendable ❌

// ✅ Valid: Only captures Sendable values
let safeClosure: @Sendable () -> Void = {
    print(user.name)
}

// ❌ Error: Captures non-Sendable
let unsafeClosure: @Sendable () -> Void = {
    viewController.update()  // Error!
}
```

## Swift 6 Strict Checking

### Build Settings

```bash
# Enable complete checking
SWIFT_STRICT_CONCURRENCY = complete
```

### Common Violations

**Non-Sendable capture:**
```swift
class NetworkManager {
    var activeTasks = [Task<Void, Never>]()
    
    func fetch() {
        // ❌ Error: self is not Sendable
        let task = Task {
            await self.performRequest()
        }
        activeTasks.append(task)
    }
}

// ✅ Fix: Isolate with actor
actor NetworkManager {
    private var activeTasks = [Task<Void, Never>]()
    
    func fetch() {
        let task = Task {
            await self.performRequest()  // OK: isolated
        }
        activeTasks.append(task)
    }
}
```

**Cross-actor parameter:**
```swift
actor DataStore {
    // ❌ Error: Non-Sendable parameter
    func save(_ object: NSManagedObject) { }
    
    // ✅ Fix: Sendable parameter
    func save(_ object: SendableData) { }
}
```

## Sendable with Generics

```swift
// Generic Sendable constraint
func process<T: Sendable>(item: T) async -> T {
    // Safe to transfer across boundaries
    return item
}

// Associated types
protocol Container {
    associatedtype Element: Sendable
    var items: [Element] { get }
}
```

## Sendable Collections

```swift
// Arrays of Sendable are Sendable
let numbers: [Int]  // ✅ Sendable
let users: [User]   // ✅ Sendable if User is Sendable

// Dictionaries with Sendable values
let cache: [String: Data]  // ✅ Sendable

// Optionals of Sendable are Sendable
let maybeUser: User?  // ✅ Sendable
```

## Code Examples

### Making Types Sendable

```swift
// Before: Not Sendable
class UserManager {
    var currentUser: User?
    var preferences = [String: Any]()
}

// After: Sendable
struct UserConfiguration: Sendable {
    let userId: Int
    let preferences: [String: String]
    let theme: AppTheme  // AppTheme must be Sendable
}

enum AppTheme: Sendable {
    case light
    case dark
    case system
}
```

### Actor with Sendable Types

```swift
actor UserService {
    private var users = [Int: User]()
    
    // ✅ User must be Sendable to return from actor
    func getUser(id: Int) -> User? {
        users[id]
    }
    
    // ✅ Safe: Sendable parameter
    func saveUser(_ user: User) {
        users[user.id] = user
    }
}

struct User: Sendable {
    let id: Int
    let name: String
}
```

### @Sendable in APIs

```swift
// Networking library
public class APIClient {
    public func request<T: Decodable & Sendable>(
        _ endpoint: Endpoint,
        completion: @Sendable @escaping (Result<T, Error>) -> Void
    ) {
        Task {
            do {
                let result: T = try await performRequest(endpoint)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
```

## Best Practices

1. **Design types as Sendable from start** - Easier than retrofitting
2. **Prefer value types** - Automatically Sendable when immutable
3. **Use final classes** - Required for Sendable conformance
4. **Mark closures @Sendable** - When crossing concurrency boundaries
5. **Use @unchecked sparingly** - Only with manual synchronization
6. **Leverage automatic synthesis** - Don't manually conform if automatic
7. **Check third-party libraries** - Ensure they adopt Sendable

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "Type does not conform to Sendable" | Add conformance or use @unchecked |
| "Capture of non-sendable type" | Make captured value Sendable or remove @Sendable |
| "Cannot add conformance in extension" | Must be in same file as type definition |
| "Associated type must be Sendable" | Add constraint or make type Sendable |

## Migration Checklist

- [ ] Enable `SWIFT_STRICT_CONCURRENCY = complete`
- [ ] Add `Sendable` to structs/enums where possible
- [ ] Mark classes `final` and add explicit `Sendable`
- [ ] Add `@Sendable` to closure parameters
- [ ] Fix capture list issues
- [ ] Audit @unchecked Sendable usages
- [ ] Update third-party dependencies

## For More Information

- Swift.org: https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/
- SE-0302: https://github.com/apple/swift-evolution/blob/main/proposals/0302-concurrent-value-and-concurrent-value-conformance.md
- SwiftZilla: https://swiftzilla.dev
