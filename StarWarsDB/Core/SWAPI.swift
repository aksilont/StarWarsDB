import Foundation
import SwiftyJSON

class SWAPI {
    
    private(set) static var shared: SWAPI = {
        return SWAPI()
    }()
    
    func get(_ model: ModelType, withId id: Int) throws -> JSON {
        let url = try urlWith(model: model, id: id)
        return try get(at: url)
    }
    
    func get(at url: URL) throws -> JSON {
        
        guard let data = try sendDataTask(with: url)?.unwrap() else {
            throw APIError.unexpectedResponse
        }
        
        let json = JSON(data)
        
        if let error = json.error {
            throw error
        }
        
        return json
    }
    
    func getAll(_ model: ModelType, completion: @escaping ([JSON]) -> Void) {
        DispatchQueue.global().async {
            do {
                try completion(self.getAll(model))
            } catch {
                debugPrint("Cant get all \(model) with error: \(error)")
                completion([])
            }
        }
    }
    
    func getAll(_ model: ModelType) throws -> [JSON] {
        var results = [JSON]()
        try getAll(url: urlWith(model: model), results: &results)
        return results
    }
    
    private func getAll(url: URL, results: inout [JSON]) throws {
        guard let data = try sendDataTask(with: url)?.unwrap() else {
            throw APIError.unexpectedResponse
        }
        
        let json = JSON(data)
        
        if let error = json.error {
            throw error
        }
        
        results.append(contentsOf: json["results"].arrayValue)
        
        if let url = json["next"].url {
            try getAll(url: url, results: &results)
        }
    }
    
    private func sendDataTask(with url: URL) -> APIResult? {
        let semaphore = DispatchSemaphore(value: 0)
        var result: APIResult?
        
        session.dataTask(with: url) { data, _, error in
            defer { semaphore.signal() }
            
            if let data = data {
                result = .data(data)
            } else if let error = error {
                result = .error(error)
            }
        }.resume()
        
        debugPrint("Load \(url.absoluteString)")
        semaphore.wait()
        
        return result
    }
    
    private func urlWith(model: ModelType, id: Int? = nil) throws -> URL {
        let stringId = id != nil ? String(describing: id ?? -1) : ""
        
        guard let url = try URL(string: "\(model.rawValue)\(stringId)", relativeTo: baseUrl()) else {
            throw APIError.cantCreateRelativeUrl
        }
        
        return url
    }
    
    static func nextPage(with currentUrl: URL, currentPage: Int) throws -> URL {
        guard var components = URLComponents(url: currentUrl, resolvingAgainstBaseURL: true) else {
            throw APIError.cantCreateNextPageComponents
        }
        
        var queryItems = [URLQueryItem]()
        let queryItem = URLQueryItem(name: "page", value: "\(currentPage+1)")
        queryItems.append(queryItem)
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw APIError.cantCreateNextPage
        }
        
        return url
    }
    
    private func baseUrl() throws -> URL {
        guard let url = URL(string: "https://swapi.dev/api/") else {
            throw APIError.cantCreateBaseUrl
        }
        
        return url
    }
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
}

enum ModelType: String {
    case people = "people/"
    case films = "films/"
    case planets = "planets/"
    case species = "species/"
    case starships = "starships/"
    case vehicles = "vehicles/"
}

enum APIResult {
    case data(Data)
    case error(Error)
    
    func unwrap() throws -> Data {
        switch self {
        case let .data(data):
            return data
        case let .error(error):
            throw error
        }
    }
}
