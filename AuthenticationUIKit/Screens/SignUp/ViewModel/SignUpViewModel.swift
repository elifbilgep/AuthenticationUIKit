//
//  SignUpViewModel.swift
//  AuthenticationUIKit
//
//  Created by Elif Parlak on 5.01.2025.
//

import Foundation

final class SignUpViewModel {
    private let authService = AuthService.shared
    
    func register(email: String, userName: String, password: String) async -> Result<Void, Error> {
        let request = RegisterRequest(email: email, userName: userName, password: password)
        do {
            let response = try await authService.register(request: request)
            if response.success, let userData = response.data {
                AppManager.shared.login(with: userData.token)
                return .success(())
            } else {
                return .failure(AuthError.serverError(response.message))
            }
        } catch {
            return .failure(error)
        }
    }
}
