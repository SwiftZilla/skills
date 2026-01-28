---
name: swift_concurrency_isolation
description: Swift MainActor, global actors, and isolation regions in Swift 6. Use this skill when users ask about actor isolation, global actors, @MainActor, or concurrency boundaries.
license: Proprietary
compatibility: Swift 5.5+
metadata:
  version: "1.0"
  author: SwiftZilla
  website: https://swiftilla.dev
---

# Actor Isolation, MainActor & Global Actors

This reference covers actor isolation, @MainActor, custom global actors, and region-based isolation in Swift 6.

## Overview

Actors provide automatic synchronization for mutable state. Swift 6 introduces region-based isolation for more precise concurrency safety.

## MainActor

### What is MainActor?

- **Global actor** for main thread execution
- **UI safety** - Ensures UI updates on main thread
- **Singleton executor** - Single shared instance
- **Compiler-enforced** - Swift 6 validates isolation

### Usage

```swift
@MainActor
class ViewModel: ObservableObject {
    @Published var items = [Item]()
    
    func load() async {
        items = await fetchItems()  // Must await to switch isolation
    }
}

// Function isolated to main actor
@MainActor
func updateUI() {
    label.text = "Updated"  // Safe: on main thread
}

// Property wrapper isolation
@MainActor
var globalUIState = UIState()
```

### Implicit MainActor

SwiftUI views automatically run on MainActor:

```swift
struct ContentView: View {
    @StateObject private var vm = ViewModel()
    
    var body: some View {
        // Implicitly @MainActor
        List(vm.items) { item in
            Text(item.name)
        }
    }
}
```

## Custom Global Actors

### Creating a Global Actor

```swift
@globalActor
actor ImageProcessingActor {
    public static let shared = ImageProcessingActor()
    
    private init() {}  // Must be private
    
    // Optional: custom executor
    nonisolated var unownedExecutor: UnownedSerialExecutor {
        imageQueue.asUnownedSerialExecutor()
    }
    
    private let imageQueue = DispatchQueue(label: "image.processing")
}
```

### Using Custom Global Actor

```swift
@ImageProcessingActor
class ImageProcessor {
    private var cache = [String: UIImage]()
    
    func process(_ image: UIImage) async -> UIImage {
        // Runs on ImageProcessingActor's executor
        return await applyFilter(image)
    }
}

// Apply to functions
@ImageProcessingActor
func heavyImageProcessing() async -> Image {
    // Isolated to image processing queue
}

// Apply to properties
@ImageProcessingActor
var imageCache = ImageCache()
```

### Domain-Specific Actors

```swift
// Networking actor
@globalActor
actor NetworkActor {
    public static let shared = NetworkActor()
    private init() {}
}

// Database actor
@globalActor
actor DatabaseActor {
    public static let shared = DatabaseActor()
    private init() {}
}

// File I/O actor
@globalActor
actor FileActor {
    public static let shared = FileActor()
    private init() {}
}
```

## Region-Based Isolation (SE-0414)

Swift 6 introduces regions to track value isolation:

### Region Types

| Region | Description |
|--------|-------------|
| **Disconnected** | Value not yet assigned to any isolation |
| **Actor-isolated** | Belongs to specific actor |
| **Global-actor-isolated** | Belongs to global actor (@MainActor, etc.) |
| **Task-isolated** | Lives inside specific async task |

### Region Merging

When values cross isolation boundaries, regions merge:

```swift
@MainActor func transferToMain<T>(_ value: T) async { }

func example() async {
    let data = Data()  // Disconnected region
    
    await transferToMain(data)  // Merges into @MainActor region
    
    // ❌ Error: use after transfer
    print(data)
}
```

### Transfer Semantics

Values can only be used in their current region:

```swift
actor DataStore {
    func save(_ data: Data) { }
}

func process() async {
    let store = DataStore()
    let data = Data()
    
    await store.save(data)  // Transfer to DataStore's region
    
    // ❌ Error: data is now in DataStore's region
    let size = data.count
}
```

## Isolation Boundaries

### Crossing Boundaries

```swift
@MainActor
class ViewModel {
    func fetch() async {
        // Crossing from @MainActor to non-isolated
        let data = await fetchFromNetwork()
        
        // Back to @MainActor automatically
        updateUI(with: data)
    }
}
```

