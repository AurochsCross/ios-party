import UIKit

class LoginViewController: UIViewController {
    
    struct ViewConfig {
        static let nibName = "LoginView"
    }
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private let sessionManager = SessionManager()
    
    init() {
        super.init(
            nibName: ViewConfig.nibName,
            bundle: nil)
        
        sessionManager.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
        print(error.localizedDescription)
    }
}
