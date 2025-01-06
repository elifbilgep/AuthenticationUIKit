//
//  HomeViewCollectionViewCell.swift
//  AuthenticationUIKit
//
//  Created by Elif Parlak on 5.01.2025.
//

import UIKit

class HomeViewCollectionViewCell: UICollectionViewCell {
    static let identifier = "HomeViewCollectionViewCell"
    
    //MARK: Properties
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.alignment = .center
        translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")
        imageView.contentMode = .scaleAspectFit
        translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 4
        stackView.axis = .vertical
        translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 1
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 1
        label.textColor = .gray
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
            verticalStackView.translatesAutoresizingMaskIntoConstraints = false
            imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(horizontalStackView)
        
        horizontalStackView.addArrangedSubview(imageView)
           horizontalStackView.addArrangedSubview(verticalStackView)
        
        verticalStackView.addArrangedSubview(usernameLabel)
            verticalStackView.addArrangedSubview(emailLabel)
        
        setupConstraints()
        
        contentView.backgroundColor = .systemBackground
            contentView.layer.cornerRadius = 8
            contentView.clipsToBounds = true
        
    
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Image constraints
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            
            // Horizontal stack view constraints
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            // Vertical stack view constraints - This is crucial
            verticalStackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // Make sure the labels expand properly
            usernameLabel.leadingAnchor.constraint(equalTo: verticalStackView.leadingAnchor),
            emailLabel.leadingAnchor.constraint(equalTo: verticalStackView.leadingAnchor),
            
            usernameLabel.heightAnchor.constraint(equalToConstant: 50),
            emailLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
        
    }

    
    func configureCell(username: String, email: String) {
        usernameLabel.text = username
        emailLabel.text = email
    }
    
}
