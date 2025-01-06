//
//  HomeViewModel.swift
//  AuthenticationUIKit
//
//  Created by Elif Parlak on 5.01.2025.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    
    @Published var users: [UserData] = []
    private let authService = AuthService.shared
    
    func fetchUsers() async throws -> Result<Void, Error> {
        do {
            let users = try await authService.fetchUsers()
            self.users = users
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
