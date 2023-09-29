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

        func onInteractionCreate(_ interaction: Interaction) async {
            await InteractionCreateHandler(interaction: interaction).handle()
        }
    }

    static var bot: BotGatewayManager!
    static var logger: Logger!

    static let token = ProcessInfo.processInfo.environment["TOKEN"]!
    static let guildId = GuildSnowflake(ProcessInfo.processInfo.environment["GUILD_ID"]!)
    static let loggingWebhookURL = ProcessInfo.processInfo.environment["LOGGING_WEBHOOK_URL"]!

    init() async {
        do { try DotEnv.load(path: ".env") } catch { print("not using .env file") }

        let http = HTTPClient(eventLoopGroupProvider: .singleton)

        DiscordGlobalConfiguration.logManager = await .init(
            httpClient: http,
            configuration: .init(extraMetadata: [.error, .critical])
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

        await bot.connect()
    }

    // swiftlint:disable:next unused_declaration
    static func main() async throws {
        _ = await Core()

        let commandsCreatePayload = [CreateVerificationMessage.createPayload]
        try await bot.client.bulkSetGuildApplicationCommands(
            guildId: Core.guildId,
            payload: commandsCreatePayload
        )
        .guardSuccess()

        let stream = await bot.makeEventsStream()
        for await event in stream {
            EventHandler(event: event).handle()
        }
    }
}
