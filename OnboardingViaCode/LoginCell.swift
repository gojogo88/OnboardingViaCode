//
//  LoginCell.swift
//  OnboardingViaCode
//
//  Created by Jonathan Go on 2017/10/23.
//  Copyright © 2017 Appdelight. All rights reserved.
//

import UIKit

class LoginCell: UICollectionViewCell {
    
    let logoImageView: UIImageView = {
        let image = UIImage(named: "logo")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    let emailTextFiled: leftPaddedTextField = {
        let textField = leftPaddedTextField()
        textField.placeholder = "Enter email here"
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.keyboardType = .emailAddress
        return textField
    }()

    let passwordTextFiled: leftPaddedTextField = {
        let textField = leftPaddedTextField()
        textField.placeholder = "Enter password"
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .orange
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(logoImageView)
        addSubview(emailTextFiled)
        addSubview(passwordTextFiled)
        addSubview(loginButton)
        
        _ = logoImageView.anchor(centerYAnchor, left: nil, bottom: nil, right: nil, topConstant: -230, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 160, heightConstant: 160)
        logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        _ = emailTextFiled.anchor(logoImageView.bottomAnchor, left: leadingAnchor, bottom: nil, right: trailingAnchor, topConstant: 8, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 40)
        
        _ = passwordTextFiled.anchor(emailTextFiled.bottomAnchor, left: leadingAnchor, bottom: nil, right: trailingAnchor, topConstant: 12, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 40)
        
        _ = loginButton.anchor(passwordTextFiled.bottomAnchor, left: leadingAnchor, bottom: nil, right: trailingAnchor, topConstant: 16, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 40)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder): has not been implemented")
    }
}

class leftPaddedTextField: UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width + 10, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
         return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width + 10, height: bounds.height)
    }
}
