import DiscordBM
import Foundation

struct CreateVerificationMessage: InteractionHandler {
    static let createPayload = Payloads.ApplicationCommandCreate(
        name: "onaylanma_mesajını_at",
        description: "Bu kanala onaylanma mesajını at",
        default_member_permissions: [.manageGuild],
        type: .chatInput
    )

    let interaction: Interaction

    func handle() async throws {
        try await deferInteraction()

        let openVerificationButton = Interaction.ActionRow.Component.button(.init(
            style: .primary, label: "Onaylanma Formunu Aç", custom_id: ShowVerificationModal.customID
        ))

        try await followup(with: .init(components: [.init(components: [openVerificationButton])]))
    }
}
