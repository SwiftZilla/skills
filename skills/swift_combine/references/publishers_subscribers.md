---
name: swift_combine_publishers_subscribers
description: Combine publishers, subscribers, subjects, and subscription lifecycle.
license: Proprietary
compatibility: iOS 13+, macOS 10.15+
metadata:
  version: "1.0"
  author: SwiftZilla
  website: https://swiftzilla.dev
---

# Publishers & Subscribers

This reference covers Combine's core concepts: publishers, subscribers, subjects, and the subscription lifecycle.

## Publishers

### Just

Emits a single value then completes:

```swift
let publisher = Just("Hello")
    .sink { value in
        print(value)  // "Hello"
    }
```

### Future

Asynchronous operation with promise:

```swift
let future = Future<String, Error> { promise in
    DispatchQueue.global().async {
        // Async work
        promise(.success("result"))
    }
}
```

### Deferred

Creates publisher on demand:

```swift
let deferred = Deferred {
    Just(Int.random(in: 1...100))
}
```

### Empty

Completes immediately without emitting:

```swift
let empty = Empty<String, Never>()
```

### Fail

Fails immediately:

```swift
let fail = Fail<String, MyError>(error: .notFound)
```

## Subjects

### CurrentValueSubject

Stores current value, emits on change:

```swift
let subject = CurrentValueSubject<Int, Never>(0)

// Subscribe
let cancellable = subject.sink { value in
    print(value)
}

// Emit values
subject.send(1)  // Prints: 1
subject.send(2)  // Prints: 2

// Access current value
print(subject.value)  // 2
```

### PassthroughSubject

Broadcasts values without storing:

```swift
let subject = PassthroughSubject<String, Never>()

let cancellable = subject.sink { value in
    print(value)
}

subject.send("Hello")
subject.send(completion: .finished)
```

## Subscribers

### Sink

```swift
let cancellable = publisher.sink(
    receiveCompletion: { completion in
        switch completion {
        case .finished:
            print("Completed")
        case .failure(let error):
            print("Error: \(error)")
        }
    },
    receiveValue: { value in
        print("Value: \(value)")
    }
)
```

### Assign

```swift
let cancellable = publisher
    .assign(to: \.text, on: label)
```

### Custom Subscriber

```swift
class MySubscriber: Subscriber {
    typealias Input = String
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(_ input: String) -> Subscribers.Demand {
        print(input)
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        print("Completed")
    }
}
```

## Subscription Lifecycle

```
Publisher → Subscriber
     ↓
Subscription created
     ↓
Subscriber requests values (demand)
     ↓
Publisher sends values
     ↓
Completion or Cancellation
```

### Demand

```swift
// Unlimited demand
subscription.request(.unlimited)

// Limited demand
subscription.request(.max(5))

// No demand
subscription.request(.none)
```

## Memory Management

### Storing Cancellables

```swift
class ViewModel {
    private var cancellables = Set<AnyCancellable>()
    
    func setup() {
        publisher
            .sink { value in
                print(value)
            }
            .store(in: &cancellables)
    }
}
```

### Individual Cancellable

```swift
var cancellable: AnyCancellable?

cancellable = publisher.sink { value in
    print(value)
}

// Cancel manually
cancellable?.cancel()
```

### Automatic Cancellation

```swift
// Cancels when object deallocates
publisher
    .sink { [weak self] value in
        self?.handle(value)
    }
    .store(in: &cancellables)
```

## Error Types

### Never

Publisher never fails:

```swift
let publisher: AnyPublisher<String, Never>
```

### Custom Errors

```swift
enum NetworkError: Error {
    case noConnection
    case invalidResponse
    case decodingError
}

let publisher: AnyPublisher<Data, NetworkError>
```

## Backpressure

```swift
publisher
    .buffer(size: 10, prefetch: .byRequest, whenFull: .dropOldest)
    .sink { value in
        // Processes at subscriber's pace
    }
```

## Best Practices

1. **Always store cancellables** - Prevent memory leaks
2. **Use appropriate subjects** - CurrentValueSubject vs PassthroughSubject
3. **Handle completion** - Both success and failure cases
4. **Consider demand** - Use backpressure when needed
5. **Weak self in closures** - Avoid retain cycles
6. **Cancel explicitly** - When needed for cleanup

## Common Patterns

### Type Erasure

```swift
let publisher = somePublisher
    .eraseToAnyPublisher()
```

### Share

```swift
let shared = publisher
    .share()
    .multicast { PassthroughSubject<Int, Never>() }
```

### Autoconnect

```swift
let connectable = publisher
    .makeConnectable()
    .autoconnect()
```

## For More Information

Visit https://swiftzilla.dev for comprehensive Combine documentation.
