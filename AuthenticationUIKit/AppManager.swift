//
//  AppManager.swift
//  AuthenticationUIKit
//
//  Created by Elif Parlak on 5.01.2025.
//

import Foundation
import KeychainSwift

final class AppManager {
    static let shared = AppManager()
    
    private let tokenKey = "userAuthToken"
    private let keychain = KeychainSwift()
    
    private init() {}
    
    var authToken: String? {
        get {
            return keychain.get(tokenKey)
        }
        set {
            if let newToken = newValue {
                keychain.set(newToken, forKey: tokenKey)
            } else {
                keychain.delete(tokenKey)
            }
        }
    }
    
    var isAuthenticated: Bool {
        return authToken != nil
    }
    
    func login(with token: String) {
        authToken = token
        NotificationCenter.default.post(name: .userDidLogin, object: nil)
    }
    
    func logOut() {
        authToken = nil
        NotificationCenter.default.post(name: .userDidLogout, object: nil)
    }
    
}

