//
//  ProfileViewController.swift
//  AuthenticationUIKit
//
//  Created by Elif Parlak on 6.01.2025.
//

import UIKit
import Combine

class ProfileViewController: UIViewController {
    //MARK: Properties
    private lazy var profileView = ProfileView()
    private var viewModel: ProfileViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    //MARK: Init
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = .systemBackground
        setupBindings()
        setupNavBar()
        viewModel.fetchCurrentUser()
    }
    
    //MARK: load view
    override func loadView() {
        self.view = profileView
    }
    
    //MARK: setup bindings
    private func setupBindings() {
        viewModel
            .$user
            .sink { [weak self] user in
                guard let self, let user else { return }
                profileView.configureView(user: user)
            }
            .store(in: &cancellables)
    }
    
    //MARK: setup nav bar
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Profile"
        
        let logOutButton = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = logOutButton
    }
    
    //MARK: handle log out
    @objc private func handleLogout() {
        AppManager.shared.logOut()
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            UIView.transition(with: window,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: {
                if let sceneDelegate = windowScene.delegate as? SceneDelegate {
                    let signUpVC = SignUpViewController(viewModel: SignUpViewModel())
                    let navigationController = UINavigationController(rootViewController: signUpVC)
                    sceneDelegate.window?.rootViewController = navigationController
                }
            }, completion: nil)
        }
    }
}
