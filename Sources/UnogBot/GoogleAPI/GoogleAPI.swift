import AsyncHTTPClient
import Foundation
import NIOHTTP1
import SwiftJWT

class GoogleAPI {
    struct GoogleAuthenticationClaims: Claims {
        var iss = "verification@unogbot.iam.gserviceaccount.com"
        var scope = "https://www.googleapis.com/auth/spreadsheets"
        var aud = "https://oauth2.googleapis.com/token"
        var exp = Date() + TimeInterval.hour
        var iat = Date()
    }

    struct AccessTokenRequest: Encodable {
        let grantType = URL(string: "urn:ietf:params:oauth:grant-type:jwt-bearer")!
        let assertion: String
    }

    struct AccessTokenResponse: Decodable {
        let accessToken: String
        let expiresIn: Int
    }

    var claims = GoogleAuthenticationClaims()
    let signer = {
        let pem = Core.googleServiceAccountPrivateKey
        return JWTSigner.rs256(privateKey: pem)
    }()
    var jwt = JWT(claims: GoogleAuthenticationClaims())

    var token: String!
    var tokenExpiry = Date()

    func request(
        to url: URL,
        method: HTTPMethod,
        requiresAuthentication: Bool = true
    ) async throws -> HTTPClientRequest {
        var request = HTTPClientRequest(url: url.absoluteString)
        request.method = method

        if requiresAuthentication {
            request.headers.add(name: "Authorization", value: "Bearer \(try await token())")
        }

        return request
    }

    func token() async throws -> String {
        if tokenExpiry.timeIntervalSinceNow < TimeInterval.minute { // 1 minute
            let signedJWT = try jwt.sign(using: signer)

            var request = try await request(
                to: URL(string: "https://oauth2.googleapis.com/token")!,
                method: .POST,
                requiresAuthentication: false
            )
            try request.setBody(to: AccessTokenRequest(assertion: signedJWT))

            let response: AccessTokenResponse = try await request.send().body()

            tokenExpiry = Date() + TimeInterval(response.expiresIn)
            token = response.accessToken
        }

        return token
    }
}
