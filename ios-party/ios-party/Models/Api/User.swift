import Foundation

struct User: Encodable, Decodable {
    let username: String
    let password: String
}
