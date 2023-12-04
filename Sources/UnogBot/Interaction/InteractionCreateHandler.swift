import DiscordBM

class InteractionCreateHandler {
    let interaction: Interaction

    init(interaction: Interaction) {
        self.interaction = interaction
    }

    func handle() async {
        do {
            switch interaction.name {
            case CreateVerificationMessage.createPayload.name:
                try await CreateVerificationMessage(interaction: interaction).handle()

            case ShowVerificationModal.button.customId:
                try await ShowVerificationModal(interaction: interaction).handle()

            case ApproveVerification.button.customId:
                try await ApproveVerification(interaction: interaction).handle()

            case VerificationModal.modal.custom_id:
                try await VerificationModal(interaction: interaction).handle()

            default:
                Core.logger.error("unknown interaction: \(interaction)")
                throw DefaultError()
            }
        } catch {
            do {
                try await interaction.followup(with: .init(embeds: [Embed.internalError()], flags: [.ephemeral]))
            } catch {
                Core.logger.error("couldn't followup with the default error embed: \(error)")
            }
            Core.logger.error("couldn't handle interaction: \(error)")
        }
    }
}
