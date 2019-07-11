extension Config.Api {
    static let server = "http://playground.tesonet.lt/v1/"
    
    struct Endpoint {
        static let token = server + "tokens"
        static let servers = server + "servers"
    }
}
