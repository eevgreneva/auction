//
//  SellHistoryItem.swift
//  auction (iOS)
//
//  Created by Евгения Ренева on 10.12.2021.
//

import Foundation

struct SellHistoryItem: Identifiable {
    var id: String
    var byuerId: String
    var soldPrice: Int
    var lotId: String
    var sellerId: String

    init(id: String,
         byuerId: String,
         soldPrice: Int,
         lotId: String,
         sellerId: String) {
        self.id = id
        self.byuerId = byuerId
        self.soldPrice = soldPrice
        self.lotId = lotId
        self.sellerId = sellerId
    }

    init?(dictionary: [String : Any], id: String) {
        guard let byuerId = dictionary["byuerId"] as? String,
              let soldPrice = dictionary["soldPrice"] as? Int,
              let lotId = dictionary["lotId"] as? String,
              let sellerId = dictionary["sellerId"] as? String
        else { return nil }

        self.init(id: id, byuerId: byuerId, soldPrice: soldPrice, lotId: lotId, sellerId: sellerId)
    }

    func convertToDict() -> [String : Any] {
        var dict: [String : Any] = [:]
        dict["byuerId"] = byuerId
        dict["soldPrice"] = soldPrice
        dict["lotId"] = lotId
        dict["sellerId"] = sellerId
        return dict
    }
}
