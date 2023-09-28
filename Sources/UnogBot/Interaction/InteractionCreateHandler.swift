import DiscordBM

class InteractionCreateHandler: InteractionHandler {
    let interaction: Interaction

    init(interaction: Interaction) {
        self.interaction = interaction
    }

    func handle() async {
        do {
            switch interaction.data {
            case let .applicationCommand(command) where command.name == CreateVerificationMessage.createPayload.name:
                try await CreateVerificationMessage(interaction: interaction).handle()

            case let .messageComponent(component) where component.custom_id == ShowVerificationModal.customID:
                try await ShowVerificationModal(interaction: interaction).handle()

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
