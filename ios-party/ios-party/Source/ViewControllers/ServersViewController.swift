import Foundation
import UIKit

class ServersViewController: UIViewController {
    // MARK: - Private variables
    private let serversModel = ServersModel()
    
    // MARK: - Lifecycle
    override func loadView() {
        let serversView = ServersView()
        self.view = serversView
        serversView.setup()
        
        serversView.serverTableView.register(ServerTableViewCell.self, forCellReuseIdentifier: ServerTableViewCell.Config.identifier)
        serversView.serverTableView.dataSource = self
        serversView.serverRefreshControl.addTarget(self, action: #selector(updateServers), for: .valueChanged)
        serversView.logoutButton.addTarget(self, action: #selector(logoutSelected), for: .touchUpInside)
        serversView.sortButton.addTarget(self, action: #selector(chooseSortSelected), for: .touchUpInside)
        
        serversModel.delegate = self
    }
    
    // MARK: - Actions
    @objc private func updateServers() {
        serversModel.fetchServers()
    }
    
    @objc private func chooseSortSelected() {
        displaySortButton(false)
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.popoverPresentationController?.sourceView = view
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY - 60, width: 0, height: 0)
        
        let sortByDistanceAction = UIAlertAction(title: "By Distance", style: .default) { (action) in
            self.serversModel.sortType = .byDistance
            self.reloadTableWithAnimation()
            self.displaySortButton(true)
        }
        
        let sortByAlphanumericalAction = UIAlertAction(title: "Alphanumerical", style: .default) { (action) in
            self.serversModel.sortType = .alphanumerical
            self.reloadTableWithAnimation()
            self.displaySortButton(true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.displaySortButton(true)
        }
        
        actionSheet.addAction(sortByDistanceAction)
        actionSheet.addAction(sortByAlphanumericalAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true)
    }
    
    @objc private func logoutSelected() {
        SessionManager.shared.logout()
        Router.shared.routeTo(screen: .login)
    }
    
    private func reloadTableWithAnimation() {
        if let view = self.view as? ServersView {
            UIView.transition(with: view.serverTableView, duration: 1.0, options: .transitionCrossDissolve, animations: { view.serverTableView.reloadData() }, completion: nil)
        }
    }
    
    func displaySortButton(_ shouldDisplay: Bool) {
        guard let sortButton = (view as? ServersView)?.sortButton else { return }
        sortButton.heightConstraint?.constant = (shouldDisplay ? (50 + Config.UI.botSafeArea) : 0)
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UITableViewDataSource
extension ServersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serversModel.availableServers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ServerTableViewCell.Config.identifier) as? ServerTableViewCell else { return UITableViewCell() }
        
        let server = serversModel.servers[indexPath.item]
        cell.setup(name: server.name!, distance: Int(server.distance))
        
        return cell
    }
}

// MARK: - ServersModelDelegate
extension ServersViewController: ServersModelDelegate {
    func serversUpdated(_ servers: [Server]) {
        DispatchQueue.main.async {
            if let view = self.view as? ServersView {
                view.serverRefreshControl.endRefreshing()
                self.reloadTableWithAnimation()
            }
        }
    }
    
    func serverUpdateFailed(_ error: Error) {
        DispatchQueue.main.async {
            if let error = error as? AuthorizationError, error == AuthorizationError.unauthorized {
                AlertUtility.presentAuthorizationFailedAlert(onView: self, routeToLoginScreen: true)
                print("Server fetch error: unauthorized")
            } else {
                AlertUtility.presentGenericErrorAlert(onView: self, error: error)
                print("Server fetch error: \(error.localizedDescription)")
            }
        }
    }
}
