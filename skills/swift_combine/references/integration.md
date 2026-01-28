---
name: swift_combine_integration
description: Integrating Combine with UIKit, SwiftUI, Foundation, and URLSession.
license: Proprietary
compatibility: iOS 13+, macOS 10.15+
metadata:
  version: "1.0"
  author: SwiftZilla
  website: https://swiftzilla.dev
---

# Combine Integration

This reference covers integrating Combine with UIKit, SwiftUI, Foundation frameworks, and URLSession.

## UIKit Integration

### Target-Action Pattern

```swift
// UIButton tap
let button = UIButton()
let tapPublisher = button.publisher(for: .touchUpInside)

tapPublisher
    .sink { _ in
        print("Button tapped")
    }
    .store(in: &cancellables)
```

### UITextField

```swift
let textField = UITextField()

textField.textPublisher
    .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
    .removeDuplicates()
    .sink { text in
        print("Text: \(text ?? "")")
    }
    .store(in: &cancellables)
```

### UISwitch

```swift
let toggle = UISwitch()

toggle.isOnPublisher
    .sink { isOn in
        print("Switch is \(isOn ? "on" : "off")")
    }
    .store(in: &cancellables)
```

### UISlider

```swift
let slider = UISlider()

slider.valuePublisher
    .sink { value in
        print("Slider value: \(value)")
    }
    .store(in: &cancellables)
```

### NotificationCenter

```swift
NotificationCenter.default
    .publisher(for: UIApplication.didEnterBackgroundNotification)
    .sink { _ in
        print("App entered background")
    }
    .store(in: &cancellables)
```

## SwiftUI Integration

### @Published Property Wrapper

```swift
class ViewModel: ObservableObject {
    @Published var count = 0
    @Published var user: User?
    
    func increment() {
        count += 1
    }
}

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            Text("Count: \(viewModel.count)")
            Button("Increment") {
                viewModel.increment()
            }
        }
    }
}
```

### Using Publishers in SwiftUI

```swift
struct SearchView: View {
    @State private var searchText = ""
    @State private var results = [SearchResult]()
    
    private let searchSubject = PassthroughSubject<String, Never>()
    
    var body: some View {
        VStack {
            TextField("Search", text: $searchText)
                .onChange(of: searchText) { newValue in
                    searchSubject.send(newValue)
                }
            
            List(results) { result in
                Text(result.title)
            }
        }
        .onAppear {
            setupSearch()
        }
    }
    
    private func setupSearch() {
        searchSubject
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .flatMap { query in
                searchService.search(query: query)
                    .catch { _ in Just([]) }
            }
            .assign(to: &$results)
    }
}
```

## URLSession Integration

### Data Task Publisher

```swift
let url = URL(string: "https://api.example.com/data")!

URLSession.shared.dataTaskPublisher(for: url)
    .map(\.data)
    .decode(type: MyData.self, decoder: JSONDecoder())
    .receive(on: DispatchQueue.main)
    .sink(
        receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print("Error: \(error)")
            }
        },
        receiveValue: { data in
            print("Received: \(data)")
        }
    )
    .store(in: &cancellables)
```

### POST Request

```swift
var request = URLRequest(url: url)
request.httpMethod = "POST"
request.setValue("application/json", forHTTPHeaderField: "Content-Type")
request.httpBody = try JSONEncoder().encode(payload)

URLSession.shared.dataTaskPublisher(for: request)
    .map(\.data)
    .decode(type: Response.self, decoder: JSONDecoder())
    .catch { error -> Just<Response> in
        print("Error: \(error)")
        return Just(Response())
    }
    .receive(on: DispatchQueue.main)
    .sink { response in
        self.handle(response)
    }
    .store(in: &cancellables)
```

## Core Data Integration

### NSManagedObjectContext

```swift
context.perform {
    // Core Data operations
}

// Notification
NotificationCenter.default
    .publisher(for: .NSManagedObjectContextObjectsDidChange, object: context)
    .sink { notification in
        print("Context changed")
    }
    .store(in: &cancellables)
```

## Timer Integration

### Timer Publisher

```swift
Timer.publish(every: 1.0, on: .main, in: .common)
    .autoconnect()
    .sink { date in
        print("Tick: \(date)")
    }
    .store(in: &cancellables)
```

### Countdown

```swift
Timer.publish(every: 1.0, on: .main, in: .common)
    .autoconnect()
    .map { _ in 1 }
    .scan(10) { accumulator, _ in
        max(0, accumulator - 1)
    }
    .sink { count in
        print("Countdown: \(count)")
    }
    .store(in: &cancellables)
```

## UserDefaults Integration

```swift
UserDefaults.standard
    .publisher(for: \.userToken)
    .sink { token in
        print("Token changed: \(token)")
    }
    .store(in: &cancellables)
```

## Key-Value Observing (KVO)

```swift
let observation = object.publisher(for: \.propertyName)
    .sink { value in
        print("Property changed: \(value)")
    }
```

## Best Practices

1. **Use @Published for ViewModels** - Automatic SwiftUI updates
2. **Handle memory management** - Always store cancellables
3. **Switch to main thread** - For UI updates only
4. **Handle errors gracefully** - Use catch operators
5. **Debounce user input** - For search and text fields
6. **Cancel subscriptions** - On view disappear
7. **Use weak self** - In closure-based operators

## Complete Example: MVVM with Combine

```swift
// Model
struct User: Codable {
    let id: Int
    let name: String
}

// ViewModel
class UserListViewModel: ObservableObject {
    @Published var users = [User]()
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func fetchUsers() {
        isLoading = true
        errorMessage = nil
        
        apiService.fetchUsers()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] users in
                    self?.users = users
                }
            )
            .store(in: &cancellables)
    }
}

// Service
class APIService: APIServiceProtocol {
    func fetchUsers() -> AnyPublisher<[User], Error> {
        let url = URL(string: "https://api.example.com/users")!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [User].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

// View
struct UserListView: View {
    @StateObject private var viewModel = UserListViewModel()
    
    var body: some View {
        List(viewModel.users) { user in
            Text(user.name)
        }
        .onAppear {
            viewModel.fetchUsers()
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}
```

## For More Information

Visit https://swiftzilla.dev for comprehensive Combine documentation.
