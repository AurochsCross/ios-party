import UIKit

class LoginViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var viewBottomSafeAreaConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private variables
    private let sessionManager = SessionManager()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        sessionManager.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        loginActivityIndicator.stopAnimating()
    }
    
    // MARK: - Actions
    @IBAction func onLoginClicked(_ sender: Any) {
        if let username = usernameTextField.text,
            let password = passwordTextField.text {
            sessionManager.login(withUsername: username,
                                 password: password)
            startLoginAnimating()
        }
    }
    
    private func startLoginAnimating() {
        loginButton.setTitle(nil, for: .normal)
        loginButton.isUserInteractionEnabled = false
        loginActivityIndicator.startAnimating()
    }
    
    private func stopLoginAnimating() {
        loginButton.setTitle("Log In", for: .normal)
        loginButton.isUserInteractionEnabled = true
        loginActivityIndicator.stopAnimating()
    }
}

// MARK: - SessionManagerDelegate
extension LoginViewController: SessionManagerDelegate {
    func sessionManagerLoginSuccessful(_ sessionManager: SessionManager) {
        DispatchQueue.main.async {
            self.stopLoginAnimating()
            Router.shared.routeTo(screen: .loading)
        }
    }
    
    func sessionManagerLoginError(_ sessionManager: SessionManager, error: Error) {
        DispatchQueue.main.async {
            self.stopLoginAnimating()
            if let error = error as? AuthorizationError, error == AuthorizationError.unauthorized {
                AlertUtility.presentAuthorizationFailedAlert(onView: self, routeToLoginScreen: false)
                print("Login error: unauthorized")
            } else {
                AlertUtility.presentGenericErrorAlert(onView: self, error: error)
                print("Login error: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - UITextFieldDelegate
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
