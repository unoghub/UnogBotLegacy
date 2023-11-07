import Foundation

extension TimeInterval {
    static let timeBase = 60.0
    static let minute = Self(timeBase)
    static let hour = minute * timeBase
}
