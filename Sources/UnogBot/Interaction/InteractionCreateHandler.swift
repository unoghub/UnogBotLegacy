import DiscordBM

class InteractionCreateHandler: InteractionHandler {
    let interaction: Interaction

    init(interaction: Interaction) {
        self.interaction = interaction
    }

    func handle() async {
        do {
            try await Main.bot.client.createInteractionResponse(
                id: interaction.id, token: interaction.token, payload: .deferredChannelMessageWithSource()
            )
            .guardSuccess()

            switch interaction.data {
            case let .applicationCommand(command) where command.name == CreateVerificationMessage.createPayload.name:
                try await CreateVerificationMessage(interaction: interaction).handle()

            default:
                Main.logger.error("unknown interaction: \(interaction)")
                throw DefaultError()
            }
        } catch {
            do {
                try await followup(
                    with: .init(
                        embeds: [
                            Embed.internalError(),
                        ]
                    )
                )
            } catch {
                Main.logger.error("couldn't followup with the default error embed: \(error)")
            }
            Main.logger.error("couldn't handle interaction: \(error)")
        }
    }
}
