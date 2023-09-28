import DiscordBM

struct ShowVerificationModal: InteractionHandler {
    static let maxNicknameCharCount = 32

    static let customID = "ShowVerificationModal"

    static let modal = Payloads.InteractionResponse.Modal(
        custom_id: "VerificationModal", title: "Doğrulama Formu", textInputs: [
            .init(
                custom_id: "NameSurname",
                style: .short,
                label: "İsim Soyisim",
                max_length: ShowVerificationModal.maxNicknameCharCount
            ),
            .init(custom_id: "Email", style: .short, label: "E-Posta Adresi"),
            .init(custom_id: "Birthday", style: .short, label: "Doğum Tarihi", placeholder: "GG.AA.YYYY"),
            .init(custom_id: "YearsOfExperience", style: .short, label: "Kaç yıldır oyun sektöründesiniz?"),
            .init(custom_id: "Organization", style: .short, label: "Bulunduğunuz Kurum veya Ekip", required: false)
        ]
    )

    let interaction: Interaction

    func handle() async throws {
        try await showModal(ShowVerificationModal.modal)
    }
}
