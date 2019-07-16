import Foundation

extension Encodable {
    func getJsonData() -> Data? {
        do {
            let jsonData = try JSONEncoder().encode(self)
            let jsonString = String(data: jsonData, encoding: .utf8)
            print(jsonString!)
            return jsonData
        } catch {
            return nil
        }
    }
}
