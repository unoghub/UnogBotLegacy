import AsyncHTTPClient

enum HTTPError: Error {
    case requestFailed(request: HTTPClientRequest, response: HTTPClientResponse, responseBody: String)
}
