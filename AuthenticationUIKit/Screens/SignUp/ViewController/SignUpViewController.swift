//
//  WelcomeViewController.swift
//  AuthenticationUIKit
//
//  Created by Elif Parlak on 4.01.2025.
//

import UIKit

class SignUpViewController: UIViewController {
    private var viewModel: SignUpViewModel
    
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Properties
    private lazy var signUpView = SignUpUIView()

    //MARK: View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupController()
    }
    
    //MARK: load view
    override func loadView() {
        view = signUpView
    }
    //MARK: Setup navigation
    private func setupNavigation() {
        navigationItem.hidesBackButton = true
    }
    
    //MARK: Setup Controller
    private func setupController() {
        signUpView.delegate = self
    }
    
}
//MARK: SignUpViewDelegate
extension SignUpViewController: SignUpViewDelegate {
    func didSignUpButtonTapped(userName: String, email: String, password: String) {
        Task {
            let result = await viewModel.register(
                email: email,
                userName: userName,
                password: password
            )
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                switch result {
                case .success(_):
                    let homeVC = HomeViewController(viewModel: HomeViewModel())
                    homeVC.modalPresentationStyle = .fullScreen
                    navigationController?.pushViewController(homeVC, animated: true)
                    didLogin()
                case .failure(let error):
                    let message = (error as? AuthError)?.localizedDescription ?? error.localizedDescription
                    self.presentAlert(title: "Something went wrong!", message: message, buttonTitle: "Ok")
                }
            }
        }
    }

    func didAlreadyHaveAnAccountButtonTapped() {
        present(SignInViewController(), animated: true)
    }
    
    func didLogin() {
        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.setupTabBarController()
        }

    }
}
