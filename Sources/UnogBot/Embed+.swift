import DiscordBM
import Foundation

extension Embed {
    init(errorMessage: String) {
        self.init(title: "😔 Bir sorun var", description: errorMessage, color: DiscordColor.red)
    }

    static func internalError() -> Embed {
        self.init(errorMessage: """
        Bir şeyler ters gitti, ama merak etme, hatayı hemen geliştiricime ilettim, çözmek için kolları sıvamıştır bile.
        """)
    }
}
