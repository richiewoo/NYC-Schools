//
//  Endpoint.swift
//  NYC-Schools
//
//  Created by Xinbo Wu on 12/9/22.
//

import Foundation

// MARK: - Endpoint Requestable

protocol Requestable {
    associatedtype Response
    
    var baseUrl: String { get }
    var paramaters: [String: String] { get }
    
    func urlRequest() -> URLRequest?
}

extension Requestable {
    public func urlRequest() -> URLRequest? {
        guard var urlComponent = URLComponents(string: baseUrl) else {
            return nil
        }
        
        var urlQueryItems = [URLQueryItem]()
        paramaters.forEach {
            urlQueryItems.append(URLQueryItem(name: "\($0.key)", value: "\($0.value)"))
        }
        
        if !urlQueryItems.isEmpty {
            if let items = urlComponent.queryItems {
                urlComponent.queryItems = items + urlQueryItems
            } else {
                urlComponent.queryItems = urlQueryItems
            }
        }
        
        guard let url = urlComponent.url else {
            return nil
        }
        
        return URLRequest(url: url)
    }
}

// MARK: - Endpoint

/*
 Endpoint supporting parameter in url, e.g. for pagination
 */
struct Endpoint<R>: Requestable {
    typealias Response = R
    
    var baseUrl: String
    var paramaters: [String: String] = [:]
    
    init(with url: String, paramaters: [String: String] = [:]) {
        baseUrl = url
        self.paramaters = paramaters
    }
}
