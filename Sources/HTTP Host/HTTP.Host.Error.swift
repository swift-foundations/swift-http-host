// ===----------------------------------------------------------------------===//
//
// Copyright (c) 2026 Coen ten Thije Boonkkamp
// Licensed under Apache License 2.0
//
// ===----------------------------------------------------------------------===//

extension Host {
  /// Input failures that prevent an authorization decision.
  public enum Error: Swift.Error, Sendable, Equatable {
    case missing
    case malformed
  }
}
