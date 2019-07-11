import Foundation
import UIKit

class ServersViewController: UIViewController {
    private let serversModel = ServersModel()
    @IBOutlet weak var serversTableView: UITableView!
    
    override func viewDidLoad() {
        serversModel.delegate = self
        serversTableView.dataSource = self
        serversTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
    }
    
    @IBAction func refreshServers(_ sender: Any) {
        serversModel.getServers()
    }
}

extension ServersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serversModel.storedServers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        let server = serversModel.storedServers.sorted(by: { $0.name! < $1.name! })[indexPath.item]
        
        cell?.textLabel?.text = server.name
        cell?.textLabel?.textColor = server.isOnline ? UIColor.blue : UIColor.red
        cell?.detailTextLabel?.text = String(server.distance)
        
        return cell!
    }
}

extension ServersViewController: ServersModelDelegate {
    func serversUpdated(_ servers: [Server]) {
        DispatchQueue.main.async {
            self.serversTableView.reloadData()
        }
    }
    
    func serverUpdateFailed(_ error: Error) {
        
    }
}
