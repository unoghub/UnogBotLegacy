import DiscordBM

protocol InteractionHandler {
    var interaction: Interaction { get }
}

extension InteractionHandler {
    func followup(with message: Payloads.ExecuteWebhook) async throws {
        try await Main.bot.client.createFollowupMessage(
            token: interaction.token,
            payload: message
        )
        .guardSuccess()
    }
}
