//
//  ViewController.swift
//  Vridgeeeee
//
//  Created by Kang Mingu on 2020/09/14.
//  Copyright © 2020 Kang Mingu. All rights reserved.
//

import UIKit
import AuthenticationServices
import FirebaseAuth
import FirebaseFirestore

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    let tableView = UITableView()
    
    lazy var logOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("log out", for: .normal)
        button.addTarget(self, action: #selector(handleLogOut), for: .touchUpInside)
        return button
    }()
    lazy var pointButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("point up", for: .normal)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(handlePoint), for: .touchUpInside)
        return button
    }()
    
    let email = Auth.auth().currentUser?.email
    
    var userDataModel = [UserDataModel]()
    var currentPoint: Int?
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    // MARK: - Selector
    
    @objc func handlePoint() {
        
        let db = Firestore.firestore()
        
        if let email = email {
            
            let datas = db.collection("users").document(email)
            
// 글을 올린적이 없다면 self.currentPoint에 0이 전달되기 때문에 포스트를 하게되면 currentPoint를 생성하면서1로 만들어줌.
// merge: true를 하지 않으면 uid와 username이 사라짐.
            datas.setData(["point": currentPoint! + 1], merge: true) { error in
                if let err = error {
                    print(err.localizedDescription)
                    return
                }
            }
        }
        
    }
    
    @objc func handleLogOut() {
        
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            
            DispatchQueue.main.async {
                let controller = LoginViewController()
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    
    // MARK: - Helper

    func configureUI() {
        
        if let _ = Auth.auth().currentUser {
            print("You're already logged in")
            fetchData()
        } else {
            DispatchQueue.main.async {
                let controller = LoginViewController()
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
        
        view.backgroundColor = .white
        
        view.addSubview(logOutButton)
        view.addSubview(pointButton)
        
        pointButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 30, paddingRight: 30)
        logOutButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 10)
        
    }
    
    
    func fetchData() {
        
        let db = Firestore.firestore()
        
        db.collection("users").document(email!).addSnapshotListener { (snapshot, error) in
            
            guard let documents = snapshot?.data() else {
                print("no documents man")
                return
            }
        
            let point = documents["point"] as? Int ?? 0
            let uid = documents["uid"] as? String ?? ""
            let username = documents["username"] as? String ?? ""
            
            self.currentPoint = point
        }
    }

}

