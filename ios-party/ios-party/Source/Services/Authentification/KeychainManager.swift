import Foundation
import KeychainAccess

class KeychainManager {
    private let keychain = Keychain(service: Config.Security.keychainService)
    
    var token: String? {
        get {
            return keychain[Config.Security.keychainTokenKey]
        } set {
            keychain[Config.Security.keychainTokenKey] = newValue
        }
    }
}
