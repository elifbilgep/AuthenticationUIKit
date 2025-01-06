//
//  LoginResponse.swift
//  AuthenticationUIKit
//
//  Created by Elif Parlak on 5.01.2025.
//

import Foundation

// MARK: - Base Response Protocol
protocol BaseResponse {
    var success: Bool { get }
    var message: String { get }
}

struct ApiResponse<T: Codable>: Codable {
    let success: Bool
    let message: String
    let data: T?
}

struct TokenResponse: Codable {
    let token: String
}
