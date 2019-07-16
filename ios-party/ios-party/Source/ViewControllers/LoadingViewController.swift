import Foundation
import UIKit

class LoadingViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var loadingImageView: UIImageView!
    
    // MARK: - Private variables
    private var serversModel: ServersModel?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        startSpinningAnimation()
        serversModel = ServersModel()
        serversModel?.delegate = self
        serversModel?.fetchServers()
    }
    
    // MARK: - Utility actions
    private func startSpinningAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear, animations: {
            self.loadingImageView.transform = self.loadingImageView.transform.rotated(by: -CGFloat(Double.pi))
        }) { finished in
            self.startSpinningAnimation()
        }
    }
}

// MARK: - ServersModelDelegate
extension LoadingViewController: ServersModelDelegate {
    func serversUpdated(_ servers: [Server]) {
        DispatchQueue.main.async {
            Router.shared.routeTo(screen: .serverList)
        }
    }
    
    func serverUpdateFailed(_ error: Error) {
        DispatchQueue.main.async {
            if let error = error as? AuthorizationError, error == AuthorizationError.unauthorized {
                AlertUtility.presentAlert(on: self, title: "Error", message: "Failed authorization") {
                    Router.shared.routeTo(screen: .login)
                }
                print("Server fetch error: unauthorized")
            } else {
                AlertUtility.presentAlert(on: self, title: "Error", message: error.localizedDescription)
                print("Server fetch error: \(error.localizedDescription)")
            }
        }
    }
}
