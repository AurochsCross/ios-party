import UIKit
import Stevia

class ServerTableViewCell: UITableViewCell {
    struct Config {
        static let identifier = "ServerTableViewCell"
    }
    
    private let nameLabel = UILabel()
    private let distanceLabel = UILabel()
    
    func setup(name: String, distance: Int) {
        setupLayout()
        nameLabel.text = name
        distanceLabel.text = "\(distance) km"
    }
    
    private func setupLayout() {
        sv(
            nameLabel.style(labelStyle),
            distanceLabel.style(labelStyle)
        )
        
        layout(
            18,
            |-24-nameLabel-(>=0)-distanceLabel.width(80)-24-|,
            18
        )
    }
}

// Mark: - Styles
extension ServerTableViewCell {
    func labelStyle(_ v: UILabel) {
        v.textColor = UIColor.init(white: 0.3, alpha: 1.0)
        v.font = UIFont.systemFont(ofSize: 16, weight: .light)
    }
}
