//
//  NetworkRequest.swift
//  BookStore_LuizVasconcellos
//
//  Created by Luiz Vasconcellos on 07/12/22.
//

import Foundation
import Alamofire

enum HTTPMethod : String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

struct NetworkRequest {
    public var url: URL
    public var method: HTTPMethod
    public var headers: [String: String]?
    public var parameters: [String: Any]?
    public var bodyParameters: Data?
    
    public init(method: HTTPMethod = .get, url: URL) {
        self.method = method
        self.url = url
    }
}
