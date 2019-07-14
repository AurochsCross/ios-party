import Foundation
import UIKit
import Stevia

class ServersView: UIView {
    private let headerView = UIView()
    private let imageView = UIImageView()
    private let logoutButton = UIButton()
    
    private let listHeaderView = UIView()
    private let listHeaderServerTitle = UILabel()
    private let listHeaderDistanceTitle = UILabel()
    
    let serverTableView = UITableView()
    let serverRefreshControl = UIRefreshControl()
    
    let sortButton = UIButton()
    private let sortButtonContentContainer = UIView()
    private let sortButtonTitle = UILabel()
    private let sortButtonIcon = UIImageView()
    
    
    func setup() {
        setupLayout()
        setupLabels()
    }
    
    private func setupLayout() {
        sv(
            headerView.style(headerViewStyle).sv(
                imageView.style(logoImageViewStyle),
                logoutButton.style(logoutButtonStyle)
            ),
            serverTableView.style(serverTableViewStyle),
            listHeaderView.style(listHeaderViewStyle).sv(
                listHeaderServerTitle.style(listHeaderTitleStyle),
                listHeaderDistanceTitle.style(listHeaderTitleStyle)
            ),
            sortButton.style(sortButtonStyle).sv(
                sortButtonContentContainer.style(sortButtonContainerStyle).sv(
                    sortButtonIcon.style(sortButtonIconStyle),
                    sortButtonTitle.style(sortButtonTitleStyle)
                )
            )
        )
        
        layout(
            0,
            |headerView|,
            0,
            |listHeaderView|,
            0,
            |serverTableView|,
            0,
            |sortButton|,
            0
        )
        
        headerView.layout(
            (12 + Config.UI.topSafeArea),
            |-24-imageView-(>=0)-logoutButton-24-|,
            12
        )
        
        listHeaderView.layout(
            0,
            |-24-listHeaderServerTitle-(>=0)-listHeaderDistanceTitle.width(80)-24-|,
            0
        )
        
        sortButtonContentContainer.centerInContainer()
        
        sortButtonContentContainer.layout(
            0,
            |sortButtonIcon-6-sortButtonTitle|,
            0
        )
    }
    
    private func setupLabels() {
        listHeaderServerTitle.text = "Server".uppercased()
        listHeaderDistanceTitle.text = "Distance".uppercased()
    }
}

// MARK: - Styles
extension ServersView {
    private func headerViewStyle(_ v: UIView) {
        v.backgroundColor = UIColor.init(white: 0.93, alpha: 1.0)
        v.height(50 + Config.UI.topSafeArea)
    }
    
    private func logoImageViewStyle(_ v: UIImageView) {
        v.contentMode = .scaleAspectFit
        v.width(100)
        v.image = UIImage(named: "logo-dark")
    }
    
    private func logoutButtonStyle(_ v: UIButton) {
        v.setImage(UIImage(named: "ico-logout"), for: .normal)
        v.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    private func listHeaderViewStyle(_ v: UIView) {
        v.backgroundColor = .white
        v.height(50)
        
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.1
        v.layer.shadowOffset = CGSize(width: 0, height: 20)
        v.layer.shadowRadius = 15
    }
    
    private func listHeaderTitleStyle(_ v: UILabel) {
        v.textColor = .gray
        v.font = UIFont.systemFont(ofSize: 13, weight: .light)
    }
    
    private func serverTableViewStyle(_ v: UITableView) {
        v.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        v.separatorColor = .black
        v.refreshControl = serverRefreshControl
    }
    
    private func sortButtonStyle(_ v: UIButton) {
        v.backgroundColor = UIColor(red: 0.46, green: 0.38, blue: 0.72, alpha: 0.8)
        v.height(50 + Config.UI.botSafeArea)
    }
    
    private func sortButtonContainerStyle(_ v: UIView) {
        v.isUserInteractionEnabled = false
    }
    
    private func sortButtonIconStyle(_ v: UIImageView) {
        v.image = UIImage(named: "ico-sort-light")
    }
    
    private func sortButtonTitleStyle(_ v: UILabel) {
        v.text = "Sort"
        v.textColor = .white
    }
}
