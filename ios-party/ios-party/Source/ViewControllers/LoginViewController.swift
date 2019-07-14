import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var viewBottomSafeAreaConstraint: NSLayoutConstraint!
    
    private let sessionManager = SessionManager()
    
    override func viewDidLoad() {
        sessionManager.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
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

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.viewBottomSafeAreaConstraint.constant = 200
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.viewBottomSafeAreaConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            onLoginClicked(self)
            textField.resignFirstResponder()
        }
        
        return true
    }
}
