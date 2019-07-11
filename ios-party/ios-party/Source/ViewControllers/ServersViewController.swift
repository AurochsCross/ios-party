import Foundation
import UIKit

class ServersViewController: UIViewController {
    private let serversModel = ServersModel()
    
    override func loadView() {
        let serversView = ServersView()
        self.view = serversView
        serversView.setup()
        
        serversView.serverTableView.register(ServerTableViewCell.self, forCellReuseIdentifier: ServerTableViewCell.Config.identifier)
        serversView.serverTableView.dataSource = self
        serversView.serverRefreshControl.addTarget(self, action: #selector(updateServers), for: .valueChanged)
        
        serversView.sortButton.addTarget(self, action: #selector(chooseSortSelected), for: .touchUpInside)
        
        serversModel.delegate = self
    }
    
    @objc private func updateServers() {
        serversModel.fetchServers()
    }
    
    @objc private func chooseSortSelected() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let sortByDistanceAction = UIAlertAction(title: "By Distance", style: .default) { (action) in
            self.serversModel.sortType = .byDistance
            self.reloadTableWithAnimation()
        }
        
        let sortByAlphanumericalAction = UIAlertAction(title: "Alphanumerical", style: .default) { (action) in
            self.serversModel.sortType = .alphanumerical
            self.reloadTableWithAnimation()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheet.addAction(sortByDistanceAction)
        actionSheet.addAction(sortByAlphanumericalAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func reloadTableWithAnimation() {
        if let view = self.view as? ServersView {
            UIView.transition(with: view.serverTableView, duration: 1.0, options: .transitionCrossDissolve, animations: { view.serverTableView.reloadData() }, completion: nil)
        }
    }
}

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
        
    }
}
