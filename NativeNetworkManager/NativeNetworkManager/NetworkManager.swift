//
//  NetworkManager.swift
//  NativeNetworkManager
//
//  Created by Jay on 29/8/2568 BE.
//

import Foundation

enum ContentType: String {
    case json = "application/json"
    case xForm = "application/x-www-form-urlencoded"
    case pdf = "application/pdf"
    case close
}

enum HTTPHeaderKey: String {
    case contentType = "Content-Type"
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
}

// MARK: - NetworkConfig

protocol NetworkConfig {
    var method: HTTPMethod { get }
    var baseURL: String { get }
    var path: String { get }
    var header: [String: String] { get }
    var parameters: [String: String]? { get }
}

extension NetworkConfig {
    static func getHeader(contentType: ContentType = .json) -> [String: String] {
        return [
            HTTPHeaderKey.contentType.rawValue: contentType.rawValue
        ]
    }
}

// MARK: - NetworkManager

class NetworkManager {
    static let shared = NetworkManager()
    
    public static func performRequest<T: Decodable>(
        with config: NetworkConfig,
        completion: @escaping (T?, Error?) -> Void
    ) {
        var urlString = config.baseURL + config.path
        
        if config.method == .get, let parameters = config.parameters {
            let query = parameters.map { "\($0.key)=\($0.value)" }
                                   .joined(separator: "&")
            urlString += "?\(query)"
        }
        
        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL: \(urlString)")
            DispatchQueue.main.async {
                completion(nil, URLError(.badURL))
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = config.method.rawValue
        
        config.header.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        if (config.method == .post || config.method == .put),
           let parameters = config.parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, URLError(.badServerResponse))
                }
                return
            }
            
            DispatchQueue.global(qos: .background).async {
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(decodedData, nil)
                    }
                } catch {
                    print("🔥 Decoding error for \(url.absoluteString): \(error)")
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }.resume()
    }
}

