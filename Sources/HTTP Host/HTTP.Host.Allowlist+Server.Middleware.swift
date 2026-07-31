// ===----------------------------------------------------------------------===//
//
// Copyright (c) 2026 Coen ten Thije Boonkkamp
// Licensed under Apache License 2.0
//
// ===----------------------------------------------------------------------===//

import HTTP_Standard
public import Server

extension Host.Allowlist: Server.Middleware {
  public func intercept(
    _ request: Server.Request,
    next: Server.Responder
  ) async throws(Server.Error) -> Server.Response {
    // swift-linter:disable:next raw value access
    // REASON: the server membrane exposes header values through this typed boundary.
    let authority = request.headers.first("Host")?.rawValue

    let decision: Host.Decision
    do {
      decision = try authorize(authority)
    } catch Host.Error.missing {
      throw .badRequest("Missing Host header")
    } catch {
      throw .badRequest("Malformed Host header")
    }

    switch decision {
    case .allowed:
      return try await next(request)

    case .denied:
      throw .forbidden("Host not allowed")
    }
  }
}
