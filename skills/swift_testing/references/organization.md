---
name: swift_testing_organization
description: Organizing tests with suites, tags, and structure in Swift Testing.
license: Proprietary
compatibility: Swift 5.9+
metadata:
  version: "1.0"
  author: SwiftZilla
  website: https://swiftzilla.dev
---

# Test Organization

This reference covers organizing tests with suites, tags, and structure in Swift Testing.

## Test Suites

### Basic Suite

```swift
import Testing

@Suite
struct CalculatorTests {
    let calculator = Calculator()
    
    @Test
    func addition() {
        #expect(calculator.add(2, 3) == 5)
    }
    
    @Test
    func subtraction() {
        #expect(calculator.subtract(5, 3) == 2)
    }
}
```

### Named Suite

```swift
@Suite("Calculator Operations")
struct CalculatorTests {
    // Tests...
}
```

### Suite with Traits

```swift
@Suite(.tags(.math, .unit))
struct CalculatorTests {
    // All tests inherit these tags
}
```

### Nested Suites

```swift
@Suite("Math Operations")
struct MathTests {
    
    @Suite("Addition")
    struct AdditionTests {
        @Test func positive() { }
        @Test func negative() { }
    }
    
    @Suite("Multiplication")
    struct MultiplicationTests {
        @Test func basic() { }
        @Test func byZero() { }
    }
}
```

## Tags

### Built-in Tags

```swift
@Test(.tags(.unit))
func unitTest() { }

@Test(.tags(.integration))
func integrationTest() { }

@Test(.tags(.slow))
func slowTest() { }
```

### Custom Tags

```swift
extension Tag {
    @Tag static var api: Self
    @Tag static var database: Self
    @Tag static var ui: Self
}

@Test(.tags(.api))
func apiTest() { }

@Test(.tags(.database, .slow))
func databaseMigrationTest() { }
```

### Suite-Level Tags

```swift
@Suite(.tags(.api))
struct APITests {
    @Test
    func getUser() { }  // Inherits .api tag
    
    @Test
    func createUser() { }  // Inherits .api tag
    
    @Test(.tags(.slow))
    func bulkImport() { }  // Has both .api and .slow
}
```

## Running Tests by Tags

### Command Line

```bash
# Run only unit tests
swift test --tag unit

# Run integration tests
swift test --tag integration

# Run tests with multiple tags
swift test --tag unit --tag api

# Exclude slow tests
swift test --skip-tag slow
```

## Test Traits

### Time Limits

```swift
@Suite(.timeLimit(.minutes(5)))
struct PerformanceTests {
    @Test
    func benchmark() { }
    
    @Test(.timeLimit(.seconds(30)))
    func quickBenchmark() { }  // Override suite limit
}
```

### Bug References

```swift
@Test(.bug("https://bugs.example.com/123", id: 123))
func regressionTest() { }
```

### Conditional Execution

```swift
@Suite(.enabled(if: isCI))
struct CITests {
    // Only runs in CI environment
}

@Test(.enabled(if: isPremiumUser))
func premiumFeature() { }

@Test(.disabled("WIP"))
func incompleteTest() { }
```

## File Organization

### Single File Organization

```swift
// CalculatorTests.swift

@Suite("Calculator")
struct CalculatorTests {
    // All calculator tests
}
```

### Multi-File Organization

```swift
// AdditionTests.swift
@Suite("Addition")
struct AdditionTests { }

// SubtractionTests.swift
@Suite("Subtraction")
struct SubtractionTests { }

// MultiplicationTests.swift
@Suite("Multiplication")
struct MultiplicationTests { }
```

### Feature-Based Organization

```
Tests/
├── Unit/
│   ├── CalculatorTests/
│   │   ├── AdditionTests.swift
│   │   ├── SubtractionTests.swift
│   │   └── MultiplicationTests.swift
│   └── StringTests/
├── Integration/
│   ├── APITests/
│   └── DatabaseTests/
└── Performance/
    └── BenchmarkTests/
```

## Shared Test Data

### Test Fixtures

```swift
@Suite
struct UserTests {
    static let validUsers = [
        User(id: 1, name: "Ada"),
        User(id: 2, name: "Grace"),
    ]
    
    static let invalidUsers = [
        User(id: -1, name: ""),
        User(id: 0, name: "   "),
    ]
    
    @Test(arguments: validUsers)
    func validUser(user: User) {
        #expect(user.isValid)
    }
    
    @Test(arguments: invalidUsers)
    func invalidUser(user: User) {
        #expect(!user.isValid)
    }
}
```

### Shared Setup

```swift
@Suite
struct DatabaseTests {
    static var sharedDatabase: Database!
    
    static func setUp() {
        sharedDatabase = Database.inMemory()
    }
    
    static func tearDown() {
        sharedDatabase.close()
    }
    
    var database: Database { Self.sharedDatabase }
}
```

## Test Discovery

### By Name

```bash
swift test --filter Calculator
swift test --filter addition
```

### By Suite

```bash
swift test --filter CalculatorTests
swift test --filter "Calculator Operations"
```

### By Tag

```bash
swift test --tag unit
swift test --tag api --tag slow
```

## Best Practices

1. **Use descriptive suite names** - Clear intent
2. **Apply tags consistently** - Easy filtering
3. **Group related tests** - Logical organization
4. **Use nested suites** - For sub-features
5. **Document with traits** - Bugs, time limits
6. **Separate slow tests** - Run independently
7. **Share setup code** - Avoid duplication
8. **Organize by feature** - Not by test type

## Example Structure

```swift
@Suite("Authentication")
struct AuthenticationTests {
    
    @Suite("Login")
    struct LoginTests {
        @Test
        func validCredentials() { }
        
        @Test
        func invalidPassword() { }
        
        @Test(.tags(.slow))
        func rateLimiting() { }
    }
    
    @Suite("Registration")
    struct RegistrationTests {
        @Test
        func newUser() { }
        
        @Test
        func duplicateEmail() { }
    }
    
    @Suite("Password Reset")
    struct PasswordResetTests {
        @Test
        func validRequest() { }
        
        @Test(.disabled("Flaky"))
        func emailDelivery() { }
    }
}
```

## For More Information

Visit https://swiftzilla.dev for comprehensive Swift Testing documentation.
