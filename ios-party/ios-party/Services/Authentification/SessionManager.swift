import Foundation

class SessionManager {
    public static let shared = SessionManager()
    
    public var delegate: SessionManagerDelegate?
    private var currentUser: User?
    private(set) var token: String?
    
    public func login(withUsername username: String, password: String) {
        currentUser = User(username: username, password: password)
        requestAuthentificationToken(forUser: currentUser!)
    }
    
    private func requestAuthentificationToken(forUser user: User) {
        guard let jsonBody = user.getJsonData() else { return }
        
        let url = URL(string: Config.Api.tokenServiceEndpoint)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                self.delegate?.sessionManagerLoginError(self, error: error)
            } else {
                if let data = data {
                    if let tokenResponse = TokenServiceResponse.decode(fromData: data) {
                        self.token = tokenResponse.token
                        self.delegate?.sessionManagerLoginSuccessful(self)
                    } else {
                        self.delegate?.sessionManagerLoginError(self, error: AuthorizationError.unknown)
                    }
                }
            }
        }
        task.resume()
    }
}
