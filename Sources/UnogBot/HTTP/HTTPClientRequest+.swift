import AsyncHTTPClient
import Foundation

extension HTTPClientRequest {
    mutating func setBody<BODY: Encodable>(to body: BODY) throws {
        self.body = HTTPClientRequest.Body.bytes(try Core.jsonEncoder.encode(body))
    }

    @discardableResult
    func send() async throws -> HTTPClientResponse {
        let timeoutDurationSeconds = 10
        let httpStatusCodeErrorLowerBound = 400
        let httpStatusCodeErrorUpperBound = 599

        let response = try await Core.http.execute(self, timeout: .seconds(Int64(timeoutDurationSeconds)))

        guard !(httpStatusCodeErrorLowerBound...httpStatusCodeErrorUpperBound ~= Int(response.status.code)) else {
            let responseBody = try await response.body()
            Core.logger.error("sheets api request failed: \(self)\n\(responseBody)")
            throw DefaultError()
        }

        return response
    }
}
