import DiscordBM

struct ShowVerificationModal {
    static let button = Interaction.ActionRow.Component.button(.init(
        style: .primary, label: "Onaylanma Formunu Aç", custom_id: "ShowVerificationModal"
    ))

    let interaction: Interaction

    func handle() async throws {
        try await interaction.showModal(VerificationModal.modal)
    }
}
