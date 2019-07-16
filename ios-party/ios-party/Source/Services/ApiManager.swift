import Foundation

class ApiManager {
    func requestAuthentificationToken(forUser user: TokenServiceUser, completion: @escaping (_ result: TokenServiceResponse?, _ error: Error?) -> Void) {
        guard let jsonBody = user.getJsonData() else {
            completion(nil, AuthorizationError.invalidUserData)
            return
        }
        
        let url = URL(string: Config.Api.Endpoint.token)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 401 {
                completion(nil, AuthorizationError.unauthorized)
                return
            }
            
            guard let data = data else {
                completion(nil, AuthorizationError.emptyResponse)
                return
            }
            
            guard let tokenResponse = TokenServiceResponse.decode(fromData: data) else {
                completion(nil, AuthorizationError.unknown)
                return
            }
            
            completion(tokenResponse, nil)
        }
        task.resume()
    }
    
    func fetchServers(withToken token: String, completion: @escaping (_ result: [ServerServiceResponse]?, _ error: Error?) -> Void) {
        let url = URL(string: Config.Api.Endpoint.servers)!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 401 {
                completion(nil, AuthorizationError.unauthorized)
                return
            }
            
            if let data = data, let servers = ServerServiceResponseContainer.decode(fromData: data)?.servers {
                completion(servers, nil)
            }
        }
        task.resume()
    }
}
