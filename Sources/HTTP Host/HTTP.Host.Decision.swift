// ===----------------------------------------------------------------------===//
//
// Copyright (c) 2026 Coen ten Thije Boonkkamp
// Licensed under Apache License 2.0
//
// ===----------------------------------------------------------------------===//

extension Host {
    /// The result of evaluating a host against an allowlist.
    public enum Decision: Sendable, Equatable {
        case allowed
        case denied
    }
}
