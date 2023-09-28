import AsyncHTTPClient
import DiscordBM
import DiscordLogger
import DotEnv
import Foundation
import Logging

@main
class Main {
    struct EventHandler: GatewayEventHandler {
        let event: Gateway.Event

        func onInteractionCreate(_ interaction: Interaction) async {
            await InteractionCreateHandler(interaction: interaction).handle()
        }
    }

    static var bot: BotGatewayManager!
    static var logger: Logger!

    let token: String!
    let guildId: GuildSnowflake!
    let loggingWebhookURL: String!

    init() async {
        do { try DotEnv.load(path: ".env") } catch { print("not using .env file") }

        token = ProcessInfo.processInfo.environment["TOKEN"]
        guildId = GuildSnowflake(ProcessInfo.processInfo.environment["GUILD_ID"]!)
        loggingWebhookURL = ProcessInfo.processInfo.environment["LOGGING_WEBHOOK_URL"]

        let http = HTTPClient(eventLoopGroupProvider: .singleton)

        DiscordGlobalConfiguration.logManager = await .init(
            httpClient: http,
            configuration: .init(extraMetadata: [.error, .critical])
        )
        try! await LoggingSystem.bootstrapWithDiscordLogger(
            address: .url(loggingWebhookURL)
        ) { StreamLogHandler.standardError(label: $0, metadataProvider: $1) }
        Main.logger = .init(label: "ÜNOG Bot")

        let bot = await BotGatewayManager(
            eventLoopGroup: http.eventLoopGroup,
            httpClient: http,
            token: token,
            intents: []
        )

        Main.bot = bot

        await bot.connect()
    }

    // swiftlint:disable:next unused_declaration
    static func main() async throws {
        _ = await Main()

        // let commandsCreatePayload = []
        // try await bot.client.bulkSetGuildApplicationCommands(
        // guildId: testGuildId,
            // payload: commandsCreatePayload
        // )
        // .guardSuccess()

        let stream = await bot.makeEventsStream()
        for await event in stream {
            EventHandler(event: event).handle()
        }
    }
}
