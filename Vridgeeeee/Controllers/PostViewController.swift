//
//  PostViewController.swift
//  Vridgeeeee
//
//  Created by Kang Mingu on 2020/09/15.
//  Copyright © 2020 Kang Mingu. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    
    // MARK: - Properties
    
    let titleTf: UITextField = {
        let tf = UITextField()
        tf.placeholder = "title"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    let contentTv = UITextView()
    
    lazy var postButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "post", style: .plain, target: self, action: #selector(handlePost))
        return button
    }()
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    
    // MARK: - Selector
    
    @objc func handlePost() {
        
        print("handle post")
    }
    

    // MARK: - Helper
    
    func configureUI() {
        
        view.backgroundColor = .lightGray
        
        navigationItem.rightBarButtonItem = postButton
        
        view.addSubview(titleTf)
        view.addSubview(contentTv)
        
        titleTf.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 20, paddingRight: 20)
        contentTv.anchor(top: titleTf.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20, height: 300)
        
    }

}
