import Foundation

protocol ServersModelDelegate: class {
    func serversUpdated(_ servers: [Server])
    func serverUpdateFailed(_ error: Error)
}
