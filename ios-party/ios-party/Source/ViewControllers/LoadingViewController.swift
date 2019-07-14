import Foundation
import UIKit

class LoadingViewController: UIViewController {
    
    @IBOutlet weak var loadingImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startSpinningAnimation()
    }
    
    private func startSpinningAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear, animations: {
            self.loadingImageView.transform = self.loadingImageView.transform.rotated(by: -CGFloat(Double.pi))
        }) { finished in
            self.startSpinningAnimation()
        }
    }
    
}
