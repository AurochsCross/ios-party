import UIKit

class AlertUtility {
    static func presentAuthorizationFailedAlert(onView viewController: UIViewController, routeToLoginScreen: Bool) {
        let alert = UIAlertController(title: "Error", message: "Failed authorization", preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Close", style: .default) { (action) in
            SessionManager.shared.logout()
            if routeToLoginScreen {
                Router.shared.routeTo(screen: .login)
            }
        }
        
        alert.addAction(closeAction)
        viewController.present(alert, animated: true)
    }
    
    static func presentGenericErrorAlert(onView viewController: UIViewController, error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Close", style: .default)
        
        alert.addAction(closeAction)
        viewController.present(alert, animated: true)
    }
}
