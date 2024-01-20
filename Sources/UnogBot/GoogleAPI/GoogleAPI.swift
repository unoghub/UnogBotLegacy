import AsyncHTTPClient
import Foundation
import JWTKit
import NIOHTTP1

class GoogleAPI {
    struct GoogleAuthenticationClaims: JWTPayload {
        let iss: IssuerClaim
        let scope: String
        let aud: AudienceClaim
        let exp: ExpirationClaim
        let iat: IssuedAtClaim

        func verify(using signer: JWTKit.JWTSigner) {}
    }

    struct AccessTokenRequest: Encodable {
        let grantType = URL(string: "urn:ietf:params:oauth:grant-type:jwt-bearer")!
        let assertion: String
    }

    struct AccessTokenResponse: Decodable {
        let accessToken: String
        let expiresIn: Int
    }

    var claims = GoogleAuthenticationClaims(
        iss: IssuerClaim(value: "verification@unogbot.iam.gserviceaccount.com"),
        scope: "https://www.googleapis.com/auth/spreadsheets",
        aud: AudienceClaim(stringLiteral: "https://oauth2.googleapis.com/token"),
        exp: ExpirationClaim(value: Date() + TimeInterval.hour),
        iat: IssuedAtClaim(value: Date())
    )
    let signers = {
        let signers = JWTSigners()
        try! signers.use(.rs256(key: .private(pem: Core.googleServiceAccountPrivateKey)))
        return signers
    }()
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
            try request.headers.add(name: "Authorization", value: "Bearer \(await token())")
        }

        return request
    }

    func token() async throws -> String {
        if tokenExpiry.timeIntervalSinceNow < TimeInterval.minute {
            let signedJWT = try signers.sign(claims)

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
