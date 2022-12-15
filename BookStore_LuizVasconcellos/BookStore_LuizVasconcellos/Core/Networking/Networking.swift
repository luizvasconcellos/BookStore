//
//  Networking.swift
//  BookStore_LuizVasconcellos
//
//  Created by Luiz Vasconcellos on 07/12/22.
//

import Foundation
import Alamofire

enum ErrorType: Error {
    case requestError
}

protocol NetworkingDelegate {
    func baseRequest<T: Decodable>(request: NetworkRequest, type: T.Type, completion: @escaping (T?, String?) -> Void)
}

final class Networking: NetworkingDelegate {
    
    func baseRequest<T: Decodable>(request: NetworkRequest, type: T.Type, completion: @escaping (T?, String?) -> Void) {
        let request = convertToAFRequest(request: request)
        AF.request(request)
            .responseDecodable(of: type) { response in
                switch response.result {
                case .success:
                    guard let response = response.value else { return }
                    completion(response, nil)
                case .failure:
                    completion(nil, response.error?.errorDescription)
                }
            }
    }
    
    private func convertToAFRequest(request: NetworkRequest) -> URLRequest {
        var afRequest = URLRequest(url: request.url as URL)
        afRequest.httpMethod = request.method.rawValue
        afRequest.headers = HTTPHeaders(request.headers ?? [:])
        if let parameters = request.parameters {
            let data = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
            afRequest.httpBody = data
        } else if let bodyParameters = request.bodyParameters {
            afRequest.httpBody = bodyParameters
        }
        
        return afRequest
    }
}
