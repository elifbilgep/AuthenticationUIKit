//
//  SceneDelegate.swift
//  AuthenticationUIKit
//
//  Created by Elif Parlak on 4.01.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        setupInitialViewController()
        window.makeKeyAndVisible()
    }
    
    private func setupInitialViewController() {
        if AppManager.shared.isAuthenticated {
            setupTabBarController()
        } else {
            setupAuthFlow()
        }
    }

    private func setupAuthFlow() {
        let signUpVC = SignUpViewController(viewModel: SignUpViewModel())
        let navigationController = UINavigationController(rootViewController: signUpVC)
        navigationController.navigationBar.isHidden = true  // Auth flow'da gizli
        window?.rootViewController = navigationController
    }

     func setupTabBarController() {
        let tabBarController = UITabBarController()
        
        // home tab
        let homeVC = HomeViewController(viewModel: HomeViewModel())
        let homeNav = UINavigationController(rootViewController: homeVC)
        configureNavigationBar(homeNav)
        homeNav.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        // profile tab
        let profileVC = ProfileViewController(viewModel: ProfileViewModel())
        let profileNav = UINavigationController(rootViewController: profileVC)
        configureNavigationBar(profileNav)
        profileNav.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        tabBarController.viewControllers = [homeNav, profileNav]
        tabBarController.selectedIndex = 0
        window?.rootViewController = tabBarController
    }

    private func configureNavigationBar(_ navigationController: UINavigationController) {
        navigationController.navigationBar.isHidden = false
        navigationController.navigationBar.prefersLargeTitles = true
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }
    
    
}