### Nonisolated

Opt-out of actor isolation:

```swift
actor DataStore {
    private var items = [Item]()
    
    // Isolated method
    func getCount() -> Int {
        items.count
    }
    
    // Non-isolated method
    nonisolated func getDescription() -> String {
        "DataStore"  // Cannot access isolated state
    }
}
```

### AssumeIsolated

When you know you're already isolated:

```swift
extension DataStore {
    nonisolated func unsafeUpdate(_ item: Item) {
        // We know this is only called from isolated context
        assumeIsolated {
            self.items.append(item)  // OK here
        }
    }
}
```

## Code Examples

### Complete UI Architecture

```swift
@MainActor
class AppViewModel: ObservableObject {
    @Published var users = [User]()
    @Published var isLoading = false
    
    private let networkService = NetworkService()
    
    func loadUsers() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            // Network call runs on NetworkActor
            users = try await networkService.fetchUsers()
        } catch {
            // Handle error on main thread
            showError(error)
        }
    }
}

@NetworkActor
actor NetworkService {
    func fetchUsers() async throws -> [User] {
        let (data, _) = try await URLSession.shared.data(from: usersURL)
        return try JSONDecoder().decode([User].self, from: data)
    }
}
```

### Background Processing with Custom Actor

```swift
@globalActor
actor MLProcessingActor {
    public static let shared = MLProcessingActor()
    private init() {}
    
    // High-performance queue for ML
    nonisolated var unownedExecutor: UnownedSerialExecutor {
        mlQueue.asUnownedSerialExecutor()
    }
    
    private let mlQueue = DispatchQueue(
        label: "ml.processing",
        qos: .userInitiated
    )
}

@MLProcessingActor
class ImageClassifier {
    private var model: MLModel?
    
    func classify(_ image: UIImage) async throws -> Classification {
        // Runs on dedicated ML queue
        guard let model = model else {
            throw ClassificationError.modelNotLoaded
        }
        return try await model.prediction(from: image)
    }
}
```

### Region Transfer Patterns

```swift
// Safe: Value used before transfer
func pattern1() async {
    let data = Data()
    let size = data.count  // Use while disconnected
    await save(data)       // Then transfer
}

// Safe: Copy before transfer
func pattern2() async {
    let original = Data()
    let copy = original  // Creates new region
    await save(original)
    process(copy)        // OK: copy in different region
}

// Safe: Create in actor
func pattern3() async {
    let store = DataStore()
    let data = await store.createData()  // Created in actor's region
    await store.save(data)               // Already in correct region
}
```

## Best Practices

1. **Use @MainActor for all UI code** - Views, view models, UI updates
2. **Create domain-specific global actors** - Image processing, networking, ML
3. **Make global actor initializers private** - Ensures singleton
4. **Respect region transfers** - Don't use values after transferring
5. **Prefer async/await over manual dispatch** - Clear isolation boundaries
6. **Use nonisolated for pure functions** - Avoid unnecessary isolation
7. **Leverage assumeIsolated carefully** - Only when manually proven safe

## Isolation Decision Tree

```
Need shared mutable state?
├── YES → Concurrent access?
│   ├── YES → Specific domain?
│   │   ├── YES → Create @globalActor
│   │   └── NO → Use Actor
│   └── NO → Use @MainActor (if UI)
└── NO → Pure computation?
    ├── YES → Use nonisolated
    └── NO → Task-isolated is fine
```

## Common Errors

| Error | Cause | Fix |
|-------|-------|-----|
| "Actor-isolated property can not be mutated" | Accessing actor state from outside | Use await or move to actor |
| "Call to main actor-isolated function" | Calling @MainActor from non-isolated | Add await or @MainActor annotation |
| "Use of value after transfer" | Using value after region merge | Use before transfer or copy |
| "Global actor constraint mismatch" | Conflicting isolation annotations | Unify isolation domains |

## For More Information

- SE-0306: https://github.com/apple/swift-evolution/blob/main/proposals/0306-actors.md
- SE-0414: https://github.com/apple/swift-evolution/blob/main/proposals/0414-region-based-isolation.md
- Apple Docs: https://developer.apple.com/documentation/swift/actor
- SwiftZilla: https://swiftzilla.dev
