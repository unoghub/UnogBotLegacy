import DiscordBM

struct ApproveVerification {
    static let mentionStartCharacterCount = 2
    static let mentionEndCharacterCount = 1

    static let button = Interaction.ActionRow.Component.button(.init(
        style: .success, label: "Onayla", custom_id: "ApproveVerification"
    ))

    let interaction: Interaction

    func handle() async throws {
        try await interaction.ack()

        let guildID = try interaction.guild_id.requireValue()

        let embedFields = try (
            interaction.message?.embeds.first?.fields
        ).requireValue()

        let userID = UserSnowflake(String(try (
            embedFields.first { $0.name == VerificationModal.userFieldName }?.value
                .dropFirst(ApproveVerification.mentionStartCharacterCount)
                .dropLast(ApproveVerification.mentionEndCharacterCount)
        ).requireValue()))
        let nameSurname = try embedFields.first { $0.name == VerificationModal.nameSurnameFieldName }
            .requireValue()
            .value

        try await Core.bot.client.updateGuildMember(
            guildId: guildID, userId: userID, payload: .init(nick: nameSurname)
        )
        .guardSuccess()

        let rowIndex = try await Core.sheet.getSpreadsheet().sheets.first.requireValue().properties.gridProperties.rowCount - 1
        let cellRange = "Onaylanmalar!G\(rowIndex)"
        try await Core.sheet.update(range: cellRange, values: .init(range: cellRange, values: [["Onaylandı"]]))

        try await interaction.followup(with: .init(embeds: [
            .init(title: "✅ Kullanıcı onaylandı", color: .green, fields: [
                .init(name: "Nick", value: "Kullanıcının nick'i *\(nameSurname)* olarak ayarlandı"),
                .init(name: "Sheet", value: "[ÛNOG Onaylanmalar](\(Core.sheet.viewURL))")
            ])
        ]))
    }
}
