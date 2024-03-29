import DiscordBM

struct ApproveVerification {
    static let mentionStartCharacterCount = 2
    static let mentionEndCharacterCount = 1

    static let button = Interaction.ActionRow.Component.button(.init(
        style: .success, label: "Doğrula", custom_id: "ApproveVerification"
    ))

    let interaction: Interaction

    func handle() async throws {
        try await showLoading()

        let guildID = try interaction.guild_id.requireValue()

        let embedFields = try (
            interaction.message?.embeds.first?.fields
        ).requireValue()

        let userMention = try embedFields.first { $0.name == VerificationModal.userFieldName }.requireValue().value
        let userID = UserSnowflake(
            String(
                userMention
                    .dropFirst(ApproveVerification.mentionStartCharacterCount)
                    .dropLast(ApproveVerification.mentionEndCharacterCount)
            )
        )

        let nameSurname = try embedFields.first { $0.name == VerificationModal.nameSurnameFieldName }
            .requireValue()
            .value
        try await updateNick(ofUser: userID, inGuild: guildID, to: nameSurname)

        try await Core.bot.client.addGuildMemberRole(guildId: guildID, userId: userID, roleId: Core.verifiedRoleID)
            .guardSuccess()

        try await updateSheet()

        try await Core.bot.client.updateOriginalInteractionResponse(
            token: interaction.token, payload: .init(
                embeds: [
                    .init(
                        title: "✅ Kullanıcı doğrulandı", color: .green, fields: [
                            .init(name: "Nick", value: "Kullanıcının nick'i *\(nameSurname)* olarak ayarlandı."),
                            .init(
                                name: "Rol", value: "Kullanıcıya *<@&\(Core.verifiedRoleID.rawValue)>* rolü verildi."
                            ),
                            .init(
                                name: "Sheet",
                                value: "[ÜNOG Doğrulanmalar](\(Core.sheet.viewURL))'daki doğrulanma durumu güncellendi."
                            )
                        ] + embedFields
                    )
                ],
                components: []
            )
        )
        .guardSuccess()
    }

    func showLoading() async throws {
        try await Core.bot.client.createInteractionResponse(
            id: interaction.id, token: interaction.token, payload: .updateMessage(
                .init(
                    embeds: [
                        .init(
                            title: "🔄 Kullanıcı doğrulanıyor",
                            description: "Bu sadece birkaç saniye sürecek.",
                            color: .yellow
                        )
                    ],
                    components: []
                )
            )
        )
        .guardSuccess()
    }

    func updateSheet() async throws {
        let rowIndex = try await Core
            .sheet
            .getSpreadsheet()
            .sheets
            .first
            .requireValue()
            .properties
            .gridProperties
            .rowCount
        let cellRange = "Doğrulanmalar!G\(rowIndex)"
        try await Core.sheet.update(range: cellRange, values: .init(range: cellRange, values: [["Doğrulandı"]]))
    }

    func updateNick(ofUser userID: UserSnowflake, inGuild guildID: GuildSnowflake, to nick: String) async throws {
        try await Core.bot.client.updateGuildMember(
            guildId: guildID, userId: userID, payload: .init(nick: nick)
        )
        .guardSuccess()
    }
}
