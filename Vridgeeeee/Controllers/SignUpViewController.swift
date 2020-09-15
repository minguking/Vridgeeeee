//
//  SignUpViewController.swift
//  Vridgeeeee
//
//  Created by Kang Mingu on 2020/09/14.
//  Copyright © 2020 Kang Mingu. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    // MARK: - Properties
    
    let emailTf: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.borderStyle = .roundedRect
        return tf
    }()
    let firstnameTf: UITextField = {
        let tf = UITextField()
        tf.placeholder = "First name"
        tf.borderStyle = .roundedRect
        return tf
    }()
    let lastnameTf: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Last name"
        tf.borderStyle = .roundedRect
        return tf
    }()
    let passwordTf: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.borderStyle = .roundedRect
        tf.isSecureTextEntry = true
        return tf
    }()
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("already have an account? go to Login", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    // MARK: - Selector
    
    @objc func handleSignUp() {
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    // MARK: - Helper

    func configureUI() {
        
        view.backgroundColor = .yellow
        
        let stack = UIStackView(arrangedSubviews: [emailTf, firstnameTf, lastnameTf,
                                                   passwordTf, loginButton, signUpButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 10
        
        view.addSubview(stack)
        view.addSubview(loginButton)
        
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 60, paddingLeft: 40, paddingRight: 40)
        loginButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 30)
    }


}
