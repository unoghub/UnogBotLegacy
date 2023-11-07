import Foundation

class GoogleSheetsAPI: GoogleAPI {
    struct Spreadsheet: Decodable {
        let sheets: [Sheet]
    }

    struct Sheet: Decodable {
        let properties: SheetProperties
    }
    
    struct SheetProperties: Decodable {
        let gridProperties: GridProperties
    }
    
    struct GridProperties: Decodable {
        let rowCount: Int
    }

    struct ValueRange: Encodable, Decodable {
        let range: String
        let values: [[String]]
    }

    enum ValueInputOption: GoogleAPIEnum {
        case inputValueOptionUnspecified, raw, userEntered
    }

    let baseURL: URL

    init(spreadsheetID: String) throws {
        guard let url = URL(string: "https://sheets.googleapis.com/v4/spreadsheets/\(spreadsheetID)") else {
            Core.logger.error("sheets api base url is invalid")
            throw DefaultError()
        }

        baseURL = url
    }

    func getSpreadsheet() async throws -> Spreadsheet {
        return try await request(to: baseURL, method: .GET).send().body()
    }

    func append(
        range: String, values: ValueRange, valueInputOption: ValueInputOption = .userEntered
    ) async throws {
        let url = baseURL
            .appending(path: "values")
            .appending(path: "\(range):append")
            .appending(valueInputOption: valueInputOption)

        var request = try await request(to: url, method: .POST)
        try request.setBody(to: values)

        try await request.send()
    }

    func update(range: String, values: ValueRange, valueInputOption: ValueInputOption = .userEntered) async throws {
        let url = baseURL.appending(path: "values").appending(path: range).appending(valueInputOption: valueInputOption)

        var request = try await request(to: url, method: .PUT)
        try request.setBody(to: values)

        try await request.send()
    }
}
