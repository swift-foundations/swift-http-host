// ===----------------------------------------------------------------------===//
//
// Copyright (c) 2026 Coen ten Thije Boonkkamp
// Licensed under Apache License 2.0
//
// ===----------------------------------------------------------------------===//

extension Host {
  /// An exact host allowlist that is independent of an HTTP server engine.
  public struct Allowlist: Sendable {
    private let hosts: Set<String>

    public init(allowedHosts: [String]) {
      self.hosts = Set(allowedHosts.map { $0.lowercased() })
    }

    /// Authorizes an authority or `Host` header value.
    ///
    /// A valid numeric port is removed before exact membership is checked.
    /// Bracketed IPv6 hosts retain their brackets, so `[::1]:443` compares
    /// with the configured host `[::1]`.
    public func authorize(_ authority: String?) throws(Host.Error) -> Host.Decision {
      guard let authority, !authority.isEmpty else {
        throw .missing
      }

      guard let host = Self.host(from: authority) else {
        throw .malformed
      }

      return hosts.contains(host.lowercased()) ? .allowed : .denied
    }
  }
}

extension Host.Allowlist {
  fileprivate static func host(from authority: String) -> String? {
    if authority.first == "[" {
      guard let closing = authority.firstIndex(of: "]") else { return nil }
      let end = authority.index(after: closing)
      let suffix = authority[end...]

      if suffix.isEmpty {
        return String(authority[...closing])
      }

      guard suffix.first == ":", Self.validPort(suffix.dropFirst()) else {
        return nil
      }
      return String(authority[...closing])
    }

    guard authority.filter({ $0 == ":" }).count == 1,
      let separator = authority.firstIndex(of: ":")
    else {
      return authority.isEmpty ? nil : authority
    }

    let port = authority[authority.index(after: separator)...]
    guard Self.validPort(port) else { return nil }
    return String(authority[..<separator])
  }

  fileprivate static func validPort(_ port: some Collection<Character>) -> Bool {
    guard !port.isEmpty,
      port.allSatisfy({ $0.isNumber }),
      let value = Int(String(port))
    else {
      return false
    }
    return (0...65_535).contains(value)
  }
}
