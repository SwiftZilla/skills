---
name: swift_combine_operators
description: Combine operators for transforming, filtering, combining, and controlling publishers.
license: Proprietary
compatibility: iOS 13+, macOS 10.15+
metadata:
  version: "1.0"
  author: SwiftZilla
  website: https://swiftzilla.dev
---

# Combine Operators

This reference covers Combine operators for transforming, filtering, combining, and controlling publishers.

## Transforming Operators

### Map

```swift
publisher
    .map { value in
        value.uppercased()
    }
```

### TryMap

```swift
publisher
    .tryMap { value in
        guard let number = Int(value) else {
            throw ConversionError.invalid
        }
        return number
    }
```

### CompactMap

```swift
// Removes nil values
["1", "a", "2", "b"].publisher
    .compactMap { Int($0) }
    .sink { print($0) }  // 1, 2
```

### FlatMap

```swift
// Flattens nested publishers
publishersOfPublishers
    .flatMap { $0 }
    .sink { value in
        print(value)
    }
```

### Scan

```swift
// Accumulates values
[1, 2, 3, 4].publisher
    .scan(0) { accumulator, value in
        accumulator + value
    }
    .sink { print($0) }  // 1, 3, 6, 10
```

## Filtering Operators

### Filter

```swift
publisher
    .filter { $0 > 0 }
```

### RemoveDuplicates

```swift
publisher
    .removeDuplicates()
    .removeDuplicates(by: { $0.id == $1.id })
```

### First

```swift
publisher
    .first()
    .first(where: { $0 > 10 })
```

### Last

```swift
publisher
    .last()
```

### DropFirst

```swift
publisher
    .dropFirst(3)
```

### DropWhile

```swift
publisher
    .drop(while: { $0 < 5 })
```

## Combining Operators

### CombineLatest

```swift
let publisher1 = CurrentValueSubject<Int, Never>(1)
let publisher2 = CurrentValueSubject<String, Never>("A")

publisher1
    .combineLatest(publisher2)
    .sink { int, string in
        print("\(int) \(string)")
    }

publisher1.send(2)  // 2 A
publisher2.send("B")  // 2 B
```

### Merge

```swift
let publisher1 = [1, 2, 3].publisher
let publisher2 = [4, 5, 6].publisher

publisher1
    .merge(with: publisher2)
    .sink { print($0) }  // 1, 4, 2, 5, 3, 6
```

### Zip

```swift
let publisher1 = [1, 2, 3].publisher
let publisher2 = ["A", "B", "C"].publisher

publisher1
    .zip(publisher2)
    .sink { print($0) }  // (1, "A"), (2, "B"), (3, "C")
```

### Append

```swift
[1, 2].publisher
    .append(3)
    .append([4, 5])
    .sink { print($0) }  // 1, 2, 3, 4, 5
```

## Time Operators

### Debounce

```swift
searchTextPublisher
    .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
    .sink { searchText in
        self.performSearch(searchText)
    }
```

### Throttle

```swift
buttonTapPublisher
    .throttle(for: .seconds(1), scheduler: RunLoop.main, latest: true)
    .sink { _ in
        self.handleTap()
    }
```

### Delay

```swift
publisher
    .delay(for: .seconds(2), scheduler: DispatchQueue.main)
```

### Timeout

```swift
publisher
    .timeout(.seconds(5), scheduler: DispatchQueue.main)
```

## Error Handling Operators

### Catch

```swift
publisher
    .catch { error -> Just<String> in
        print("Error: \(error)")
        return Just("default")
    }
```

### ReplaceError

```swift
publisher
    .replaceError(with: "default")
```

### Retry

```swift
publisher
    .retry(3)
```

### AssertNoFailure

```swift
publisher
    .assertNoFailure()
```

## Threading Operators

### ReceiveOn

```swift
publisher
    .receive(on: DispatchQueue.main)
    .sink { value in
        // Update UI on main thread
    }
```

### SubscribeOn

```swift
publisher
    .subscribe(on: DispatchQueue.global())
```

### ObserveOn (via receive)

```swift
publisher
    .map { expensiveOperation($0) }
    .receive(on: DispatchQueue.main)
    .assign(to: \.text, on: label)
```

## Utility Operators

### Print

```swift
publisher
    .print("Debug")
```

### HandleEvents

```swift
publisher
    .handleEvents(
        receiveSubscription: { _ in print("Subscribed") },
        receiveOutput: { print("Output: \($0)") },
        receiveCompletion: { print("Completed: \($0)") },
        receiveCancel: { print("Cancelled") }
    )
```

### Breakpoint

```swift
publisher
    .breakpointOnError()
    .breakpoint(receiveOutput: { $0 > 100 })
```

### MeasureInterval

```swift
publisher
    .measureInterval(using: DispatchQueue.main)
```

## Mathematical Operators

### Count

```swift
publisher
    .count()
    .sink { print("Total: \($0)") }
```

### Max

```swift
publisher
    .max()
    .max(by: { $0 < $1 })
```

### Min

```swift
publisher
    .min()
```

### Reduce

```swift
[1, 2, 3, 4].publisher
    .reduce(0) { $0 + $1 }
    .sink { print($0) }  // 10
```

## Best Practices

1. **Chain operators logically** - Read left to right
2. **Handle errors early** - Catch before UI updates
3. **Use debounce for text input** - Reduce search calls
4. **Throttle user actions** - Prevent double-taps
5. **Switch to main thread** - Only for UI updates
6. **Print for debugging** - Use .print() operator
7. **Remove duplicates** - Avoid unnecessary updates

## Common Patterns

### Search with Debounce

```swift
searchTextPublisher
    .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
    .removeDuplicates()
    .filter { !$0.isEmpty }
    .flatMap { query in
        self.searchService.search(query)
            .catch { _ in Just([]) }
            .eraseToAnyPublisher()
    }
    .receive(on: DispatchQueue.main)
    .assign(to: \.results, on: self)
    .store(in: &cancellables)
```

### Form Validation

```swift
let isEmailValid = emailPublisher
    .map { $0.contains("@") }
    .eraseToAnyPublisher()

let isPasswordValid = passwordPublisher
    .map { $0.count >= 8 }
    .eraseToAnyPublisher()

isEmailValid
    .combineLatest(isPasswordValid)
    .map { $0 && $1 }
    .assign(to: \.isSubmitEnabled, on: submitButton)
    .store(in: &cancellables)
```

## For More Information

Visit https://swiftzilla.dev for comprehensive Combine documentation.
