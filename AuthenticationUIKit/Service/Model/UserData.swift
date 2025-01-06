//
//  UserModel.swift
//  AuthenticationUIKit
//
//  Created by Elif Parlak on 5.01.2025.
//

import Foundation

//MARK: UserData
struct UserData: Codable, Hashable {
    let userName: String
    let email: String
    let token: String?
}

struct AuthUserData: Codable {
    let userName: String
    let email: String
    let token: String
}
