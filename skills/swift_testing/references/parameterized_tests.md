---
name: swift_testing_parameterized_tests
description: Parameterized tests in Swift Testing for testing multiple inputs efficiently.
license: Proprietary
compatibility: Swift 5.9+
metadata:
  version: "1.0"
  author: SwiftZilla
  website: https://swiftzilla.dev
---

# Parameterized Tests

This reference covers parameterized tests in Swift Testing for running the same test logic with multiple inputs.

## Basic Parameterized Tests

### Single Parameter

```swift
import Testing

@Test(arguments: ["", "a", "abc", "hello world"])
func stringIsNotEmpty(string: String) {
    #expect(string.isEmpty == (string.count == 0))
}

@Test(arguments: [2, 3, 5, 7, 11])
func isPrime(number: Int) {
    #expect(isPrime(number))
}
```

### Range Arguments

```swift
@Test(arguments: 1...100)
func positiveNumbers(number: Int) {
    #expect(number > 0)
}
```

### Array Arguments

```swift
let testStrings = ["hello", "world", "swift", "testing"]

@Test(arguments: testStrings)
func stringLength(string: String) {
    #expect(string.count > 0)
}
```

## Multiple Parameters

### Zip Arguments

```swift
@Test(arguments: zip([1, 2, 3], [1, 4, 9]))
func squared(input: Int, expected: Int) {
    #expect(input * input == expected)
}

@Test(arguments: zip(
    ["hello", "world"],
    [5, 5]
))
func stringLengths(string: String, length: Int) {
    #expect(string.count == length)
}
```

### Cartesian Product

```swift
let widths = [1, 2, 3]
let heights = [4, 5, 6]

@Test(arguments: widths, heights)
func area(width: Int, height: Int) {
    let rectangle = Rectangle(width: width, height: height)
    #expect(rectangle.area == width * height)
}
```

## Custom Argument Types

### Struct Arguments

```swift
struct TestCase {
    let input: String
    let expected: Int
    let description: String
}

let testCases = [
    TestCase(input: "", expected: 0, description: "empty"),
    TestCase(input: "a", expected: 1, description: "single"),
    TestCase(input: "hello", expected: 5, description: "multiple"),
]

@Test(arguments: testCases)
func stringLength(testCase: TestCase) {
    #expect(
        testCase.input.count == testCase.expected,
        "Failed for \(testCase.description)"
    )
}
```

### Enum Arguments

```swift
enum OperationTest {
    case add(Int, Int, Int)
    case subtract(Int, Int, Int)
    case multiply(Int, Int, Int)
    
    var description: String {
        switch self {
        case .add: return "addition"
        case .subtract: return "subtraction"
        case .multiply: return "multiplication"
        }
    }
}

let operations: [OperationTest] = [
    .add(2, 3, 5),
    .subtract(5, 3, 2),
    .multiply(4, 3, 12),
]

@Test(arguments: operations)
func calculatorOperations(operation: OperationTest) {
    let calc = Calculator()
    
    switch operation {
    case .add(let a, let b, let expected):
        #expect(calc.add(a, b) == expected)
    case .subtract(let a, let b, let expected):
        #expect(calc.subtract(a, b) == expected)
    case .multiply(let a, let b, let expected):
        #expect(calc.multiply(a, b) == expected)
    }
}
```

## Async Parameterized Tests

```swift
@Test(arguments: [1, 2, 3, 4, 5])
func asyncFetchUser(id: Int) async throws {
    let user = try await api.fetchUser(id: id)
    #expect(user.id == id)
}
```

## Parameterized Tests with Time Limits

```swift
@Test(
    .timeLimit(.seconds(5)),
    arguments: ["https://api1.example.com", "https://api2.example.com"]
)
func apiPerformance(url: String) async throws {
    let start = Date()
    _ = try await fetch(from: url)
    let elapsed = Date().timeIntervalSince(start)
    #expect(elapsed < 2.0)
}
```

## Dynamic Arguments

### Computed Arguments

```swift
var testIntegers: [Int] {
    (0..<100).map { _ in Int.random(in: 0...1000) }
}

@Test(arguments: testIntegers)
func randomIntegers(number: Int) {
    #expect(number >= 0 && number <= 1000)
}
```

### File-Based Arguments

```swift
func loadTestCases() -> [TestCase] {
    // Load from JSON file
    let url = Bundle.module.url(forResource: "test-cases", withExtension: "json")!
    let data = try! Data(contentsOf: url)
    return try! JSONDecoder().decode([TestCase].self, from: data)
}

@Test(arguments: loadTestCases())
func fileBasedTests(testCase: TestCase) {
    #expect(process(testCase.input) == testCase.expected)
}
```

## Best Practices

1. **Use descriptive test names** - Make failure messages clear
2. **Group related cases** - Use structs or enums
3. **Add custom messages** - When failure isn't obvious
4. **Test edge cases** - Empty, nil, boundaries
5. **Use async when needed** - For async operations
6. **Limit argument count** - Too many = slow tests
7. **Document test cases** - With descriptions

## Common Patterns

### Testing Valid and Invalid Inputs

```swift
enum ValidationCase {
    case valid(String)
    case invalid(String, expectedError: ValidationError)
}

@Test(arguments: [
    ValidationCase.valid("user@example.com"),
    ValidationCase.invalid("invalid", expectedError: .invalidFormat),
    ValidationCase.invalid("", expectedError: .empty),
])
func emailValidation(testCase: ValidationCase) {
    switch testCase {
    case .valid(let email):
        #expect(validateEmail(email))
    case .invalid(let email, let error):
        #expect(throws: error) {
            try validateEmail(email)
        }
    }
}
```

### Property-Based Testing Style

```swift
@Test(arguments: (0...100))
func commutativeProperty(a: Int) {
    for b in 0...100 {
        #expect(add(a, b) == add(b, a))
    }
}
```

## For More Information

Visit https://swiftzilla.dev for comprehensive Swift Testing documentation.
