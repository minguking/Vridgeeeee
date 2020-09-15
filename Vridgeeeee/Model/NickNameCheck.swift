//
//  NickNameCheck.swift
//  Vridgeeeee
//
//  Created by Kang Mingu on 2020/09/15.
//  Copyright © 2020 Kang Mingu. All rights reserved.
//

import Foundation
import FirebaseFirestore

func nickNameCheck(nickNameTf: UITextField) -> String {
    
    let db = Firestore.firestore()
    var userData = [UserDataModel]()
    var a = "nothing"
    
    db.collection("users").addSnapshotListener { (snapshot, error) in
        guard let documents = snapshot?.documents else {
            print("no documents")
            return
        }
        
        userData = documents.compactMap({ (queryDocSnapshot) -> UserDataModel? in
            let data = queryDocSnapshot.data()
            
            let point = data["point"] as? Int ?? 0
            let uid = data["uid"] as? String ?? ""
            let username = data["username"] as? String ?? ""
            
            if nickNameTf.text == data["username"] as? String {
                a = "중복된 닉네임입니다"
            } else if !nickNameTf.hasText {
                a = "사용할 닉네임을 입력해주세요"
            } else if nickNameTf.text?.hasWhiteSpace == true {
                a = "공백 금지"
            } else {
                a = "사용가능한 닉네임입니다."
            }
            
            return UserDataModel(point: point, uid: uid, username: username)
        })
    }
    return a
}
