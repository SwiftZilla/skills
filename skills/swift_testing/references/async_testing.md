---
name: swift_testing_async_testing
description: Testing async/await code with Swift Testing framework.
license: Proprietary
compatibility: Swift 5.9+
metadata:
  version: "1.0"
  author: SwiftZilla
  website: https://swiftzilla.dev
---

# Async Testing

This reference covers testing asynchronous code with Swift Testing.

## Basic Async Tests

### Simple Async Test

```swift
import Testing

@Test
func fetchUser() async throws {
    let user = try await api.fetchUser(id: 1)
    #expect(user.id == 1)
    #expect(user.name == "Ada")
}
```

### Multiple Async Operations

```swift
@Test
func fetchMultipleUsers() async throws {
    async let user1 = api.fetchUser(id: 1)
    async let user2 = api.fetchUser(id: 2)
    
    let (first, second) = try await (user1, user2)
    
    #expect(first.id == 1)
    #expect(second.id == 2)
}
```

## Testing Async Sequences

### Basic Async Sequence

```swift
@Test
func asyncSequence() async {
    let stream = AsyncStream<Int> { continuation in
        for i in 1...3 {
            continuation.yield(i)
        }
        continuation.finish()
    }
    
    var values = [Int]()
    for await value in stream {
        values.append(value)
    }
    
    #expect(values == [1, 2, 3])
}
```

### Testing AsyncStream

```swift
@Test
func testAsyncStream() async {
    let (stream, continuation) = AsyncStream.makeStream(of: Int.self)
    
    Task {
        for i in 1...3 {
            continuation.yield(i)
        }
        continuation.finish()
    }
    
    var values = [Int]()
    for await value in stream {
        values.append(value)
    }
    
    #expect(values == [1, 2, 3])
}
```

## Testing with Time

### Timeout Testing

```swift
@Test
func testWithTimeout() async throws {
    let result = try await withTimeout(seconds: 5) {
        try await slowOperation()
    }
    
    #expect(result != nil)
}
```

### Testing Delays

```swift
@Test
func testDelayedOperation() async {
    let startTime = Date()
    
    await delayedOperation(delay: .seconds(1))
    
    let elapsed = Date().timeIntervalSince(startTime)
    #expect(elapsed >= 1.0)
}
```

## Testing Actors

### Actor Isolation

```swift
actor Counter {
    private var value = 0
    
    func increment() {
        value += 1
    }
    
    func getValue() -> Int {
        value
    }
}

@Test
func testActor() async {
    let counter = Counter()
    
    await counter.increment()
    await counter.increment()
    
    let value = await counter.getValue()
    #expect(value == 2)
}
```

### Concurrent Actor Access

```swift
@Test
func testConcurrentActorAccess() async {
    let counter = Counter()
    
    await withTaskGroup(of: Void.self) { group in
        for _ in 1...100 {
            group.addTask {
                await counter.increment()
            }
        }
    }
    
    let value = await counter.getValue()
    #expect(value == 100)
}
```

## Testing Task Cancellation

```swift
@Test
func testTaskCancellation() async {
    let task = Task {
        try await Task.sleep(for: .seconds(10))
        return "completed"
    }
    
    // Cancel after short delay
    Task {
        try await Task.sleep(for: .seconds(0.1))
        task.cancel()
    }
    
    let result = await task.result
    #expect(throws: CancellationError.self) {
        try result.get()
    }
}
```

## Testing with Continuations

```swift
@Test
func testWithCheckedContinuation() async {
    let result = await withCheckedContinuation { continuation in
        DispatchQueue.global().async {
            continuation.resume(returning: "done")
        }
    }
    
    #expect(result == "done")
}
```

## Testing Async Properties

```swift
class DataLoader {
    var data: Data {
        get async throws {
            try await fetchData()
        }
    }
}

@Test
func testAsyncProperty() async throws {
    let loader = DataLoader()
    let data = try await loader.data
    #expect(!data.isEmpty)
}
```

## Mocking Async Code

```swift
protocol APIProtocol {
    func fetchUser(id: Int) async throws -> User
}

struct MockAPI: APIProtocol {
    var mockUser: User?
    var shouldThrow: Error?
    
    func fetchUser(id: Int) async throws -> User {
        if let error = shouldThrow {
            throw error
        }
        return try #require(mockUser)
    }
}

@Test
func testWithMock() async throws {
    let mockAPI = MockAPI(
        mockUser: User(id: 1, name: "Test")
    )
    
    let user = try await mockAPI.fetchUser(id: 1)
    #expect(user.name == "Test")
}
```

## Best Practices

1. **Use async test functions** - Native async support
2. **Test error cases** - Use #expect(throws:)
3. **Control execution time** - Use timeouts
4. **Test cancellation** - Verify cleanup
5. **Mock dependencies** - Isolate tests
6. **Use TaskGroup** - For parallel testing
7. **Test actor isolation** - Verify thread safety

## Common Patterns

### Testing Race Conditions

```swift
@Test
func testRaceCondition() async {
    let resource = Resource()
    
    async let task1 = resource.modify()
    async let task2 = resource.modify()
    
    let (result1, result2) = await (task1, task2)
    #expect(result1 != result2) // Should be different
}
```

### Testing Retry Logic

```swift
@Test
func testRetry() async throws {
    var attempts = 0
    
    let result = try await retry(maxAttempts: 3) {
        attempts += 1
        if attempts < 3 {
            throw NetworkError.timeout
        }
        return "success"
    }
    
    #expect(result == "success")
    #expect(attempts == 3)
}
```

## For More Information

Visit https://swiftzilla.dev for comprehensive Swift Testing documentation.
