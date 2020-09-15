//
//  UserDataModel.swift
//  Vridgeeeee
//
//  Created by Kang Mingu on 2020/09/14.
//  Copyright © 2020 Kang Mingu. All rights reserved.
//

import Foundation

public struct UserDataModel: Codable {
    
    var point: Int
    var uid: String
    var username: String?
    
    enum CodingKeys: String, CodingKey {
        case point
        case uid
        case username
    }
}
