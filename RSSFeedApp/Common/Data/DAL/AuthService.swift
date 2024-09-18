//
//  AuthService.swift
//  RSSFeedApp
//
//  Created by Jurica Bozikovic on 28.02.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import Foundation
import Combine

//  MARK: - AuthConstants
private struct AuthConstants {
    private init() {}
    
    static let keychainAccount: String = "RSSFeedApp"
    static let keychainAuthService: String = "auth"
}


//  MARK: - AuthProtocol
protocol AuthProtocol {
    func loginUser(email: String, password: String) -> AnyPublisher<Auth, Error>
    func saveAuthToken(with auth: Auth)
    func getAuthToken() -> String?
}

//  MARK: - AuthService
class AuthService: NSObject, AuthProtocol {
    private let networkLayerService: NetworkLayerProtocol
    private let keychainService: KeychainProtocol
    
    init(networkLayerService: NetworkLayerProtocol, keychainService: KeychainProtocol) {
        self.networkLayerService = networkLayerService
        self.keychainService = keychainService
    }
    
    func loginUser(email: String, password: String) -> AnyPublisher<Auth, Error> {
        let request = request(email: email, password: password)
        return networkLayerService.executeNetworkRequest(request: request)
            .handleEvents(receiveOutput: { [weak self] response in
                guard let weakSelf = self else { return }
                weakSelf.saveAuthToken(with: response.value)
            })
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func saveAuthToken(with auth: Auth) {
        keychainService.save(auth, service: AuthConstants.keychainAuthService, account: AuthConstants.keychainAccount)
    }
    
    func getAuthToken() -> String? {
        guard let auth = keychainService.read(service: AuthConstants.keychainAuthService, account: AuthConstants.keychainAccount, type: Auth.self) else { return nil }
        return auth.authToken
    }
}

//  MARK: - Url, header
private extension AuthService {
    var loginUrl: String {
        AppUrls.login
    }
    
    func params(email: String, password: String) -> JSON {
        return [AppKeys.email.rawValue: email,
                AppKeys.password.rawValue: password]
    }
    
    func request(email: String, password: String) -> HTTPRequest {
        let params = params(email: email, password: password)
        return HTTPRequest(method: .post, url: loginUrl, params: params, headers: nil)
    }
}
    



