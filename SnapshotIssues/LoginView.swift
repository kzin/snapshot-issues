//
//  LoginView.swift
//  swift-testing
//
//  Created by Rodrigo Cavalcante on 03/03/17.
//  Copyright © 2017 Rodrigo Cavalcante. All rights reserved.
//

import UIKit
import Cartography

class LoginView: UIView {
    
    var tapLoginButton: ((_ username: String, _ password: String) -> ())?
    
    let textLabel = { () -> UILabel in
        let label = UILabel()
        label.text = "Formulário de login"
        //label.font = UIFont.systemFont(ofSize: 16.0)
        label.font = UIFont.init(name: "SF UI Display", size: 16.0)
        label.isHidden = false
        return label
    }()
    
    let userNameTextField = { () -> UITextField in
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.accessibilityLabel = "Username"
        textField.borderStyle = .roundedRect
        //textField.font = UIFont.systemFont(ofSize: 16.0)
        textField.font = UIFont.init(name: "SF UI Display", size: 16.0)
        textField.autocapitalizationType = .none
        textField.isHidden = false
        return textField
    }()
    
    let passwordTextField = { () -> UITextField in
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.accessibilityLabel = "Password"
        //textField.font = UIFont.systemFont(ofSize: 16.0)
        textField.font = UIFont.init(name: "SF UI Display", size: 16.0)
        textField.autocapitalizationType = .none
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.isHidden = false
        return textField
    }()
    
    let loginButton = { () -> UIButton in
        let button = UIButton()
        button.accessibilityLabel = "Login"
        //button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        button.titleLabel?.font = UIFont.init(name: "SF UI Display", size: 16.0)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.isHidden = false
        return button
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        build()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func build() {
        buildViewHierarchy()
        buildConstrains()
        setup()
    }
    
    func buildViewHierarchy() {
        addSubview(textLabel)
        addSubview(userNameTextField)
        addSubview(passwordTextField)
        addSubview(loginButton)
    }
    
    func buildConstrains() {
        
        let verticalMargin: CGFloat = 16.0
        let horizontalMargin: CGFloat = 8.0
        
        constrain(self, textLabel, userNameTextField, passwordTextField, loginButton) { view, label, username, password, login in
            
            label.top == view.top + verticalMargin
            label.left == view.left + horizontalMargin
            label.right == view.right - horizontalMargin
            
            username.top == label.bottom + verticalMargin
            username.left == label.left
            username.right == label.right
            
            password.top == username.baseline + 21.0
            password.left == username.left
            password.right == username.right
            
            login.top == password.bottom + verticalMargin
            login.centerX == view.centerX
            login.bottom == view.bottom
        }
    }
    
    func setup() {
        self.backgroundColor = .white
    }
}
