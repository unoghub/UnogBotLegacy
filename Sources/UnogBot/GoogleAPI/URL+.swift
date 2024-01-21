import Foundation

extension URL {
    func appending(valueInputOption: GoogleSheetsAPI.ValueInputOption) throws -> URL {
        var urlComponents = try URLComponents(string: self.absoluteString).requireValue()
        urlComponents.queryItems = [.init(name: "valueInputOption", value: valueInputOption.value)]
        return try urlComponents.url.requireValue()
    }
}
