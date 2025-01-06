//
//  LoginData.swift
//  AuthenticationUIKit
//
//  Created by Elif Parlak on 5.01.2025.
//

import Foundation

//MARK: Request Models
struct RegisterRequest: Codable {
    let email: String
    let userName: String
    let password: String
}

struct LoginRequest: Codable {
    let email: String
    let password: String
}
