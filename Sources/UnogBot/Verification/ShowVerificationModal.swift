import DiscordBM

struct ShowVerificationModal: InteractionHandler {
    static let customID = "ShowVerificationModal"

    let interaction: Interaction

    func handle() async throws {
        try await showModal(VerificationModal.modal)
    }
}
