import Foundation

extension URL {
    func appending(valueInputOption: GoogleSheetsAPI.ValueInputOption) -> URL {
        self.appending(queryItems: [.init(name: "valueInputOption", value: valueInputOption.value)])
    }
}
