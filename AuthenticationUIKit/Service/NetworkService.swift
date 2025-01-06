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
    
    //MARK: Refreh token
    /// Attempts to refresh the authentication token
    private func refreshToken() async throws -> String {
        // Get stored user email for token refresh
        guard let userEmail = userDefaultsManager.get(String.self, forKey: .userEmail) else {
            throw NetworkError.tokenRefreshFailed
        }
        
        let parameters: Parameters = ["email": userEmail]
        
        // Make refresh token request
        let response: ApiResponse<TokenResponse> = try await request(
            endpoint: .refreshToken,
            method: .post,
            parameters: parameters,
            headers: createHeaders(defaultHeaders: ["Content-Type": "application/json"]),
            requiresAuthentication: false
        )
        
        // Handle the refresh token response
        if let newToken = response.data?.token {
            appManager.login(with: newToken)
            return newToken
        }
        
        throw NetworkError.tokenRefreshFailed
    }
    
    // MARK: - Main Request Method
    
    /// Generic request method that handles all API calls
    // MARK: - Main Request Method
    func request<T: Codable>(
        endpoint: AuthEndpoint,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        requiresAuthentication: Bool = true
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
        
        // Debug için log
        print("🔍 Request URL: \(url.absoluteString)")
        print("🔍 Headers: \(initialHeaders)")
        if let parameters = parameters {
            print("🔍 Parameters: \(parameters)")
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                url,
                method: method,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: initialHeaders
            )
            .validate(statusCode: 200...299)  // 2xx başarılı yanıtları kabul et
            .responseDecodable(of: T.self) { [weak self] response in
                guard let self = self else { return }
                
                print("📥 Response Status: \(String(describing: response.response?.statusCode))")
                if let statusCode = response.response?.statusCode {
                    switch statusCode {
                    case 401...403:  // Token expired
                        Task {
                            do {
                                let newToken = try await self.refreshToken()
                                let retryHeaders = self.createHeaders(
                                    defaultHeaders: headers,
                                    token: newToken
                                )
                                
                                let retryResponse: T = try await self.request(
                                    endpoint: endpoint,
                                    method: method,
                                    parameters: parameters,
                                    headers: retryHeaders
                                )
                                continuation.resume(returning: retryResponse)
                            } catch {
                                print("🚨 Token refresh failed: \(error)")
                                self.appManager.logOut()
                                continuation.resume(throwing: error)
                            }
                        }
                        
                    case 200...299:
                        switch response.result {
                        case .success(let data):
                            if let jsonData = response.data {
                                print("📦 Response JSON:", String(data: jsonData, encoding: .utf8) ?? "")
                            }
                            continuation.resume(returning: data)
                        
                        case .failure(let error):
                            print("🚨 Request failed: \(error)")
                            continuation.resume(throwing: error)
                        }
                        
                    default:
                        if let error = response.error {
                            print("🚨 Network error: \(error)")
                            continuation.resume(throwing: error)
                        } else {
                            continuation.resume(throwing: NetworkError.invalidData)
                        }
                    }
                } else {
                    print("🚨 No status code in response")
                    continuation.resume(throwing: NetworkError.invalidData)
                }
            }
        }
    }
}
