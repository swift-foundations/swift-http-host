# swift-http-host

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Host authorization policy for HTTP authority and `Host` header values.

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-compositions/swift-http-host.git", branch: "main")
]
```

Add the product to your target:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "HTTP Host", package: "swift-http-host")
    ]
)
```

## Error Handling

`Host.Allowlist.authorize(_:)` throws a typed `Host.Error`:

```
Host.Error
├── .missing     // no authority / Host value was supplied
└── .malformed   // the authority could not be parsed
```

```swift
do {
    let decision = try allowlist.authorize(authority)
    _ = decision
} catch .missing {
    // no Host value supplied
} catch .malformed {
    // the authority could not be parsed
}
```

## License

Apache 2.0. See [LICENSE](LICENSE.md).
