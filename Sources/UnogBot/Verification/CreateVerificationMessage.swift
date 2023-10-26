import DiscordBM
import Foundation

struct CreateVerificationMessage {
    static let createPayload = Payloads.ApplicationCommandCreate(
        name: "onaylanma_mesajını_at",
        description: "Bu kanala onaylanma mesajını at",
        default_member_permissions: [.manageGuild],
        type: .chatInput
    )

    let interaction: Interaction

    func handle() async throws {
        try await interaction.ack()

        try await interaction.followup(with: .init(components: [.init(components: [ShowVerificationModal.button])]))
    }
}
