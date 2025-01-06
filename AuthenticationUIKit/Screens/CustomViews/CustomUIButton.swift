//
//  Custom.swift
//  AuthenticationUIKit
//
//  Created by Elif Parlak on 4.01.2025.
//

import UIKit

enum CustomButtonStyle {
    case dark, light
}

class CustomUIButton: UIButton {
    private var style: CustomButtonStyle = .dark
    
    convenience init(style: CustomButtonStyle, title: String) {
        self.init(frame: .zero)
        self.style = style
        setupButton(with: title)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton(with title: String) {
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.1
        switch style {
        case .dark:
            backgroundColor = UIColor(named: "dark-button")
            setTitleColor(UIColor(named: "off-white"), for: .normal)
            setTitle(title, for: .normal)
        case .light:
            backgroundColor = UIColor(named: "off-white")
            setTitleColor(UIColor(named: "dark-button"), for: .normal)
            setTitle(title, for: .normal)
        }
        titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
}
