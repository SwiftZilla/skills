---
name: swift_concurrency_swift6_strict_mode
description: Swift 6 strict concurrency mode, complete concurrency checking, and data race safety. Use this skill when users ask about Swift 6 migration, strict mode, or data race prevention.
license: Proprietary
compatibility: Swift 6+
metadata:
  version: "1.0"
  author: SwiftZilla
  website: https://swiftzilla.dev
---

# Swift 6 Strict Mode & Data Race Safety

This reference covers Swift 6's strict concurrency checking, which transforms potential data race warnings into compile-time errors.

## Overview

Swift 6 introduces **strict concurrency checking** as the default mode, moving from warnings to compile-time errors for concurrency violations. This eliminates data races at compile time rather than runtime.

## Concurrency Checking Levels

| Mode | Behavior | Swift Version |
|------|----------|---------------|
| **Minimal** | Only explicit `Sendable` conformances | Swift 5.x default |
| **Targeted** | Concurrency APIs + explicit `Sendable` | Swift 5.x opt-in |
| **Complete** | **All code enforced** | **Swift 6 default** |

## Swift Evolution Proposals

| Proposal | Description |
|----------|-------------|
| **SE-0412** | Strict concurrency for global variables |
| **SE-0471** | Improved Custom SerialExecutor isolation |
| **SE-0430** | `sending` parameter diagnostics |
| **SE-0414** | Region-based isolation |

## Key Features

### 1. Compile-Time Data Race Prevention

Swift 6 proves your code cannot have data races at compile time:

```swift
// ❌ ERROR in Swift 6: Concurrent access to global variable
var counter = 0

func increment() {
    counter += 1  // Data race if called from multiple threads
}
```

**Fix with Actor:**

```swift
// ✅ Safe: Actor isolates mutable state
actor Counter {
    private var value = 0
    func increment() { value += 1 }
}

let sharedCounter = Counter()
await sharedCounter.increment()  // Isolated, no data race
```

### 2. Strict Mode Diagnostics

Swift 6 turns these warnings into errors:

- Overlapping mutable access to shared state
- Non-`Sendable` values in `@Sendable` contexts  
- Global variable accesses without isolation
- `sending` parameter violations

### 3. Global Variable Safety (SE-0412)

Global mutable variables must be isolated:

```swift
// ❌ Error: Global variable not isolated
var globalState = 0

// ✅ Safe: Global isolated with actor
@MainActor var uiState = 0

// ✅ Safe: Computed global with isolation
var safeGlobal: Int {
    get { MainActor.assumeIsolated { uiState } }
}
```

### 4. Custom SerialExecutor Checking (SE-0471)

```swift
final class ImageQueueExecutor: SerialExecutor {
    private let queue = DispatchQueue(label: "image.queue")
    
    func submit(_ job: @escaping () -> Void) {
        queue.async(execute: job)
    }
    
    // Swift 6 validates isolation doesn't breach
}
```

### 5. Sending Parameters (SE-0430)

`sending` parameters become errors in Swift 6:

```swift
// ❌ Error: Non-Sendable value to sending parameter
let cont = CheckedContinuation<String>.yielding()
cont.resume(returning: nonSendableValue)

// ✅ Safe: Sendable value
cont.resume(returning: sendableValue)
```

## Migration Guide

### Step 1: Enable Swift 6 Language Mode

**Xcode:**
- Build Settings → Swift Language Version → Swift 6

**Package.swift:**
```swift
swiftSettings: [
    .swiftLanguageVersion(.v6)
]
```

### Step 2: Fix Data Race Errors

Common fixes:

1. **Wrap globals in actors**
2. **Mark types as Sendable**
3. **Use @MainActor for UI state**
4. **Add isolation annotations**

### Step 3: Module-by-Module Migration

```bash
# Enable strict checking per target
-swift-concurrency-checker=strict
```

## Code Examples

### Migrating Global State

**Before (Swift 5):**
```swift
var sharedCache = [String: Data]()

func updateCache(key: String, value: Data) {
    sharedCache[key] = value  // Warning: potential data race
}
```

**After (Swift 6):**
```swift
actor Cache {
    private var storage = [String: Data]()
    
    func update(key: String, value: Data) {
        storage[key] = value
    }
    
    func get(key: String) -> Data? {
        storage[key]
    }
}

let sharedCache = Cache()
await sharedCache.update(key: "user", value: data)
```

### Safe Concurrent Access

```swift
actor DataStore {
    private var items = [Item]()
    
    func add(_ item: Item) {
        items.append(item)
    }
    
    func remove(id: UUID) {
        items.removeAll { $0.id == id }
    }
    
    func getAll() -> [Item] {
        items
    }
}

// Usage from multiple tasks - always safe
let store = DataStore()
await withTaskGroup(of: Void.self) { group in
    for item in newItems {
        group.addTask {
            await store.add(item)
        }
    }
}
```

## Best Practices

1. **Enable Swift 6 mode early** - Don't wait for final release
2. **Use actors for shared mutable state** - Default to actors over locks
3. **Isolate global variables** - Wrap in actors or use `@MainActor`
4. **Make types Sendable** - When safe to transfer across boundaries
5. **Respect sending semantics** - Don't pass non-Sendable to sending params
6. **Test concurrent scenarios** - Verify actor isolation works correctly

## Performance

| Aspect | Impact |
|--------|--------|
| Compile time | Slightly longer (extra type-checking) |
| Runtime | **Zero overhead** - All checks at compile time |
| Binary size | No increase |
| Safety | Guaranteed data-race freedom |

## Common Errors & Fixes

| Error | Cause | Fix |
|-------|-------|-----|
| Concurrent access to global | Unprotected global var | Wrap in actor |
| Non-Sendable in @Sendable closure | Capturing non-Sendable | Make captured value Sendable |
| Actor isolation violation | Calling actor method from wrong isolation | Use await or move to same actor |
| Sending violation | Non-Sendable to sending param | Wrap or make Sendable |

## For More Information

- SE-0412: https://github.com/apple/swift-evolution/blob/main/proposals/0412-strict-concurrency-for-global-variables.md
- SE-0471: https://github.com/apple/swift-evolution/blob/main/proposals/0471-SerialExecutor-isIsolated.md
- SE-0430: https://github.com/apple/swift-evolution/blob/main/proposals/0430-sending-parameter-and-result-values.md
- Apple Docs: https://swiftzilla.dev
