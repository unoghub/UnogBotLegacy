import DiscordBM

struct VerificationModal {
    static let maxNicknameCharCount = 32

    static let modal = Payloads.InteractionResponse.Modal(
        custom_id: "VerificationModal", title: "📝 Onaylanma Formu", textInputs: [
            .init(
                custom_id: "NameSurname",
                style: .short,
                label: VerificationModal.nameSurnameFieldName,
                max_length: VerificationModal.maxNicknameCharCount
            ),
            .init(custom_id: "Email", style: .short, label: "E-Posta Adresi"),
            .init(custom_id: "Birthday", style: .short, label: "Doğum Tarihi", placeholder: "GG.AA.YYYY"),
            .init(custom_id: "YearsOfExperience", style: .short, label: "Kaç yıldır oyun sektöründesiniz?"),
            .init(custom_id: "Organization", style: .short, label: "Bulunduğunuz Kurum veya Ekip", required: false)
        ]
    )

    static let nameSurnameFieldName = "İsim Soyisim"
    static let userFieldName = "Kullanıcı"

    let interaction: Interaction

    func handle() async throws {
        guard case let .modalSubmit(modalSubmit) = interaction.data else {
            Core.logger.error("verification modal submit interaction data is not of variant modal submit")
            throw DefaultError()
        }

        try await interaction.ack(isEphemeral: true)

        let userID = try interaction.member.requireValue().user.requireValue().id.rawValue

        var textInputs: [Interaction.ActionRow.TextInput] = []
        for actionRow in modalSubmit.components {
            textInputs.append(try actionRow.components.first.requireValue().requireTextInput())
        }

        var embed = Embed(
            title: "❔ Onaylama formu dolduruldu",
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

            if textInput.value?.isEmpty == true {
                textInput.value = nil
            }
            let value: String = textInput.value ?? "Yok"

            sheetValues.append(value)
            embed.fields?.append(.init(name: label, value: value))
        }
        sheetValues.append("Onaylanmadı")

        try await Core.bot.client.createMessage(
            channelId: Core.submissionChannelID,
            payload: .init(embeds: [embed], components: [.init(components: [ApproveVerification.button])])
        )
        .guardSuccess()

        try await Core.sheet.append(
            range: "Onaylanmalar!A:A", values: .init(range: "Onaylanmalar!A:A", values: [sheetValues])
        )

        try await interaction.followup(with: .init(embeds: [
            Embed(
                title: "📨 Onaylama formunuz iletildi",
                description: "Formunuzda bir sorun yoksa yakında onaylanacaksınız. Şimdiden hoş geldiniz!",
                color: .green
            )
        ]))
    }
}
