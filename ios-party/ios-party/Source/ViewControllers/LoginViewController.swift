import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private let sessionManager = SessionManager()
    
    override func viewDidLoad() {
        sessionManager.delegate = self
    }
    
    @IBAction func onLoginClicked(_ sender: Any) {
        if let username = usernameTextField.text,
            let password = passwordTextField.text {
            sessionManager.login(withUsername: username,
                                 password: password)
        }
    }
}

extension LoginViewController: SessionManagerDelegate {
    func sessionManagerLoginSuccessful(_ sessionManager: SessionManager) {
        print("Login successful")
    }
    
    func sessionManagerLoginError(_ sessionManager: SessionManager, error: Error) {
        if let error = error as? AuthorizationError, error == AuthorizationError.unauthorized {
            print("Login error: unauthorized")
        } else {
            print("Login error: \(error.localizedDescription)")
        }
    }
}
