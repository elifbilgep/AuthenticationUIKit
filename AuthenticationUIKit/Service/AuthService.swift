//
//  AuthService.swift
//  AuthenticationUIKit
//
//  Created by Elif Parlak on 5.01.2025.
//

import Alamofire
import Foundation

enum AuthEndpoint: String{
    case register = "/register"
    case login =  "/login"
    case refreshToken = "/refresh-token"
    case logout = "/logout"
    case users = "/users"
    case user = "/user"
}

enum AuthError: Error {
    case serverError(String)
    case invalidCredentials
    case refreshTokenFailed
    case networkError
    case invalidToken
}


final class AuthService {
    //MARK: Properties
    static let shared = AuthService()
    private let networkService = NetworkService.shared
    private let appManager = AppManager.shared
    private let userDefaultsManager = UserDefaultsManager.shared
    
    private init() {}
    
    //MARK: Auth Methods
    
    /// Create a new user
    func register(request: RegisterRequest) async throws -> ApiResponse<AuthUserData> {
        let parameters: Parameters = [
            "email" : request.email,
            "userName" : request.userName,
            "password" : request.password
        ]
        
        let response: ApiResponse<AuthUserData> = try await networkService.request(
            endpoint: .register,
            method: .post,
            parameters: parameters,
            headers: ["Content-Type" : "application/json"],
            requiresAuthentication: false)
        
        if let token = response.data?.token {
            appManager.login(with: token)
            userDefaultsManager.save(request.email, forKey: .userEmail)
        }
        return response
        
    }
    
    /// Login
    func login(request: LoginRequest)  async throws -> ApiResponse<UserData> {
        let parameters: Parameters = [
            "email" :  request.email,
            "password" : request.password
        ]
        
        let response: ApiResponse<UserData> = try await networkService.request(
            endpoint: AuthEndpoint.login,
            method: .post, parameters: parameters,
            headers: ["Content-Type" : "application/json"],
            requiresAuthentication: false)
        
        if let token = response.data?.token {
            appManager.login(with: token)
            userDefaultsManager.save(request.email, forKey: .userEmail)
        }
        return response
        
    }
    
    func fetchUsers() async throws -> [UserData] {
        let response: ApiResponse<[UserData]> = try await networkService.request(
            endpoint: .users,
            method: .get,
            headers: ["Content-Type": "application/json"],
            requiresAuthentication: true)
        
        guard let users = response.data else {
            throw NetworkError.invalidData
        }
        
        return users
    }
    
    func fetchCurrentUser() async throws -> UserData {
        let response: ApiResponse<UserData> = try await networkService.request(
            endpoint: .user,
            method: .get,
            headers: ["Content-Type": "application/json"],
            requiresAuthentication: true
        )
        
        guard let user = response.data else {
            throw NetworkError.invalidData
        }
        return user
    }
}

