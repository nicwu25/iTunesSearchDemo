//
//  APIEngine.swift
//  iTunesSearchDemo
//
//  Created by cm0678 on 2022/12/20.
//

import Alamofire

class APIEngine {
    
    static let shared = APIEngine()
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10
        config.timeoutIntervalForResource = 10
        let _ = Alamofire.SessionManager(configuration: config)
    }
    
    func request<T: Decodable>(endPoint: EndPoint, completion: @escaping ((Swift.Result<T, NetworkError>) -> Void)) {
        
        let urlString = endPoint.baseURL + endPoint.endPoint
        NetworkLogger.log(method: endPoint.method, urlString: urlString, headers: endPoint.headers, parameters: endPoint.parameters)
        
        let afHTTPMethod = convertHTTPMethodToAF(endPoint.method)
        let encoding = convertParameterEncoding(endPoint.encoding)
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.unstableInternet))
            return
        }
        
        Alamofire.request(url,
                          method: afHTTPMethod,
                          parameters: endPoint.parameters,
                          encoding: encoding,
                          headers: endPoint.headers).validate().responseJSON { (response) in
            
            completion(self.handleNetworkResponse(response))
        }
    }
    
    private func handleNetworkResponse<T: Decodable>(_ response: DataResponse<Any>) -> Swift.Result<T, NetworkError> {
        
        if let statusCode = response.response?.statusCode {
            
            switch statusCode {
            case 200...299:
                guard let data = response.data else {
                    return .failure(.noData)
                }
                do {
                    let model = try JSONDecoder().decode(T.self, from: data)
                    return .success(model)
                } catch {
                    return .failure(.unableToDecode(errorString: error.localizedDescription))
                }
            default:
                return .failure(.failure(message: "unknown error"))
            }
        } else {
            return .failure(.unstableInternet)
        }
    }
}

extension APIEngine {
    
    func convertHTTPMethodToAF(_ method: HTTPMethod) -> Alamofire.HTTPMethod {
        switch method {
        case .connect:
            return .connect
        case .delete:
            return .delete
        case .get:
            return .get
        case .head:
            return .head
        case .options:
            return .options
        case .patch:
            return .patch
        case .post:
            return .post
        case .put:
            return .put
        case .trace:
            return .trace
        }
    }
    
    func convertParameterEncoding(_ encoding: ParameterEncoding) -> Alamofire.ParameterEncoding {
        switch encoding {
        case .url:
            return URLEncoding.default
        case .json:
            return JSONEncoding.default
        }
    }
}
