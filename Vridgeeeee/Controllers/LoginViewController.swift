//
//  LoginViewController.swift
//  Vridgeeeee
//
//  Created by Kang Mingu on 2020/09/14.
//  Copyright © 2020 Kang Mingu. All rights reserved.
//

import UIKit
import AuthenticationServices
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    let emailTf: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
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
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("don't have an accont? go to sign up", for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    let appleLoginButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton()
        button.addTarget(self, action: #selector(handleAppleLogin), for: .touchUpInside)
        return button
    }()
    
    let indicator = UIActivityIndicatorView()
    let db = Firestore.firestore()
    
    var email: String?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    // MARK: - Selector
    
    @objc func handleLogin() {
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleAppleLogin() {
        indicator.startAnimating()
        performSignin()
    }
    
    @objc func handleSignUp() {
        
        let vc = SignUpViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    // MARK: - Helper
    
    func configureUI() {
        
        navigationController?.navigationBar.isHidden = true
        
        view.backgroundColor = .white
        
        indicator.center = view.center
        indicator.style = .large
        indicator.hidesWhenStopped = true
        
        let stack = UIStackView(arrangedSubviews: [emailTf, passwordTf, loginButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 10
        
        view.addSubview(indicator)
        view.addSubview(stack)
        view.addSubview(signUpButton)
        view.addSubview(appleLoginButton)
        
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 60, paddingLeft: 40, paddingRight: 40)
        appleLoginButton.anchor(top: stack.bottomAnchor, paddingTop: 20)
        appleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        signUpButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 30)
        
    }
    
    func performSignin() {
        
        let request = createAppleIdRequest()
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        
        authorizationController.performRequests()
        
        
    }
    
    func createAppleIdRequest() -> ASAuthorizationAppleIDRequest {
        
        let appleIdProvider = ASAuthorizationAppleIDProvider()
        let request = appleIdProvider.createRequest()
        
        request.requestedScopes = [.fullName, .email]
        
        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        currentNonce = nonce
        
        return request
        
    }
    
    func transitionToHome() {
        
        let vc = HomeViewController()
        navigationController?.pushViewController(vc, animated: true)
        indicator.stopAnimating()
    }
    
    
    // Adapted from https://firebase.google.com/docs/auth/ios/apple?hl=ko
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
}

import CryptoKit

// Unhashed nonce.
fileprivate var currentNonce: String?

@available(iOS 13, *)
private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
    }.joined()
    
    return hashString
}


extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("INVALID STATE : a login callback was received, but no request sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string")
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            Auth.auth().signIn(with: credential) { (result, error) in
                
                if let user = result?.user {
                    self.email = user.email
                    
                    print("nice! you're now signed in as \(user.uid), email: \(user.email ?? "unknown")")
                    self.indicator.stopAnimating()
                    
                    if self.db.collection("users").document(user.email!) != nil {
                        print("데이다 여깄지 = \(self.db.collection("users").document(user.email!))")
                    }
                    
                    
                    self.db.collection("users").document(user.email!).setData([
                        "uid": user.uid
                    ], merge: true) { error in
                        if let err = error {
                            print(err.localizedDescription)
                        }
                    }
                    
                    // username이 없다면 세부정보 입력 페이지로, 있다면 바로 홈 화면으로 이동하는 코드 짜기
                    let db = Firestore.firestore()
                    
                    db.collection("users").document(user.email!).addSnapshotListener { (snapshot, error) in
                        
                        guard let documents = snapshot?.data() else {
                            print("no documents man")
                            return
                        }
                    
                        let point = documents["point"] as? Int ?? 0
                        let uid = documents["uid"] as? String ?? ""
                        let username = documents["username"] as? String ?? ""
                        
                        if username == "" {
                            let vc = AppleLoginDetailViewController()
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                    
                }
            }
            
            
            
            
        }
    }
    
    
    
}
