import Foundation
import UIKit

class Router {
    enum RoutableScreen {
        case loading
        case login
        case serverList
        
        func getViewController() -> UIViewController {
            switch self {
            case .loading: return LoadingViewController()
            case .login: return LoginViewController()
            case .serverList: return ServersViewController()
            }
        }
    }
    
    static let shared = Router()
    private let sessionManager = SessionManager.shared
    
    func getInitialViewController() -> UIViewController {
        if sessionManager.isAuthenticated {
            return RoutableScreen.loading.getViewController()
        } else {
            return RoutableScreen.login.getViewController()
        }
    }
    
    func routeTo(screen screenType: RoutableScreen) {
        UIApplication.setRootView(screenType.getViewController(), options: .transitionCrossDissolve, animated: true, duration: 0.5)
    }
}
