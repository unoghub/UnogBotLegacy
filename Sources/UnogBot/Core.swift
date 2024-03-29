import AsyncHTTPClient
import DiscordBM
import DiscordLogger
import DotEnv
import Foundation
import Logging

@main
class Core {
    final class EventHandler: GatewayEventHandler {
        let event: Gateway.Event

        init(event: Gateway.Event) {
            self.event = event
        }

        func onInteractionCreate(_ interaction: Interaction) async throws {
            try await InteractionCreateHandler(interaction: interaction).handle()
        }
    }

    static let http = HTTPClient(eventLoopGroupProvider: .singleton)
    static let (jsonEncoder, jsonDecoder) = {
        var encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase

        var decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return (encoder, decoder)
    }()
    static var logger: Logger!
    static var bot: BotGatewayManager!
    static var sheet: GoogleSheetsAPI!

    static let token = ProcessInfo.processInfo.environment["TOKEN"]!
    static let guildID = GuildSnowflake(ProcessInfo.processInfo.environment["GUILD_ID"]!)
    static let submissionChannelID = ChannelSnowflake(
        ProcessInfo.processInfo.environment["VERIFICATION_SUBMISSIONS_CHANNEL_ID"]!
    )
    static let verifiedRoleID = RoleSnowflake(
        ProcessInfo.processInfo.environment["VERIFIED_ROLE_ID"]!
    )
    static let loggingWebhookURL = ProcessInfo.processInfo.environment["LOGGING_WEBHOOK_URL"]!
    static let spreadsheetID = ProcessInfo.processInfo.environment["SPREADSHEET_ID"]!
    static let googleServiceAccountEmail = ProcessInfo.processInfo.environment["GOOGLE_SERVICE_ACCOUNT_EMAIL"]!
    static let googleServiceAccountPrivateKey = try! Data(
        contentsOf: URL(fileURLWithPath: "GoogleServiceAccountPrivateKey.key"), options: .alwaysMapped
    )

    init() async {
        do { try DotEnv.load(path: ".env") } catch { print("not using .env file") }

        let http = HTTPClient(eventLoopGroupProvider: .singleton)

        DiscordGlobalConfiguration.logManager = await .init(
            httpClient: http,
            configuration: .init(sendFullLogAsAttachment: .enabled, extraMetadata: [.error, .critical])
        )

        try! await LoggingSystem.bootstrapWithDiscordLogger(
            address: .url(Core.loggingWebhookURL)
        ) { StreamLogHandler.standardError(label: $0, metadataProvider: $1) }

        Core.logger = .init(label: "ÜNOG Bot")

        let bot = await BotGatewayManager(
            eventLoopGroup: http.eventLoopGroup,
            httpClient: http,
            token: Core.token,
            intents: []
        )

        Core.bot = bot

        Core.sheet = try! .init(spreadsheetID: Core.spreadsheetID)

        await bot.connect()
    }

    // swiftlint:disable:next unused_declaration
    static func main() async throws {
        _ = await Core()

        let commandsCreatePayload = [CreateVerificationMessage.createPayload]
        try await bot.client.bulkSetGuildApplicationCommands(
            guildId: Core.guildID,
            payload: commandsCreatePayload
        )
        .guardSuccess()

        for await event in await bot.events {
            EventHandler(event: event).handle()
        }
    }
}
