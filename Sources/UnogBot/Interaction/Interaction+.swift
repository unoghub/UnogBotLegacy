import DiscordBM

extension Interaction {
    var name: String? {
        switch data {
        case let .applicationCommand(command):
            return command.name

        case let .messageComponent(component):
            return component.custom_id

        case let .modalSubmit(modal):
            return modal.custom_id

        case .none:
            return nil
        }
    }

    func ack(isEphemeral: Bool = false) async throws {
        try await Core.bot.client.createInteractionResponse(
            id: id,
            token: token,
            payload: .deferredChannelMessageWithSource(isEphemeral: isEphemeral)
        )
        .guardSuccess()
    }

    func followup(with message: Payloads.ExecuteWebhook, isEphemeral: Bool = false) async throws {
        try await Core.bot.client.createFollowupMessage(token: token, payload: message).guardSuccess()
    }

    func showModal(_ modal: Payloads.InteractionResponse.Modal) async throws {
        try await Core.bot.client.createInteractionResponse(
            id: id, token: token, payload: .modal(modal)
        )
        .guardSuccess()
    }
}
