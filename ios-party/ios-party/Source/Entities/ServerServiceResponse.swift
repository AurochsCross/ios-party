struct ServerServiceResponseContainer: Decodable {
    var servers: [ServerServiceResponse]
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        servers = try container.decodeArray(ServerServiceResponse.self)
    }
}

class ServerServiceResponse: Decodable {
    let name: String
    let distance: Int
}
