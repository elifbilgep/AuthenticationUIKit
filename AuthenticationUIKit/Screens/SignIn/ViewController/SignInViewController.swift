//
//  SignInViewController.swift
//  AuthenticationUIKit
//
//  Created by Elif Parlak on 4.01.2025.
//

import UIKit

class SignInViewController: UIViewController {
    //TODO: This part need to be completed but I am so tired
    
    //MARK: Properites
    private lazy var signInView = SignInUIView()
    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
    }
    
    //MARK: Load View
    override func loadView() {
        super.loadView()
        view = signInView
    }
    
    

}
