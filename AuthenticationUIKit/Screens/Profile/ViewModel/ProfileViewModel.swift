//
//  ProfileViewModel.swift
//  AuthenticationUIKit
//
//  Created by Elif Parlak on 6.01.2025.
//

import Foundation
import Combine

final class ProfileViewModel: Observable {
    //MARK: Properties
    private let authService = AuthService.shared
    @Published var currentUser: UserData?
    @Published var user: UserData?
    
    func fetchCurrentUser() {
        Task {
            do {
                let user = try await authService.fetchCurrentUser()
                await MainActor.run {
                    self.user = user
                }
            } catch {
                await MainActor.run {
                    print("Error occured: \(error.localizedDescription)")
                }
            }
        }
    }
}
