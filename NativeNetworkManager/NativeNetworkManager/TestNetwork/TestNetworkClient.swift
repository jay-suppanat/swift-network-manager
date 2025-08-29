//
//  TestNetworkClient.swift
//  NativeNetworkManager
//
//  Created by Jay on 29/8/2568 BE.
//

import Foundation

// MARK: - TestGetServiceModel

struct TestGetServiceModel: Codable {
    let args: Args?
    let data: Data?
    let url: String
}

// MARK: - Args

struct Args: Codable {
    let firstName, lastName: String?
}

// MARK: - Data

struct Data: Codable {
    let firstName, lastName: String?
}

enum TestNetworkClient {
    static func requestTestGetService(firstName: String, lastName: String, completion: @escaping (TestGetServiceModel) -> Void) {
        NetworkManager.performRequest(with: TestNetworkRouter.testGETService(firstName: firstName, lastName: lastName)) { (response: TestGetServiceModel?, error) in
            guard let data = response else {
                return
            }
            completion(data)
        }
    }
    
    static func requestTestPOSTService(firstName: String, lastName: String, completion: @escaping (TestGetServiceModel) -> Void) {
        NetworkManager.performRequest(with: TestNetworkRouter.testPOSTService(firstName: firstName, lastName: lastName)) { (response: TestGetServiceModel?, error) in
            guard let data = response else {
                return
            }
            completion(data)
        }
    }
}
