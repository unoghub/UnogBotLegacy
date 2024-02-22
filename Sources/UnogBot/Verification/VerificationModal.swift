import DiscordBM
import Foundation

struct VerificationModal {
    static let maxNicknameCharCount = 32
    static let maxEmailCharCount = 254
    static let maxBirthdayCharCount = 10
    static let maxYearsOfExperienceCharCount = 2
    static let maxOrganizationCharCount = 100

    static let modal = Payloads.InteractionResponse.Modal(
        custom_id: "VerificationModal", title: "📝 Doğrulanma Formu", textInputs: [
            .init(
                custom_id: "NameSurname",
                style: .short,
                label: nameSurnameFieldName.uppercased(with: Locale(identifier: "tr-TR")),
                max_length: VerificationModal.maxNicknameCharCount
            ),
            .init(custom_id: "Email", style: .short, label: "E-POSTA ADRESİ", max_length: maxEmailCharCount),
            .init(
                custom_id: "Birthday",
                style: .short,
                label: "DOĞUM TARİHİ",
                max_length: maxBirthdayCharCount,
                placeholder: "GG.AA.YYYY"
            ),
            .init(
                custom_id: "YearsOfExperience",
                style: .short,
                label: "KAÇ YILDIR OYUN SEKTÖRÜNDESİNİZ?",
                max_length: maxYearsOfExperienceCharCount
            ),
            .init(
                custom_id: "Organization",
                style: .short,
                label: "BULUNDUĞUNUZ KURUM VEYA EKİP",
                max_length: maxOrganizationCharCount,
                required: false
            )
        ]
    )

    static let nameSurnameFieldName = "İsim Soyisim"
    static let userFieldName = "Kullanıcı"

    let interaction: Interaction

    func handle() async throws {
        guard case let .modalSubmit(modalSubmit) = interaction.data else {
            throw VerificationError.verificationModalNotModalSubmit
        }

        try await interaction.ack(isEphemeral: true)

        let userID = try interaction.member.requireValue().user.requireValue().id.rawValue

        let textInputs = try modalSubmit.components.map { try $0.components.first.requireValue().requireTextInput() }

        var embed = Embed(
            title: "❔ Doğrulanma formu dolduruldu",
            color: .blue,
            fields: [
                .init(
                    name: VerificationModal.userFieldName,
                    value: "<@\(userID)>"
                )
            ]
        )

        var sheetValues = [String(userID)]
        for var textInput in textInputs {
            let label = try VerificationModal.modal.components.requireComponent(customId: textInput.custom_id)
                .requireTextInput()
                .label
                .requireValue()
                .capitalized(with: Locale(identifier: "tr-TR"))

            if textInput.value?.isEmpty == true {
                textInput.value = nil
            }
            var value: String = textInput.value ?? "Yok"
            if label == VerificationModal.nameSurnameFieldName {
                value = value.capitalized(with: Locale(identifier: "tr-TR"))
            }

            sheetValues.append(value)
            embed.fields?.append(.init(name: label, value: value))
        }
        sheetValues.append("Doğrulanmadı")

        try await Core.bot.client.createMessage(
            channelId: Core.submissionChannelID,
            payload: .init(embeds: [embed], components: [.init(components: [ApproveVerification.button])])
        )
        .guardSuccess()

        try await Core.sheet.append(
            range: "Doğrulanmalar!A:A", values: .init(range: "Doğrulanmalar!A:A", values: [sheetValues])
        )

        try await interaction.followup(with: .init(embeds: [
            Embed(
                title: "📨 Doğrulanma formunuz iletildi",
                description: "Formunuzda bir sorun yoksa yakında doğrulanacaksınız. Şimdiden hoş geldiniz!",
                color: .green
            )
        ]))
    }
}
