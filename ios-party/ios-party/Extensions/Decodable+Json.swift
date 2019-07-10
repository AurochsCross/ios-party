import Foundation

extension Decodable {
    static func decode(fromData data: Data) -> Self? {
        do {
            return try JSONDecoder().decode(self, from: data)
        } catch {
            print("Failed to decode JSON")
        }
        
        return nil
    }
}
