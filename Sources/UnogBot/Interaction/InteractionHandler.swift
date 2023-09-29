import DiscordBM

protocol InteractionHandler {
    var interaction: Interaction { get }
}

extension InteractionHandler {
    func deferInteraction(isEphemeral: Bool = false) async throws {
        try await Core.bot.client.createInteractionResponse(
            id: interaction.id,
            token: interaction.token,
            payload: .deferredChannelMessageWithSource(isEphemeral: isEphemeral)
        )
        .guardSuccess()
    }

    func followup(with message: Payloads.ExecuteWebhook) async throws {
        try await Core.bot.client.createFollowupMessage(
            token: interaction.token,
            payload: message
        )
        .guardSuccess()
    }

    func showModal(_ modal: Payloads.InteractionResponse.Modal) async throws {
        try await Core.bot.client.createInteractionResponse(
            id: interaction.id, token: interaction .token, payload: .modal(modal)
        )
        .guardSuccess()
    }
}
