//
//  WelcomeUIView.swift
//  AuthenticationUIKit
//
//  Created by Elif Parlak on 4.01.2025.
//

import UIKit

protocol SignUpViewDelegate: AnyObject {
    func didSignUpButtonTapped(userName: String, email: String, password: String)
    func didAlreadyHaveAnAccountButtonTapped()
}

class SignUpUIView: UIView {
    
    //MARK: UIComponents
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var headline: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    
    private lazy var userNameField: UnderlinedTextField = {
        let textField = UnderlinedTextField()
        textField.placeholder = "Username"
        return textField
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
    
    private lazy var termsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()
    
    private lazy var termsCheckBox: UIButton = {
        let button = UIButton(type: .custom)
        
        // Configure symbol weight and scale
        let normalConfig = UIImage.SymbolConfiguration(weight: .medium)
        let selectedConfig = UIImage.SymbolConfiguration(weight: .medium)
        
        // Create images with the new configuration
        let normalImage = UIImage(systemName: "square", withConfiguration: normalConfig)
        let selectedImage = UIImage(systemName: "checkmark.square.fill", withConfiguration: selectedConfig)
        
        button.setImage(normalImage, for: .normal)
        button.layer.borderColor = UIColor(named: "off-white")!.cgColor
        button.setImage(selectedImage, for: .selected)
        button.tintColor = UIColor(named: "off-white")
        button.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var termsLabel: UILabel = {
        let label = UILabel()
        label.text = "I accept the Terms & Conditions"
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor(named: "off-white")
        return label
    }()
    
    private lazy var signUpButton: CustomUIButton = {
        let button = CustomUIButton(style: .dark, title: "Sign Up")
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var anonimButton = CustomUIButton(style: .light, title: "Continue as Anonymous")
    
    private lazy var haveAnAccount: UILabel = {
        let label = UILabel()
        let attributedString = NSAttributedString(
            string: "Already have an account?",
            attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue]
        )
        label.attributedText = attributedString
        label.textColor = UIColor(named: "off-white")
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.isUserInteractionEnabled = true 
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(alreadyHaveAnAccountButtonTapped))
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    //MARK: Properties
    private var isTermsAccepted = false
    weak var delegate: SignUpViewDelegate?

    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Private methods
    @objc private func signUpButtonTapped() {
        guard let userName = userNameField.text, let email = emailField.text, let password = passwordField.text else { return }
        delegate?.didSignUpButtonTapped(userName: userName, email: email, password: password)
    }
    
    @objc private func alreadyHaveAnAccountButtonTapped() {
        delegate?.didAlreadyHaveAnAccountButtonTapped()
    }
    
    //MARK: Setup View
    private func setupView() {
        headline.text = "Create\nyour account"
        headline.numberOfLines = 2
        headline.textColor = UIColor(named: "off-white")
        backgroundColor = .systemBackground
        setBackgroundImage(UIImage(named: "bg"))
        [backgroundImageView,headline, userNameField, emailField, passwordField, termsStack, signUpButton, anonimButton, haveAnAccount].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
        
        termsStack.addArrangedSubview(termsCheckBox)
        termsStack.addArrangedSubview(termsLabel)
        
        setupConstraints()
    }
    
    //MARK: Set background image
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
            // Headline
            headline.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding1),
            headline.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding2),
            headline.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding2),
            
            // username field constraints
            userNameField.topAnchor.constraint(equalTo: headline.bottomAnchor, constant: padding1 * 2),
            userNameField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding2),
            userNameField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding2),
            
            // mail field constraints
            emailField.topAnchor.constraint(equalTo: userNameField.bottomAnchor, constant: padding1),
            emailField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding2),
            emailField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding2),
            
            // password field constraints
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 24),
            passwordField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            passwordField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            passwordField.heightAnchor.constraint(equalToConstant: 40),
            
            // terms stack
            termsStack.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: padding2),
            termsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            
            // sign up button
            signUpButton.topAnchor.constraint(equalTo: termsStack.bottomAnchor, constant: padding1),
            signUpButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding2),
            signUpButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding2),
            signUpButton.heightAnchor.constraint(equalToConstant: 55),
            
            // anon button
            anonimButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 8),
            anonimButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding2),
            anonimButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding2),
            anonimButton.heightAnchor.constraint(equalToConstant: 55),
            
            // have an account
            haveAnAccount.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding2),
            haveAnAccount.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding2),
            haveAnAccount.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding2),
        ])
    }
    
    //MARK: Actions
    @objc private func checkBoxTapped() {
        isTermsAccepted.toggle()
        termsCheckBox.isSelected = isTermsAccepted
    }
    
    
}
