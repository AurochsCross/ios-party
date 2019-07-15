import Foundation

class SessionManager {
    
    // Mark: - Public variables
    public static let shared = SessionManager()
    public var delegate: SessionManagerDelegate?
    
    // Mark: - Private variables
    private let keychainManager = KeychainManager()
    
    
    // Mark: - Fields
    public var isAuthenticated: Bool {
        return token != nil
    }

    private(set) var token: String? {
        get {
            return keychainManager[Config.Security.keychainTokenKey]
        }
        set {
            keychainManager[Config.Security.keychainTokenKey] = newValue
        }
    }
    
    // Mark: - Public actions
    public func login(withUsername username: String, password: String) {
        if isAuthenticated {
            logout()
        }
        
        let user = TokenServiceUser(username: username, password: password)
        requestAuthentificationToken(forUser: user)
    }
    
    public func logout() {
        token = nil
    }
    
    private func requestAuthentificationToken(forUser user: TokenServiceUser) {
        guard let jsonBody = user.getJsonData() else { return }
        
        let url = URL(string: Config.Api.Endpoint.token)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody
        
        let task = URLSession.shared.dataTask(with: request) { [unowned self] (data, response, error) in
            if let error = error {
                self.delegate?.sessionManagerLoginError(self, error: error)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 401 {
                self.delegate?.sessionManagerLoginError(self, error: AuthorizationError.unauthorized)
                return
            }
            
            guard let data = data else {
                self.delegate?.sessionManagerLoginError(self, error: AuthorizationError.emptyResponse)
                return
            }
            
            guard let tokenResponse = TokenServiceResponse.decode(fromData: data) else {
                self.delegate?.sessionManagerLoginError(self, error: AuthorizationError.unknown)
                return
            }
            
            self.token = tokenResponse.token
            self.delegate?.sessionManagerLoginSuccessful(self)
        }
        task.resume()
    }
}
