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
        try await interaction.ack(isEphemeral: true)

        try await Core.bot.client.createMessage(
            channelId: interaction.channel_id.requireValue(),
            payload: .init(components: [.init(components: [ShowVerificationModal.button])])
        )
        .guardSuccess()

        try await interaction.followup(
            with: .init(
                embeds: [
                    .init(
                        title: "📨 Onaylanma mesajı atıldı",
                        description: "Kullanıcılar bu mesajdaki butonu kullanarak onaylanma formunu açabilecek.",
                        color: .green
                    )
                ]
            )
        )
    }
}
