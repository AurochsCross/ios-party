import UIKit

class AlertUtility {
    static func presentAlert(on viewController: UIViewController, title: String, message: String, onCancel completion: @escaping () -> Void = { }) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            completion()
        }
        
        alert.addAction(cancelAction)
        viewController.present(alert, animated: true)
    }
}
