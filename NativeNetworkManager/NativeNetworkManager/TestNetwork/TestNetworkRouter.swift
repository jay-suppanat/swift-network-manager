//
//  TestNetworkRouter.swift
//  NativeNetworkManager
//
//  Created by Jay on 29/8/2568 BE.
//

enum TestNetworkRouter: NetworkConfig {
    case testGETService(firstName: String, lastName: String)
    case testPOSTService(firstName: String, lastName: String)
    
    var method: HTTPMethod {
        switch self {
        case .testGETService:
            return .get
        case .testPOSTService:
            return .post
        }
    }
    
    var baseURL: String {
        switch self {
        default:
            return "https://postman-echo.com"
        }
    }
    
    var path: String {
        switch self {
        case .testGETService:
            return "/get"
        case .testPOSTService:
            return "/post"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .testGETService:
            return TestNetworkRouter.getHeader()
        case .testPOSTService:
            return TestNetworkRouter.getHeader(contentType: .json)
        }
    }
    
    var parameters: [String : String]? {
        switch self {
        case .testGETService(let firstName, let lastName), .testPOSTService(let firstName, let lastName):
            return [
                "firstName": firstName,
                "lastName": lastName
            ]
        }
    }
    
    
}
