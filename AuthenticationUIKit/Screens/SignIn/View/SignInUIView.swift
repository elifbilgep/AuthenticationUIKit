//
//  SignInUIview.swift
//  AuthenticationUIKit
//
//  Created by Elif Parlak on 4.01.2025.
//

import UIKit

class SignInUIView: UIView {
    
    //MARK: UIComponents
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var scrollIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 2
        return view
    }()
    
    private lazy var headline: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    
    private lazy var emailField: UnderlinedTextField = {
        let textField = UnderlinedTextField()
        textField.placeholder = "Email"
        return textField
    }()
    
    private lazy var passwordField: UnderlinedTextField = {
        let textField = UnderlinedTextField()
        textField.placeholder = "Password"
        return textField
    }()

    private lazy var signInButton = CustomUIButton(style: .dark, title: "Sign in")
    
    //MARK: Properties
    private var isTermsAccepted = false
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setup View
    private func setupView() {
        headline.text = "Log into\nyour account"
        headline.numberOfLines = 2
        headline.textColor = UIColor(named: "off-white")
        backgroundColor = .systemBackground
        setBackgroundImage(UIImage(named: "bg2"))
        [backgroundImageView, scrollIndicator, headline, emailField, passwordField, signInButton].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
        setupConstraints()
    }
    
    private func setBackgroundImage(_ image: UIImage?) {
        backgroundImageView.image = image
    }
    
    //MARK: Setup Constraints
    private func setupConstraints() {
        let padding1: CGFloat = 32
        let padding2: CGFloat = 24
        
        NSLayoutConstraint.activate([
            // background image view
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // scroll indicator constraints
            scrollIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            scrollIndicator.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            scrollIndicator.widthAnchor.constraint(equalToConstant: 80),
            scrollIndicator.heightAnchor.constraint(equalToConstant: 4),
            
            // Headline
            headline.topAnchor.constraint(equalTo: scrollIndicator.bottomAnchor, constant: padding1 * 2),
            headline.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding2),
            headline.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding2),
            
            // mail field constraints
            emailField.topAnchor.constraint(equalTo: headline.bottomAnchor, constant: padding1 * 2),
            emailField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding2),
            emailField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding2),
            
            // password field constraints
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 24),
            passwordField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            passwordField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            passwordField.heightAnchor.constraint(equalToConstant: 40),
            
            // sign in button
            signInButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: padding1),
            signInButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding2),
            signInButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding2),
            signInButton.heightAnchor.constraint(equalToConstant: 55),
           
        ])
    }
    
    
}
