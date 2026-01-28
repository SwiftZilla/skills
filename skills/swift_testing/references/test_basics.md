---
name: swift_testing_test_basics
description: Swift Testing basics including test declarations, assertions, and lifecycle.
license: Proprietary
compatibility: Swift 5.9+
metadata:
  version: "1.0"
  author: SwiftZilla
  website: https://swiftzilla.dev
---

# Test Basics

This reference covers basic test declarations, assertions, and lifecycle in Swift Testing.

## Test Declaration

### Simple Test

```swift
import Testing

@Test
func addition() {
    let result = 1 + 1
    #expect(result == 2)
}
```

### Named Test

```swift
@Test("Verify user can log in")
func login() {
    // Test implementation
}
```

### Disabled Test

```swift
@Test(.disabled("WIP: Waiting for API update"))
func newFeature() {
    // Test implementation
}

@Test(.disabled(if: !isCI))
func ciOnlyTest() {
    // Only runs in CI environment
}
```

### Conditional Test

```swift
@Test(.enabled(if: isPremiumUser))
func premiumFeature() {
    // Only runs when condition is true
}
```

## Assertions

### Basic Expectations

```swift
@Test
func basicAssertions() {
    let value = 42
    
    // Equality
    #expect(value == 42)
    
    // Inequality
    #expect(value != 0)
    
    // Comparison
    #expect(value > 0)
    #expect(value < 100)
    
    // Boolean
    #expect(value.isMultiple(of: 2))
    
    // Nil/Non-nil
    let optional: String? = "hello"
    #expect(optional != nil)
    
    // Type checking
    let anyValue: Any = "string"
    #expect(anyValue is String)
}
```

### Required Expectations

```swift
@Test
func requiredPrecondition() throws {
    // If this fails, test stops immediately
    let value = try #require(someOptional)
    #expect(value.count > 0)
}

@Test
func requiredArrayElement() throws {
    let array = [1, 2, 3]
    let first = try #require(array.first)
    #expect(first == 1)
}
```

### Error Testing

```swift
@Test
func throwsError() {
    #expect(throws: NetworkError.notFound) {
        try fetchUser(id: -1)
    }
}

@Test
func throwsAnyError() {
    #expect(throws: (any Error).self) {
        try riskyOperation()
    }
}

@Test
func noErrorThrown() {
    #expect(throws: Never.self) {
        safeOperation()
    }
}
```

### Custom Error Messages

```swift
@Test
func withCustomMessage() {
    let result = compute()
    #expect(result == 42, "Expected 42 but got \(result)")
}
```

## Test Lifecycle

### Setup and Teardown

```swift
@Suite
struct DatabaseTests {
    var database: Database!
    
    init() {
        // Runs before each test
        database = Database.inMemory()
    }
    
    deinit {
        // Runs after each test
        database.close()
    }
    
    @Test
    func insert() {
        database.insert(item)
        #expect(database.count == 1)
    }
}
```

### Suite-Level Setup

```swift
@Suite
struct SharedResourceTests {
    static var sharedResource: Resource!
    
    static func setUp() {
        // Runs once before all tests
        sharedResource = Resource()
    }
    
    static func tearDown() {
        // Runs once after all tests
        sharedResource.cleanup()
    }
    
    @Test
    func test1() {
        // Use Self.sharedResource
    }
}
```

## Traits

### Time Limits

```swift
@Test(.timeLimit(.minutes(1)))
func longRunningTest() {
    // Must complete within 1 minute
}
```

### Tags

```swift
@Test(.tags(.unit, .fast))
func quickTest() {
    // Tagged as unit and fast
}

@Test(.tags(.integration))
func integrationTest() {
    // Tagged as integration
}
```

### Bug References

```swift
@Test(.bug("https://bugs.example.com/123", id: 123))
func regressionTest() {
    // Links to bug tracker
}
```

## Best Practices

1. **Use descriptive names** - Test names explain behavior
2. **One assertion concept** - Test one thing per test
3. **Use #require for preconditions** - Fail fast
4. **Add custom messages** - When failure isn't obvious
5. **Test error cases** - Verify error handling
6. **Use traits appropriately** - Tags, time limits, etc.
7. **Keep tests fast** - Unit tests should be quick
8. **Isolate tests** - No dependencies between tests

## Common Patterns

### Testing Optionals

```swift
@Test
func optionalHandling() throws {
    let result = try #require(computeOptional())
    #expect(result.isValid)
}
```

### Testing Arrays

```swift
@Test
func arrayOperations() {
    let items = fetchItems()
    #expect(items.count == 3)
    #expect(items.contains { $0.id == 1 })
}
```

### Testing Floating Point

```swift
@Test
func floatingPointComparison() {
    let result = calculate()
    #expect(result == 3.14159, accuracy: 0.0001)
}
```

## For More Information

Visit https://swiftzilla.dev for comprehensive Swift Testing documentation.
