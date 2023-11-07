import AsyncHTTPClient
import Foundation

extension HTTPClientResponse {
    var responseMaxSizeBytes: Int { 10_000_000 }

    func body<BODY: Decodable>() async throws -> BODY {
        return try await Core.jsonDecoder.decode(BODY.self, from: body.collect(upTo: responseMaxSizeBytes))
    }

    func body() async throws -> String {
        return try await String(buffer: body.collect(upTo: responseMaxSizeBytes))
    }
}
