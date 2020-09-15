//
//  AppleLoginDetailViewController.swift
//  Vridgeeeee
//
//  Created by Kang Mingu on 2020/09/14.
//  Copyright © 2020 Kang Mingu. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class AppleLoginDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    let nickNameTf: UITextField = {
        let tf = UITextField()
        tf.placeholder = "2~8자리의 닉네임을 입력해주세요."
        tf.font = .systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        tf.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        return tf
    }()
    let instructionLabel: UILabel = {
        let text = UILabel()
        text.text = "닉네임은 마이페이지에서 변경 가능합니다."
        text.setDimensions(width: 160, height: 18)
        return text
    }()
    let checkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("중복확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setDimensions(width: 80, height: 40)
        button.backgroundColor = .gray
        button.addTarget(self, action: #selector(handleCheck), for: .touchUpInside)
        return button
    }()
    let completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setDimensions(width: 200, height: 50)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(handleComplete), for: .touchUpInside)
        return button
    }()
    
    let indicator = UIActivityIndicatorView()
    let db = Firestore.firestore()
    var userData = [UserDataModel]()
    var validNickName = false
    
    let email = Auth.auth().currentUser?.email
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    
    // MARK: - Selector
    
    @objc func textFieldDidChanged(_ textField: UITextField) {
        
        validNickName = false
    }
    
    @objc func handleCheck() {
        
//        print(nickNameCheck(nickNameTf: nickNameTf))
        
        db.collection("users").addSnapshotListener { (snapshot, error) in
            guard let documents = snapshot?.documents else {
                print("no documents")
                return
            }

            self.userData = documents.compactMap({ (queryDocSnapshot) -> UserDataModel? in
                let data = queryDocSnapshot.data()

                let point = data["point"] as? Int ?? 0
                let uid = data["uid"] as? String ?? ""
                let username = data["username"] as? String ?? ""

                if self.nickNameTf.text == data["username"] as? String {
                    self.showAlert(message: "중복된 닉네임입니다")
                } else if !self.nickNameTf.hasText {
                    self.showAlert(message: "사용할 닉네임을 입력해주세요")
                } else if self.nickNameTf.text?.hasWhiteSpace == true {
                    self.showAlert(message: "공백 금지")
                } else {
                    self.showAlert(message: "사용가능한 닉네임입니다.")
                    self.validNickName = true
                }

                return UserDataModel(point: point, uid: uid, username: username)
            })
        }
        
    }
    
    @objc func handleComplete() {
        
        if validNickName {
            
            db.collection("users").document(email!).setData([
                "username": nickNameTf.text], merge: true) { error in
                    if let err = error {
                        print(err.localizedDescription)
                    }
            }
            
            dismiss(animated: true, completion: nil)
        } else {
            showAlert(message: "닉네임 중복확인을 해주세요")
        }
    }
    
    
    // MARK: - Helper
    
    func configureUI() {
        
        view.backgroundColor = .green
        
        view.addSubview(indicator)
        indicator.center = view.center
        indicator.style = .large
        indicator.hidesWhenStopped = true
        
        let nickNameAndButton = UIStackView(arrangedSubviews: [nickNameTf, checkButton])
        nickNameAndButton.distribution = .fillProportionally
        
        let stack = UIStackView(arrangedSubviews: [nickNameAndButton, instructionLabel, completeButton])
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .fillProportionally
        
        view.addSubview(stack)
        
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 60, paddingLeft: 40, paddingRight: 40)
        
    }
    
    func showAlert(message: String) {

        let okAlert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
        okAlert.addAction(okButton)

        present(okAlert, animated: true, completion: nil)
    }
    
    
}
