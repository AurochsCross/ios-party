import Foundation
import UIKit
import CoreData

class ServersModel {
    enum SortType {
        case byDistance
        case alphanumerical
    }
    
    // Mark: - Public variables
    public weak var delegate: ServersModelDelegate?
    
    // Mark: - Private variables
    private var storedServers = [Server]()
    private var sortedServerCahce: [Server]?
    private var managedContext: NSManagedObjectContext?
    private var serverEntityDescription: NSEntityDescription?
    
    // Mark: - Public fields
    var availableServers: [Server] {
        return storedServers.filter { $0.isOnline }
    }
    
    var offlineServers: [Server] {
        return storedServers.filter { !$0.isOnline }
    }
    
    var sortType = SortType.alphanumerical {
        didSet {
            if oldValue != sortType {
                sortedServerCahce = nil
            }
        }
    }
    
    var servers: [Server] {
        get {
            return getServerList()
        }
    }
    
    // Mark: - Lifecycle
    init() {
        setupCoreData()
        fetchStoredServers()
    }
    
    deinit {
        managedContext = nil
    }
    
    // Mark: - Actions
    func getServerList(sorted sortType: SortType? = nil) -> [Server] {
        self.sortType = sortType ?? self.sortType
        
        if sortedServerCahce != nil {
            return sortedServerCahce!
        }
        
        sortedServerCahce = availableServers.sorted(by: { a, b in
            switch self.sortType {
            case .alphanumerical:
                return a.name ?? "" < b.name ?? ""
            case .byDistance:
                return a.distance < b.distance
            }
        })
        
        return sortedServerCahce!
    }
    
    func fetchServers() {
        guard let token = SessionManager.shared.token else { return }
        let url = URL(string: Config.Api.Endpoint.servers)!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                self.delegate?.serverUpdateFailed(error)
                return
            }
         
            if let response = response as? HTTPURLResponse, response.statusCode == 401 {
                self.delegate?.serverUpdateFailed(AuthorizationError.unauthorized)
                return
            }
            
            if let data = data, let servers = ServerServiceResponseContainer.decode(fromData: data)?.servers {
                self.updateServers(withReceivedServerList: servers)
            }
        }
        task.resume()
    }
    
    // Mark: - Private Actions
    private func updateServers(withReceivedServerList serverList: [ServerServiceResponse]) {
        sortedServerCahce = nil
        storedServers.forEach { $0.isOnline = false }
        serverList.forEach { receivedServer in
            if let storedServer = storedServers.first(where: { $0.name ?? "" == receivedServer.name }) {
                storedServer.distance = Int32(receivedServer.distance)
                storedServer.isOnline = true
            } else {
                saveServerLocaly(receivedServer)
            }
        }
        
        DispatchQueue.main.async {
            do {
                try self.managedContext?.save()
                self.delegate?.serversUpdated(self.storedServers)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    private func saveServerLocaly(_ server: ServerServiceResponse) {
        guard let entity = serverEntityDescription else { return }
        
        let localServer = Server(entity: entity, insertInto: managedContext)
        localServer.name = server.name
        localServer.distance = Int32(server.distance)
        localServer.isOnline = true
        
        storedServers.append(localServer)
    }
    
    private func fetchStoredServers() {
        guard let managedContext = managedContext else { return }
        let fetchRequest = NSFetchRequest<Server>(entityName: Config.CoreData.serverEntityName)
        
        do {
            storedServers = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    private func setupCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        managedContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedContext?.persistentStoreCoordinator = appDelegate.persistentContainer.persistentStoreCoordinator
        serverEntityDescription = NSEntityDescription.entity(forEntityName: Config.CoreData.serverEntityName, in: managedContext!)
    }
}
