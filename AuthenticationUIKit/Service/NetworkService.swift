//
//  NetworkServicef.swift
//  AuthenticationUIKit
//
//  Created by Elif Parlak on 5.01.2025.
//

//
//  NetworkService.swift
//  AuthenticationUIKit
//
//  Created by Elif Parlak on 5.01.2025.
//

import Foundation
import Alamofire

//MARK: Network Errors Enum
enum NetworkError: Error {
    case invalidData
    case serverError(message: Error)
    case decodingError
    case tokenRefreshFailed
    case invalidURL
}

final class NetworkService {
    // MARK: - Properties
    
    static let shared = NetworkService()
    private let baseURL = "http://localhost:3000"
    private let appManager = AppManager.shared
    private let userDefaultsManager = UserDefaultsManager.shared
    private var isRefreshingToken = false
    private var refreshTask: Task<String, Error>?
    
    
    // Prevent creating multiple instances
    private init() {}
    
    // MARK: - Helper Methods
    /// Builds a proper URL from the base URL and endpoint
    private func buildURL(for endpoint: AuthEndpoint) -> URL? {
        guard var components = URLComponents(string: baseURL) else {
            return nil
        }
        let endpointPath = endpoint.rawValue
        components.path = endpointPath.hasPrefix("/") ? endpointPath : "/\(endpointPath)"
        
        return components.url
    }
    
    //MARK: Create headers
    /// Creates headers with optional authorization token
    private func createHeaders(
        defaultHeaders: HTTPHeaders? = nil,
        token: String? = nil
    ) -> HTTPHeaders {
        var headers = defaultHeaders ?? HTTPHeaders()
        if let token = token {
            headers.add(.authorization(bearerToken: token))
        }
        return headers
    }
    
    // MARK: Refresh token
    private func refreshToken() async throws -> String {
        if let existingTask = refreshTask {
            return try await existingTask.value
        }
        
        let task = Task<String, Error> { [weak self] in
            guard let self = self else {
                throw NetworkError.tokenRefreshFailed
            }
            
            guard let userEmail = userDefaultsManager.get(String.self, forKey: .userEmail) else {
                throw NetworkError.tokenRefreshFailed
            }
            
            let parameters: Parameters = ["email": userEmail]
            
            let response: ApiResponse<TokenResponse> = try await self.performRequest(
                endpoint: .refreshToken,
                method: .post,
                parameters: parameters,
                headers: createHeaders(defaultHeaders: ["Content-Type": "application/json"]),
                requiresAuthentication: false,
                isRefreshAttempt: true
            )
            
            guard let newToken = response.data?.token else {
                throw NetworkError.tokenRefreshFailed
            }
            
            appManager.login(with: newToken)
            return newToken
        }
        
        refreshTask = task
        
        do {
            let token = try await task.value
            refreshTask = nil
            return token
        } catch {
            refreshTask = nil
            throw error
        }
    }
    
    //MARK: perform request
    private func performRequest<T: Codable>(
        endpoint: AuthEndpoint,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        requiresAuthentication: Bool = true,
        isRefreshAttempt: Bool = false
    ) async throws -> T {
        guard let url = buildURL(for: endpoint) else {
            throw NetworkError.invalidURL
        }
        
        let initialHeaders: HTTPHeaders = {
            if requiresAuthentication, let token = appManager.authToken {
                return createHeaders(defaultHeaders: headers, token: token)
            }
            return createHeaders(defaultHeaders: headers)
        }()
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                url,
                method: method,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: initialHeaders
            )
            .validate(statusCode: 200...299)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    //MARK: request
    func request<T: Codable>(
        endpoint: AuthEndpoint,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        requiresAuthentication: Bool = true
    ) async throws -> T {
        do {
            return try await performRequest(
                endpoint: endpoint,
                method: method,
                parameters: parameters,
                headers: headers,
                requiresAuthentication: requiresAuthentication
            )
        } catch {
            if let afError = error.asAFError,
               case .responseValidationFailed(reason: .unacceptableStatusCode(code: let statusCode)) = afError,
               (401...403).contains(statusCode),
               requiresAuthentication,
               !isRefreshingToken {
                
                do {
                    let newToken = try await refreshToken()
                    let retryHeaders = createHeaders(defaultHeaders: headers, token: newToken)
                    
                    return try await performRequest(
                        endpoint: endpoint,
                        method: method,
                        parameters: parameters,
                        headers: retryHeaders,
                        requiresAuthentication: true
                    )
                } catch {
                    appManager.logOut()
                    throw error
                }
            }
            throw error
        }
    }
}
