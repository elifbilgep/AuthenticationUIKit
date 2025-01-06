//
//  WelcomeUIView.swift
//  AuthenticationUIKit
//
//  Created by Elif Parlak on 4.01.2025.
//

import UIKit

class UnderlinedTextField: UITextField {
    
    //MARK: Properties
    private let underlineLayer = CALayer()
    private let padding = UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)

    var underlineColor: UIColor = UIColor(named: "off-white")!
    override var placeholder: String? {
        get { super.placeholder }
        set {
            attributedPlaceholder = NSAttributedString(
                string: newValue ?? "",
                attributes: [
                    .foregroundColor: underlineColor,
                    .font: UIFont.systemFont(ofSize: 16)
                ]
            )
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTextField() {
        borderStyle = .none
        backgroundColor = .clear
        textColor = underlineColor
        underlineLayer.backgroundColor = underlineColor.cgColor
        layer.addSublayer(underlineLayer)
        
        if let existingPlaceholder = placeholder {
            placeholder = existingPlaceholder
        }
    }
    
    //MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let underlineHeight: CGFloat = 2.0
        underlineLayer.frame = CGRect(x: 0, y: bounds.height - underlineHeight, width: bounds.width, height: underlineHeight)
    }
    
    // MARK: Text Rect Methods
       override func textRect(forBounds bounds: CGRect) -> CGRect {
           return bounds.inset(by: padding)
       }
       
       override func editingRect(forBounds bounds: CGRect) -> CGRect {
           return bounds.inset(by: padding)
       }
       
       override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
           return bounds.inset(by: padding)
       }
}
