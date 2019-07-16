import Foundation

class SessionManager {
    
    // MARK: - Public variables
    public static let shared = SessionManager()
    public var delegate: SessionManagerDelegate?
    
    // MARK: - Private variables
    private let apiManager = ApiManager()
    private let keychainManager = KeychainManager()
    
    
    // MARK: - Fields
    public var isAuthenticated: Bool {
        return token != nil
    }

    private(set) var token: String? {
        get {
            return keychainManager.token
        }
        set {
            keychainManager.token = newValue
        }
    }
    
    // MARK: - Public actions
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
    
    // MARK: - Private actions
    private func requestAuthentificationToken(forUser user: TokenServiceUser) {
        apiManager.requestAuthentificationToken(forUser: user) { (result, error) in
            if let error = error {
                self.delegate?.sessionManagerLoginError(self, error: error)
            } else if let result = result {
                self.token = result.token
                self.delegate?.sessionManagerLoginSuccessful(self)
            }
        }
    }
}
