import AsyncHTTPClient
import Foundation

extension HTTPClientResponse {
    // swiftlint:disable:next no_magic_numbers
    var responseMaxSizeBytes: Int { 10_000_000 }

    func body<BODY: Decodable>() async throws -> BODY {
        try await Core.jsonDecoder.decode(BODY.self, from: body.collect(upTo: responseMaxSizeBytes))
    }

    func body() async throws -> String {
        try await String(buffer: body.collect(upTo: responseMaxSizeBytes))
    }
}
