//
//  NetworkService.swift
//  NYC-Schools
//
//  Created by Xinbo Wu on 12/9/22.
//

import Foundation

// MARK: - NetworkServiceError

enum NetworkServiceError: Error {
    case badUrl(String)
    case noData(String)
    case error(String)
    case dataDecoding(String)
}

extension NetworkServiceError: CustomStringConvertible {
    var description: String {
        switch self {
        case .badUrl(let des):
            return des
        case .noData(let des):
            return des
        case .error(let des):
            return des
        case .dataDecoding(let des):
            return des
        }
    }
}

protocol Cancellable {
    func cancel() -> Void
}

// MARK: - Network Requestable

protocol NetworkRequestable {
    typealias Completion<T> = (Result<T, NetworkServiceError>) -> Void
    
    func request<T: Decodable, E: Requestable>(with endpoint: E, completion: @escaping Completion<T>) -> Cancellable? where E.Response == T
}

// MARK: - Network service

/*
 Common network service 
 */
final class NetworkService: NetworkRequestable {
    @discardableResult
    func request<T: Decodable, E: Requestable>(with endpoint: E, completion: @escaping Completion<T>) -> Cancellable? where E.Response == T {
        guard let urlRequest = endpoint.urlRequest() else {
            completion(.failure(.badUrl("Bad url")))
            return nil
        }

        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion(.failure(.error(error!.localizedDescription)))
                return
            }
            guard let data = data else {
                completion(.failure(.noData("No data")))
                return
            }
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(.success(result))
                
            } catch let err {
                completion(.failure(.dataDecoding(err.localizedDescription)))
            }
        }
        
        task.resume()
        
        return task
    }
}

extension URLSessionTask: Cancellable { }
