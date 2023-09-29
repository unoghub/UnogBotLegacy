import DiscordBM
import Foundation

enum VerificationCore {
    static var submissionChannelId =
        ChannelSnowflake(ProcessInfo.processInfo.environment["VERIFICATION_SUBMISSIONS_CHANNEL_ID"]!)
}
