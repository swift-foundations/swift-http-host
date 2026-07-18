import Testing
@testable import HTTP_Host

@Suite
struct Test {
    @Suite
    struct Unit {
        @Test
        func `accepts an allowed host`() throws(Host.Error) {
            let allowlist = Host.Allowlist(allowedHosts: ["example.com"])
            #expect(try allowlist.authorize("example.com") == .allowed)
        }

        @Test
        func `rejects an unlisted host`() throws(Host.Error) {
            let allowlist = Host.Allowlist(allowedHosts: ["example.com"])
            #expect(try allowlist.authorize("other.example") == .denied)
        }
    }

    @Suite
    // swiftlint:disable:next type_name
    struct `Edge Case` {
        @Test
        func `strips a valid port`() throws(Host.Error) {
            let allowlist = Host.Allowlist(allowedHosts: ["example.com"])
            #expect(try allowlist.authorize("example.com:443") == .allowed)
        }

        @Test
        func `strips a valid bracketed IPv6 port`() throws(Host.Error) {
            let allowlist = Host.Allowlist(allowedHosts: ["[::1]"])
            #expect(try allowlist.authorize("[::1]:8080") == .allowed)
        }

        @Test
        func `rejects an invalid port`() {
            let allowlist = Host.Allowlist(allowedHosts: ["example.com"])
            #expect(throws: Host.Error.malformed) {
                try allowlist.authorize("example.com:not-a-port")
            }
        }

        @Test
        func `rejects a missing host`() {
            let allowlist = Host.Allowlist(allowedHosts: ["example.com"])
            #expect(throws: Host.Error.missing) {
                try allowlist.authorize(nil)
            }
        }
    }

    @Suite
    struct Integration {
        @Test
        func `matches host names case insensitively`() throws(Host.Error) {
            let allowlist = Host.Allowlist(allowedHosts: ["Example.COM"])
            #expect(try allowlist.authorize("example.com:80") == .allowed)
        }
    }
}
