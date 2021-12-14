//
//  User.swift
//  auction
//
//  Created by Евгения Ренева on 03.12.2021.
//

import Foundation

enum UserType: String {
    case user = "user"
    case auctioneer = "auctioneer"
}

struct UserData: Identifiable {
    var id: String
    var balance: Int
    var userType: UserType

    init(id: String,
         balance: Int,
         userType: UserType) {
        self.id = id
        self.balance = balance
        self.userType = userType
    }

    init?(dictionary: [String : Any], id: String) {
        guard let balance = dictionary["balance"] as? Int,
              let userTypeValue = dictionary["userType"] as? String,
              let userType = UserType(rawValue: userTypeValue)
        else { return nil }

        self.init(id: id, balance: balance, userType: userType)
    }

    func convertToDict() -> [String : Any] {
        var dict: [String : Any] = [:]
        dict["balance"] = balance
        dict["userType"] = userType.rawValue
        return dict
    }
}
